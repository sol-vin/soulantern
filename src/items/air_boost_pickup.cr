require "lapis"

module Soulantern
  # World pickup item that provides an upward vertical launch impulse and resets downward velocity.
  node AirBoostPickup < Area3D do
    signal picked_up(player : Godot::Node)
    signal respawned

    @[Export]

    property boost_force : Float32 = 24.0_f32
    @[Export]
    property replenish_time : Float32 = 3.0_f32
    @[Export]
    property bob_speed : Float32 = 3.0_f32
    @[Export]
    property bob_height : Float32 = 0.08_f32
    @[Export]
    property rotate_speed : Float32 = 1.5_f32

    @is_available : Bool = true
    @initial_y : Float32 = 0.0_f32
    @model : Node3D? = nil

    def _ready : Void
      return if Engine.is_editor_hint
      @initial_y = position.y

      self.collision_layer = 8_u32
      self.collision_mask = 2_u32

      if has_node("Model")
        @model = get_node("Model").as?(Node3D)
      end

      body_entered.connect do |body|
        on_body_entered(body)
      end
    end

    def _process(delta : Float64) : Void
      return if Engine.is_editor_hint
      return unless @is_available

      d = delta.to_f32
      rotate_y(rotate_speed * d)
      ticks = Godot::Time.get_ticks_msec.to_f32 * 0.001_f32
      pos = position
      pos.y = @initial_y + Math.sin(ticks * @bob_speed).to_f32 * @bob_height
      self.position = pos
    end

    def on_body_entered(body : Godot::Node) : Void
      return unless @is_available
      player = find_player_ancestor(body)
      if player
        try_collect(player)
      end
    end

    def try_collect(player : Godot::Node) : Bool
      return false unless @is_available

      body = player.as?(CharacterBody3D)
      return false unless body

      # Cancel dash if dashing
      if tree = Godot.get_tree?
        if lantern = tree.get_first_node_in_group?("lantern")
          lantern.call("cancel_dash", true) rescue nil
        end
      end

      # Reset downward momentum
      vel = body.velocity
      if vel.y < 0.0_f32
        vel.y = 0.0_f32
      end
      vel.y += @boost_force
      body.velocity = vel

      # Reset fall distance tracking
      body.call("reset_fall_distance") rescue nil

      consume(player)
      true
    end

    def consume(player : Godot::Node) : Void
      @is_available = false
      emit(picked_up, player)

      thump_idx = rand(1..6)
      Sounds.play("big distant thump #{thump_idx}", self, 0.0_f32, 1.0_f32)

      if m = @model
        if tw = create_tween
          tw.tween_property(m, "scale", Vector3.new(0, 0, 0), 0.2_f32)
            .set_trans(Tween::TransitionType::TransBack)
            .set_ease(Tween::EaseType::EaseIn)
          tw.finished.connect do
            hide_model
          end
        end
      end

      self.monitoring = false

      if tree = Godot.get_tree?
        timer = tree.create_timer(@replenish_time.to_f64)
        if timer
          timer.timeout.connect do
            respawn
          end
        end
      end
    end

    def hide_model : Void
      if m = @model
        m.visible = false
      end
    end

    def respawn : Void
      @is_available = true
      if m = @model
        m.visible = true
        tw = create_tween
        if tw
          tw.tween_property(m, "scale", Vector3.new(1, 1, 1), 0.35_f32)
            .set_trans(Tween::TransitionType::TransBack)
            .set_ease(Tween::EaseType::EaseOut)
        end
      end
      self.monitoring = true
      emit(respawned)
    end

    def find_player_ancestor(node : Godot::Node) : Godot::Node?
      curr : Godot::Node? = node
      while curr
        return curr if curr.is_in_group("player") || curr.name == "Player"
        curr = curr.get_parent?
      end
      nil
    end
  end
end
