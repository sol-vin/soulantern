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
    property direction : Vector3 = Vector3.new(0, 0, -1)

    def _ready : Void
      self.collision_layer = 0_u32
      self.collision_mask = 1_u32
      self.velocity = @direction.normalized * @speed
    end

    def _physics_process(delta : Float64) : Void
      d = delta.to_f32
      collision = move_and_collide(velocity * d)
      if collision
        detonate(collision.get_position, collision.get_normal)
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
            body = p.as?(CharacterBody3D)
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

        if l = @launcher
          l.call("emit_signal", "player_flung", impulse, norm, dist) rescue nil
        end
      end
    end

    def spawn_explosion_effect(hit_point : Vector3, hit_normal : Vector3) : Void
      trail = FireTrail.new
      trail.global_position = hit_point + hit_normal * 0.1_f32
      trail.burn_duration = 1.2_f32
      trail.fade_duration = 0.4_f32

      if parent = get_parent?
        parent << trail
      elsif tree = Godot.get_tree?
        tree.get_root?.try(&.<<(trail))
      end
    end
  end
end
