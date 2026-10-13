require "lapis"

module Soulantern
  # Native Crystal implementation of the GoldSrc / Quake movement platformer character controller.
  # Replaces the external goldsrc_character_controller addon with high-performance LLVM-compiled physics.
  node PlayerController < CharacterBody3D do
    signal on_teleport

    # --- Configuration Properties ---
    @[Export]
    property forward_speed : Float32 = 8.0_f32
    @[Export]
    property side_speed : Float32 = 3.0_f32
    @[Export]
    property max_speed : Float32 = 8.0_f32
    @[Export]
    property max_horizontal_speed : Float32 = 70.0_f32
    @[Export]
    property max_air_speed : Float32 = 0.762_f32
    @[Export]
    property stop_speed : Float32 = 1.0_f32
    @[Export]
    property jump_height : Float32 = 1.0_f32
    @[Export]
    property step_height : Float32 = 0.457_f32
    @[Export]
    property gravity : Float32 = 20.32_f32
    @[Export]
    property acceleration : Float32 = 10.0_f32
    @[Export]
    property air_acceleration : Float32 = 10.0_f32
    @[Export]
    property friction : Float32 = 10.0_f32
    @[Export]
    property autohop : Bool = true
    @[Export]
    property mouse_sensitivity : Float32 = 12.0_f32
    @[Export]
    property max_fall_distance : Float32 = 20.0_f32

    # --- View & Aesthetics ---
    @[Export]
    property bob_frequency : Float32 = 0.008_f32
    @[Export]
    property bob_fraction : Float32 = 12.0_f32
    @[Export]
    property roll_angle : Float32 = 0.65_f32
    @[Export]
    property roll_speed : Float32 = 300.0_f32

    # --- Internal State ---
    property current_weapon : Godot::Node? = nil
    property? movement_locked : Bool = false
    property? disable_input : Bool = false
    property is_dead : Bool = false

    @highest_fall_y : Float32 = 0.0_f32
    @is_falling : Bool = false
    getter yaw_angle : Float32 = 0.0_f32
    getter pitch_angle : Float32 = 0.0_f32
    @wishdir : Vector3 = Vector3.new(0, 0, 0)
    @wishspeed : Float32 = 0.0_f32

    # Horizontal look direction (XZ-plane) computed from camera or current yaw angle
    def look_direction : Vector3
      if cam = camera
        f = -cam.global_transform.basis.z
        h = Vector3.new(f.x, 0.0_f32, f.z)
        return h.length_squared > 0.001_f32 ? h.normalized : Vector3.new(0, 0, -1).rotated(Vector3::UP, @yaw_angle)
      end
      Vector3.new(0, 0, -1).rotated(Vector3::UP, @yaw_angle)
    end

    # Full 3D aiming vector incorporating pitch and yaw
    def aim_direction : Vector3
      if cam = camera
        return -cam.global_transform.basis.z.normalized
      end
      Vector3.new(0, 0, -1).rotated(Vector3::RIGHT, @pitch_angle).rotated(Vector3::UP, @yaw_angle)
    end

    group "player"

    # Child node references
    onready camera_yaw : Node3D = "%CameraYaw"
    onready camera_pitch : Node3D = "%CameraPitch"
    onready camera : Camera3D = "%Camera"
    onready flash_rect : ColorRect = "%Flash"

    def _ready : Void
      self.collision_layer = 2_u32
      self.collision_mask = 5_u32
      self.safe_margin = 0.002_f32

      setup_camera_hierarchy
      @highest_fall_y = global_position.y
      @is_falling = false

      Input.mouse_mode = Input::MouseMode::MouseModeCaptured
      Input.use_accumulated_input = false
    end

    def setup_camera_hierarchy : Void
      cam = camera
      cam.current = true
      fr = flash_rect
      fr.mouse_filter = Control::MouseFilter::MouseFilterIgnore
    end

    def _unhandled_input(event : InputEvent) : Void
      if mouse_motion = event.as_a?(InputEventMouseMotion)
        if Input.mouse_mode == Input::MouseMode::MouseModeCaptured
          gather_mouse_input(mouse_motion)
        end
      elsif mouse_button = event.as_a?(InputEventMouseButton)
        if mouse_button.button_index == 1 && Input.mouse_mode != Input::MouseMode::MouseModeCaptured
          Input.mouse_mode = Input::MouseMode::MouseModeCaptured
        end
      elsif key_event = event.as_a?(InputEventKey)
        if key_event.pressed && !key_event.echo
          # F11 or Alt+Enter toggles fullscreen
          if key_event.keycode == Key::F11.value || (key_event.alt_pressed && key_event.keycode == Key::Enter.value)
            mode = DisplayServer.window_get_mode
            if mode == DisplayServer::WindowMode::WindowModeFullscreen || mode == DisplayServer::WindowMode::WindowModeExclusiveFullscreen
              DisplayServer.window_set_mode(DisplayServer::WindowMode::WindowModeWindowed)
            else
              DisplayServer.window_set_mode(DisplayServer::WindowMode::WindowModeFullscreen)
            end
          end
        end
      end
    end

    def gather_mouse_input(event : InputEventMouseMotion) : Void
      sensitivity = @mouse_sensitivity * 0.0001_f32
      rel = event.relative

      @yaw_angle -= (rel.x * sensitivity).to_f32
      @pitch_angle -= (rel.y * sensitivity).to_f32

      deg89 = 89.0_f32 * (Math::PI.to_f32 / 180.0_f32)
      @pitch_angle = Math.max(-deg89, Math.min(deg89, @pitch_angle))

      camera_yaw.rotation = Vector3.new(0, @yaw_angle, 0)
      camera_pitch.rotation = Vector3.new(@pitch_angle, 0, 0)
    end


    def _physics_process(delta : Float64) : Void
      d = delta.to_f32
      vel = velocity
      prev_on_floor = is_on_floor

      # While movement is locked (e.g. during an air dash), preserve velocity and bypass friction/gravity
      if @movement_locked
        move_and_slide
        cap_horizontal_velocity
        update_camera_effects(d)
        update_fall_tracking(prev_on_floor)
        return
      end

      # Apply Gravity
      unless prev_on_floor
        vel.y -= @gravity * d
      end

      # Gather Directional Movement Inputs
      if @disable_input
        @wishdir = Vector3.new(0, 0, 0)
        @wishspeed = 0.0_f32
      else
        gather_movement_input
      end

      # Jump & Bunnyhop handling
      jump_pressed = @autohop ? Input.is_action_pressed("pm_jump") : Input.is_action_just_pressed("pm_jump")

      if prev_on_floor
        if jump_pressed
          jump_impulse = (Math.sqrt(2.0_f32 * @gravity * @jump_height) - (@gravity * d * 0.5_f32)).to_f32
          vel.y = jump_impulse
          self.velocity = vel
          air_accelerate(d)
        else
          self.velocity = vel
          friction(d)
          accelerate(d)
        end
      else
        self.velocity = vel
        air_accelerate(d)
      end

      # Stair step climbing
      check_for_step(d)

      # Execute Godot CharacterBody3D move_and_slide
      move_and_slide

      # Cap horizontal speed
      cap_horizontal_velocity

      # Camera bobbing & tilt
      update_camera_effects(d)

      # Fall tracking & fatal fall check (> 20.0m)
      update_fall_tracking(prev_on_floor)
    end

    def gather_movement_input : Void
      ix = Input.get_action_strength("pm_moveright") - Input.get_action_strength("pm_moveleft")
      iy = Input.get_action_strength("pm_movebackward") - Input.get_action_strength("pm_moveforward")

      move_input = Vector3.new(ix, 0, iy)
      if move_input.length_squared > 0.0001_f32
        move_input = move_input.normalized
      end

      speeds = Vector3.new(move_input.x * @side_speed, 0, move_input.z * @forward_speed)
      rotated = speeds.rotated(Vector3::UP, @yaw_angle)

      speed = rotated.length
      if speed > @max_speed
        rotated = rotated * (@max_speed / speed)
        speed = @max_speed
      end

      @wishspeed = speed
      @wishdir = speed > 0.0001_f32 ? rotated.normalized : Vector3.new(0, 0, 0)
    end

    def friction(delta : Float32) : Void
      vel = velocity
      speed = Vector3.new(vel.x, 0, vel.z).length
      return if speed < 0.0001_f32

      control = speed < @stop_speed ? @stop_speed : speed
      drop = control * @friction * delta
      new_speed = Math.max(0.0_f32, speed - drop)
      new_speed /= speed

      vel.x *= new_speed
      vel.z *= new_speed
      self.velocity = vel
    end

    def accelerate(delta : Float32) : Void
      return if @wishspeed <= 0.0001_f32
      vel = velocity
      current_speed = vel.dot(@wishdir)
      add_speed = @wishspeed - current_speed
      return if add_speed <= 0.0_f32

      accel_speed = @acceleration * @wishspeed * delta
      accel_speed = Math.min(accel_speed, add_speed)

      vel += @wishdir * accel_speed
      self.velocity = vel
    end

    def air_accelerate(delta : Float32) : Void
      return if @wishspeed <= 0.0001_f32
      vel = velocity
      wishspd = Math.min(@wishspeed, @max_air_speed)
      current_speed = vel.dot(@wishdir)
      add_speed = wishspd - current_speed
      return if add_speed <= 0.0_f32

      accel_speed = @air_acceleration * @wishspeed * delta
      accel_speed = Math.min(accel_speed, add_speed)

      vel += @wishdir * accel_speed
      self.velocity = vel
    end

    def cap_horizontal_velocity : Void
      vel = velocity
      horiz_speed = Math.sqrt(vel.x * vel.x + vel.z * vel.z).to_f32
      if horiz_speed > @max_horizontal_speed
        scale = @max_horizontal_speed / horiz_speed
        vel.x *= scale
        vel.z *= scale
        self.velocity = vel
      end
    end

    # Detects and climbs small stair steps up to step_height without snagging
    def check_for_step(delta : Float32) : Void
      return unless is_on_floor
      vel = velocity
      return if vel.length_squared < 0.01_f32

      collision = move_and_collide(vel * delta, true, 0.001_f32)
      if collision && !collision.null?
        normal = collision.get_normal
        if normal.y < 0.7_f32
          move_step(delta)
        end
      end
    end

    def move_step(delta : Float32) : Void
      orig_pos = global_position
      vel = velocity
      dest = orig_pos + Vector3.new(vel.x * delta, @step_height, vel.z * delta)

      # 1. Step up and forward
      step_test = move_and_collide(Vector3.new(0, @step_height, 0), true, 0.001_f32)
      return if step_test && !step_test.null? # Headroom blocked

      # 2. Step forward
      fwd_test = move_and_collide(Vector3.new(vel.x * delta, 0, vel.z * delta), true, 0.001_f32)

      # 3. Step back down to ground
      down_test = move_and_collide(Vector3.new(0, -@step_height * 1.5_f32, 0), true, 0.001_f32)
      if down_test && !down_test.null? && down_test.get_normal.y >= 0.7_f32
        self.global_position = dest + Vector3.new(0, -@step_height, 0)
      end
    end

    def update_camera_effects(delta : Float32) : Void
      vel = velocity
      horiz_speed = Math.sqrt(vel.x * vel.x + vel.z * vel.z).to_f32

      # Camera Bobbing
      cp = camera_pitch
      if is_on_floor && horiz_speed > 0.1_f32

        ticks = Godot::Time.get_ticks_msec.to_f32
        bob = Math.sin(ticks * @bob_frequency).to_f32 / @bob_fraction
        bob *= (horiz_speed / (2.0_f32 * @forward_speed))
        cp.position = Vector3.new(0, bob, 0)
      else
        cp.position = Vector3.new(0, 0, 0)
      end

      # Strafe Roll Tilt
      cam = camera
      cy = camera_yaw
      side = vel.dot(cy.transform.basis.x)
      roll_sign = side < 0.0_f32 ? 1.0_f32 : -1.0_f32
      side = side.abs
      roll_val = side < @roll_speed ? (side * @roll_angle / @roll_speed) : @roll_angle
      cam.rotation = Vector3.new(0, 0, (roll_val * roll_sign * (Math::PI.to_f32 / 180.0_f32)))

    end

    def update_fall_tracking(prev_on_floor : Bool) : Void
      if is_on_floor
        if !prev_on_floor && @is_falling
          fall_dist = @highest_fall_y - global_position.y
          if fall_dist > @max_fall_distance
            die_from_fall(fall_dist)
            return
          end
        end
        @is_falling = false
        @highest_fall_y = global_position.y
      else
        unless @is_falling
          @is_falling = true
          @highest_fall_y = global_position.y
        end

        if global_position.y > @highest_fall_y
          @highest_fall_y = global_position.y
        else
          fall_dist = @highest_fall_y - global_position.y
          if fall_dist > @max_fall_distance
            die_from_fall(fall_dist)
          end
        end
      end
    end

    def die_from_fall(distance : Float32) : Void
      Godot.log_info("Player", "Fatal fall detected: #{distance}m fallen. Killing player...")
      @is_falling = false
      @highest_fall_y = global_position.y
      if tree = Godot.get_tree?
        if root = tree.get_root?
          if root.has_node("Functions")
            root.get_node("Functions").call("kill")
          end
        end
      end
    end

    def reset_fall_distance : Void
      @highest_fall_y = global_position.y
      @is_falling = !is_on_floor
    end

    # --------------------------------------------------------------------------
    # Public API & Weapon Socketing
    # --------------------------------------------------------------------------

    def get_player_body : CharacterBody3D
      self
    end

    def get_spring_arm_camera : Camera3D?
      camera
    end

    def equip_weapon(weapon_node : Godot::Node) : Void
      return if weapon_node.pointer.null?
      @current_weapon = weapon_node
      target_parent : Godot::Node = camera
      return if target_parent.pointer.null?

      if weapon_node.get_parent? != target_parent
        if old_p = weapon_node.get_parent?
          weapon_node.call("reparent", target_parent) rescue nil
        else
          target_parent << weapon_node
        end
      end

      if node3d = weapon_node.as_a?(Node3D)
        node3d.transform = Transform3D.new
      end

      if l = weapon_node.as_a?(Lantern)
        l.equip(self)
      else
        weapon_node.call("equip", self) rescue nil
      end
    end

    def replenish_dash(amount : Int32 = 1) : Bool
      if w = @current_weapon
        if l = w.as_a?(Lantern)
          return l.replenish_dash(amount)
        end
      end
      false
    end

    def lock_movement(locked : Bool) : Void
      @movement_locked = locked
    end

    def turn_on : Void
      self.process_mode = Node::ProcessMode::ProcessModePausable
      camera.make_current
    end


    def turn_off : Void
      self.process_mode = Node::ProcessMode::ProcessModeDisabled
    end

    def teleport_in_relation_to(begin_node : Node3D, end_node : Node3D, y_rotation : Float32 = 0.0_f32) : Void
      player_offset = global_position - begin_node.global_position
      player_offset = player_offset.rotated(Vector3::UP, y_rotation)

      self.velocity = velocity.rotated(Vector3::UP, y_rotation)
      self.global_position = end_node.global_position + player_offset
      @yaw_angle += y_rotation

      reset_fall_distance
      emit(on_teleport)
    end

    def move_to(target_position : Vector3, y_rotation : Float32 = 0.0_f32) : Void
      self.position = target_position
      self.velocity = Vector3.new(0, 0, 0)
      @yaw_angle = y_rotation
      @pitch_angle = 0.0_f32
      reset_fall_distance
    end
  end
end
