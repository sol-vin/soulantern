require "lapis"

module Soulantern
  # World pickup item that equips the Lantern weapon to the Player.
  node LanternPickup < Area3D do
    signal picked_up(player : Godot::Node)

    @[Export]

    property lantern_scene : PackedScene? = nil
    @[Export]
    property bob_speed : Float32 = 3.0_f32
    @[Export]
    property bob_height : Float32 = 0.08_f32
    @[Export]
    property rotate_speed : Float32 = 1.5_f32

    @initial_y : Float32 = 0.0_f32
    @collected : Bool = false

    def _ready : Void
      return if Engine.is_editor_hint
      @initial_y = position.y

      self.collision_layer = 8_u32
      self.collision_mask = 2_u32

      body_entered >> ->(body : Godot::Node) { on_body_entered(body) }
    end

    def _process(delta : Float64) : Void
      return if Engine.is_editor_hint
      return if @collected

      d = delta.to_f32
      rotate_y(rotate_speed * d)
      ticks = Godot::Time.get_ticks_msec.to_f32 * 0.001_f32
      pos = position
      pos.y = @initial_y + Math.sin(ticks * @bob_speed).to_f32 * @bob_height
      self.position = pos
    end

    def on_body_entered(body : Godot::Node) : Void
      return if @collected
      if player = body.self_or_ancestor?(PlayerController) || (body.in_group_or_ancestor?("player") ? body : nil)
        collect(player)
      end
    end

    def collect(player : Godot::Node) : Void
      @collected = true

      lantern_inst = @lantern_scene.try(&.instantiate_as?(Lantern)) ||
                     ("res://scenes/weapon/lantern.tscn" > Lantern?) ||
                     Godot.instantiate_scene?("res://scenes/weapon/lantern.tscn", Lantern)


      if lantern_inst && !lantern_inst.pointer.null?
        if pc = player.self_or_ancestor?(PlayerController)
          pc.equip_weapon(lantern_inst)
        elsif player.has_method("equip_weapon")
          player.call("equip_weapon", lantern_inst)
        else
          player << lantern_inst
          lantern_inst.call("equip", player) rescue nil
        end
      end

      # Pickup sound
      Sounds.play("sting 1", self, 0.0_f32, 1.2_f32)
      emit(picked_up, player)

      queue_free
    end
  end
end

