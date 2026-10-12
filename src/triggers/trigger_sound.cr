require "lapis"

module Soulantern
  # TrenchBroom / FuncGodot brush entity trigger that plays a sound through Sounds when entered by the Player.
  node TriggerSound < Area3D do
    @[Export]
    property sound_name : String = ""
    @[Export]
    property once : Bool = false
    @[Export]
    property volume_db : Float32 = 0.0_f32

    @has_triggered : Bool = false

    def _func_godot_apply_properties(props : Dictionary) : Void
      if props.has_key?("sound_name")
        @sound_name = props["sound_name"].as_string
      end
      if props.has_key?("once")
        @once = props["once"].as_bool
      end
    end

    def _ready : Void
      return if Engine.is_editor_hint

      self.collision_layer = 0_u32
      self.collision_mask = 2_u32 # Detect Player

      body_entered.connect do |body|
        on_body_entered(body)
      end
    end

    def on_body_entered(body : Godot::Node) : Void
      return if @once && @has_triggered
      return unless is_player(body)

      @has_triggered = true
      Sounds.play(@sound_name, self, @volume_db, 1.0_f32)

      if @once
        self.monitoring = false
        queue_free
      end
    end

    def is_player(node : Godot::Node) : Bool
      curr : Godot::Node? = node
      while curr
        return true if curr.is_in_group("player") || curr.name == "Player"
        curr = curr.get_parent?
      end
      false
    end
  end
end
