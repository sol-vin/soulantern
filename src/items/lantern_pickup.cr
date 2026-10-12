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

      body_entered.connect do |body|
        on_body_entered(body)
      end
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
      player = find_player_ancestor(body)
      if player
        collect(player)
      end
    end

    def collect(player : Godot::Node) : Void
      @collected = true

      scene = @lantern_scene
      unless scene
        if ResourceLoader.exists("res://scenes/weapon/lantern.tscn")
          scene = ResourceLoader.load("res://scenes/weapon/lantern.tscn").as?(PackedScene)
        end
      end

      if scene
        lantern_inst = scene.instantiate
        if lantern_inst
          if player.has_method("equip_weapon")
            player.call("equip_weapon", lantern_inst)
          else
            player.add_child(lantern_inst)
            lantern_inst.call("equip", player) rescue nil
          end
        end
      end

      # Pickup sound
      Sounds.play("sting 1", self, 0.0_f32, 1.2_f32)
      emit(picked_up, player)

      queue_free
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
