require "lapis"

module Soulantern
  # Physical projectile fired by the Lantern's primary attack (Left Click).
  # Collides exclusively with world geometry (Layer 1) and applies a rocket-jump
  # physics impulse to the Player upon detonation within its blast radius.
  node LanternProjectile < CharacterBody3D do
    @[Export]
    property speed : Float32 = 38.0_f32
    @[Export]
    property explosion_radius : Float32 = 7.0_f32
    @[Export]
    property rocket_jump_force : Float32 = 22.0_f32
    @[Export]
    property cancel_opposing_velocity : Bool = true

    property player_body : CharacterBody3D? = nil
    property launcher : Godot::Node? = nil
    getter direction : Vector3 = Vector3.new(0, 0, -1)
    @lifetime : Float32 = 5.0_f32
    @has_exploded : Bool = false

    def direction=(dir : Vector3)
      @direction = dir.normalized
      self.velocity = @direction * @speed
      if is_inside_tree && @velocity.length_squared > 0.001_f32
        up = @velocity.normalized.y.abs < 0.95_f32 ? Vector3::UP : Vector3::RIGHT
        look_at(global_position + @velocity, up) rescue nil
      end
    end

    def speed=(spd : Float32)
      @speed = spd
      self.velocity = @direction.normalized * @speed
    end

    def launch(launcher : Godot::Node, body : CharacterBody3D, dir : Vector3, spd : Float32, jump_force : Float32, radius : Float32) : Void
      @launcher = launcher
      @player_body = body
      @speed = spd
      @rocket_jump_force = jump_force
      @explosion_radius = radius
      setup_collision_exceptions(body)
      self.direction = dir
    end

    def setup_collision_exceptions(body : CharacterBody3D) : Void
      add_collision_exception_with(body)
      if parent_node = body.get_parent?
        parent_node.find_children(/.*/, CollisionObject3D, recursive: true).each do |child|
          add_collision_exception_with(child)
        end
      end
    end


    def _ready : Void
      add_to_group("projectiles")
      self.collision_layer = 0_u32
      self.collision_mask = 1_u32
      if pb = @player_body
        setup_collision_exceptions(pb)
      end
      self.velocity = @direction.normalized * @speed
      if @velocity.length_squared > 0.001_f32
        up = @velocity.normalized.y.abs < 0.95_f32 ? Vector3::UP : Vector3::RIGHT
        look_at(global_position + @velocity, up) rescue nil
      end
    end

    def _physics_process(delta : Float64) : Void
      return if @has_exploded
      d = delta.to_f32
      @lifetime -= d
      if @lifetime <= 0.0_f32
        @has_exploded = true
        detonate(global_position, Vector3::UP)
        return
      end

      collision = move_and_collide(velocity * d)
      if collision && !collision.null?
        @has_exploded = true
        normal = collision.get_normal
        if normal.length_squared < 0.001_f32
          normal = velocity.length_squared > 0.001_f32 ? -velocity.normalized : Vector3::UP
        else
          normal = normal.normalized
        end
        detonate(collision.get_position, normal)
      end
    end

    def detonate(hit_point : Vector3, hit_normal : Vector3) : Void
      # Spawn explosion fire trail at impact surface
      spawn_explosion_effect(hit_point, hit_normal)

      # Check player proximity and apply rocket jump impulse
      apply_impulse_to_player(hit_point, hit_normal)

      # Detonation audio
      Sounds.play("sting 1", self, 0.0_f32, 1.0_f32)

      queue_free
    end

    def apply_impulse_to_player(hit_point : Vector3, hit_normal : Vector3) : Void
      body = @player_body
      unless body
        if tree = Godot.get_tree?
          if p = tree.get_first_node_in_group?("player")
            body = p.as_a?(CharacterBody3D)
          end
        end
      end
      return unless body

      body_center = body.global_position + Vector3.new(0, 0.9_f32, 0)
      dist = (body_center - hit_point).length

      if dist <= @explosion_radius
        norm = hit_normal.normalized
        vel = body.velocity

        if @cancel_opposing_velocity
          opposing = vel.dot(norm)
          if opposing < 0.0_f32
            vel -= norm * opposing
          end
        end

        impulse = norm * @rocket_jump_force
        vel += impulse
        body.velocity = vel

        if pc = body.as_a?(PlayerController)
          pc.reset_fall_distance
        else
          body.call("reset_fall_distance") rescue nil
        end

        if l = @launcher
          l.call("emit_signal", "player_flung", impulse, norm, dist) rescue nil
        end
      end
    end

    def spawn_explosion_effect(hit_point : Vector3, hit_normal : Vector3) : Void
      scene = ResourceLoader.load("res://scenes/weapon/fire_trail.tscn").as?(PackedScene)
      node = scene.try(&.instantiate)
      trail = if node && !node.pointer.null?
                if inst = Bridge.find_alive_instance(node.pointer)
                  inst.as?(FireTrail) || FireTrail.new(node.pointer)
                else
                  FireTrail.new(node.pointer)
                end
              else
                FireTrail.create
              end

      trail.burn_duration = 1.2_f32
      trail.fade_duration = 0.4_f32

      if tree = Godot.get_tree?
        target_parent = tree.current_scene || tree.get_root?
        if target_parent
          target_parent.add_child(trail)
          trail.global_position = hit_point + hit_normal * 0.1_f32
        end
      elsif parent = get_parent?
        parent.add_child(trail)
        trail.global_position = hit_point + hit_normal * 0.1_f32
      end
    end
  end
end
