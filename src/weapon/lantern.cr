require "lapis"

module Soulantern
  # Lantern: Primary mobility and utility equipment for the player.
  # Left Click: Launches a rocket-jump projectile that detonates on surfaces and flings the player.
  # Right Click: High-velocity horizontal air dash with blue floor fire trails and exit momentum retention.
  node Lantern < Node3D do
    signal rocket_jump_attempted
    signal rocket_jump_fired(hit_point : Vector3, normal : Vector3, hit_surface : Bool)
    signal player_flung(force_vector : Vector3, hit_normal : Vector3, distance_to_explosion : Float32)
    signal dash_started(direction : Vector3, dashes_left : Int32)
    signal dash_ended(final_velocity : Vector3)
    signal dash_charges_changed(current_charges : Int32, max_charges : Int32)
    signal dash_charges_reset(total_charges : Int32)
    signal dash_failed_empty
    signal equipped(player : Godot::Node)

    # --- Configuration Properties ---
    @[Export]
    property rocket_jump_force : Float32 = 22.0_f32
    @[Export]
    property explosion_radius : Float32 = 7.0_f32
    @[Export]
    property max_dashes : Int32 = 2
    @[Export]
    property dash_speed : Float32 = 24.0_f32
    @[Export]
    property dash_duration : Float32 = 0.2_f32
    @[Export]
    property dash_exit_speed_ratio : Float32 = 0.8_f32
    @[Export]
    property dash_trail_spacing : Float32 = 0.8_f32
    @[Export]
    property projectile_speed : Float32 = 38.0_f32

    # --- State ---
    property current_dashes : Int32 = 2
    property player : Godot::Node? = nil

    @was_airborne : Bool = false
    @is_dashing : Bool = false
    @dash_timer : Float32 = 0.0_f32
    @dash_dir : Vector3 = Vector3.new(0, 0, 0)
    @last_trail_pos : Vector3 = Vector3.new(0, 0, 0)
    group "lantern"

    onready? anim_player : AnimationPlayer? = "%Player"

    def find_animation_player : AnimationPlayer?
      anim_player
    end

    def _ready : Void
      @current_dashes = @max_dashes

      # Ensure any UI overlay / animation player controls don't capture mouse events
      find_children(/.*/, Control, recursive: true).each do |c|
        c.mouse_filter = Control::MouseFilter::MouseFilterIgnore
      end

      rocket_jump_attempted >> ->{
        play_fire_animation
        play_rocket_fire_sound
      }

      dash_started >> ->{
        play_dash_animation
        play_dash_sound
      }

      # Auto-discover player if already spawned in scene tree
      discover_player unless @player
    end

    def play_dash_animation : Void
      if ap = find_animation_player
        ap.play("dash") rescue nil
      end
    end

    def play_dash_sound : Void
      Sounds.play("dash", self)
    end

    def play_fire_animation : Void
      if ap = find_animation_player
        ap.play("fire") rescue nil
      end
    end

    def play_rocket_fire_sound : Void
      Sounds.play("laser gun 1", self)
    end

    def discover_player : Void
      if tree = Godot.get_tree?
        if p = tree.get_first_node_in_group?("player")
          equip(p)
        end
      end
    end

    def equip(target_player : Godot::Node) : Void
      @player = target_player
      emit(equipped, target_player)
      Godot.log_info("Lantern", "Lantern equipped to #{target_player.name}")
    end

    def _input(event : InputEvent) : Void
      if event.is_action_pressed("lantern_primary")
        try_fire_rocket_jump
      elsif event.is_action_pressed("lantern_secondary")
        try_start_dash
      end
    end

    def _physics_process(delta : Float64) : Void
      d = delta.to_f32

      if @is_dashing
        process_dash(d)
      end

      check_ground_dash_reset
    end

    # --------------------------------------------------------------------------
    # Rocket Jump (Primary Fire)
    # --------------------------------------------------------------------------

    def try_fire_rocket_jump : Void
      return if @is_dashing

      emit(rocket_jump_attempted)

      # Play animation
      if ap = find_animation_player
        if ap.has_animation("fire")
          ap.stop
          ap.play("fire")
        end
      end

      # Play firing sound
      Sounds.play("sting 1", self, 0.0_f32, 1.0_f32)

      spawn_projectile
    end

    def spawn_projectile : Void
      cam = get_player_camera
      return unless cam

      proj = LanternProjectile.new
      proj.speed = @projectile_speed
      proj.rocket_jump_force = @rocket_jump_force
      proj.explosion_radius = @explosion_radius
      proj.player_body = get_player_body
      proj.launcher = self

      # Forward direction from camera
      forward = -cam.global_transform.basis.z.normalized
      proj.direction = forward
      proj.global_position = cam.global_position + forward * 0.5_f32

      if parent = get_parent?
        parent << proj
      elsif tree = Godot.get_tree?
        tree.get_root?.try(&.<<(proj))
      end
    end

    # --------------------------------------------------------------------------
    # Air Dash (Secondary Fire)
    # --------------------------------------------------------------------------

    def try_start_dash : Void
      return if @is_dashing

      if @current_dashes <= 0
        emit(dash_failed_empty)
        return
      end

      cam = get_player_camera
      return unless cam

      body = get_player_body
      return unless body

      @current_dashes -= 1
      @is_dashing = true
      @dash_timer = @dash_duration

      # Horizontal look direction
      forward = -cam.global_transform.basis.z
      forward_horiz = Vector3.new(forward.x, 0, forward.z)
      if forward_horiz.length_squared > 0.001_f32
        @dash_dir = forward_horiz.normalized
      else
        @dash_dir = Vector3.new(0, 0, -1)
      end

      @last_trail_pos = body.global_position

      # Reset player fall distance tracking on dash
      body.call("reset_fall_distance") rescue nil

      # Play animation and sound
      if ap = find_animation_player
        if ap.has_animation("dash")
          ap.stop
          ap.play("dash")
        end
      end
      Sounds.play("dash", self, 0.0_f32, 1.0_f32)

      emit(dash_started, @dash_dir, @current_dashes)
      emit(dash_charges_changed, @current_dashes, @max_dashes)
    end

    def process_dash(delta : Float32) : Void
      body = get_player_body
      unless body
        @is_dashing = false
        return
      end

      @dash_timer -= delta

      # Force velocity along dash direction
      vel = Vector3.new(@dash_dir.x * @dash_speed, 0.0_f32, @dash_dir.z * @dash_speed)
      body.velocity = vel

      # Spawn floor fire trail if within reach of ground
      check_spawn_dash_fire_trail(body.global_position)

      if @dash_timer <= 0.0_f32
        @is_dashing = false
        # Retain exit momentum
        exit_vel = Vector3.new(vel.x * @dash_exit_speed_ratio, 0.0_f32, vel.z * @dash_exit_speed_ratio)
        body.velocity = exit_vel

        # Reset animation
        if ap = find_animation_player
          if ap.has_animation("RESET")
            ap.play("RESET")
          end
        end

        emit(dash_ended, exit_vel)
      end
    end

    def cancel_dash(refund : Bool = false) : Void
      if @is_dashing
        @is_dashing = false
        if refund && @current_dashes < @max_dashes
          @current_dashes += 1
          emit(dash_charges_changed, @current_dashes, @max_dashes)
        end
      end
    end

    def check_spawn_dash_fire_trail(player_pos : Vector3) : Void
      dist = (player_pos - @last_trail_pos).length
      return if dist < @dash_trail_spacing

      trail = FireTrail.new
      trail.fire_color = FireTrail::FireColor::BLUE
      trail.global_position = player_pos + Vector3.new(0, 0.05_f32, 0)
      trail.burn_duration = 1.8_f32
      trail.fade_duration = 0.5_f32

      if parent = get_parent?
        parent << trail
      elsif tree = Godot.get_tree?
        tree.get_root?.try(&.<<(trail))
      end

      @last_trail_pos = player_pos
    end

    def check_ground_dash_reset : Void
      body = get_player_body
      return unless body

      if body.is_on_floor
        if @was_airborne && @current_dashes < @max_dashes
          @current_dashes = @max_dashes
          emit(dash_charges_reset, @max_dashes)
          emit(dash_charges_changed, @current_dashes, @max_dashes)
        end
        @was_airborne = false
      else
        @was_airborne = true
      end
    end

    def replenish_dash(amount : Int32 = 1, force : Bool = false) : Bool
      if @current_dashes < @max_dashes || force
        @current_dashes = Math.min(@max_dashes, @current_dashes + amount)
        emit(dash_charges_changed, @current_dashes, @max_dashes)
        true
      else
        false
      end
    end

    # --------------------------------------------------------------------------
    # Helper Accessors
    # --------------------------------------------------------------------------

    def get_player_body : CharacterBody3D?
      if p = @player
        if cb = p.as?(CharacterBody3D)
          return cb
        elsif p.is_class("CharacterBody3D")
          return CharacterBody3D.new(p.pointer)
        end
      end
      nil
    end

    def get_player_camera : Camera3D?
      if p = @player
        if pc = p.as?(PlayerController)
          return pc.get_spring_arm_camera
        end
      end
      self << Camera3D?
    end
  end
end
