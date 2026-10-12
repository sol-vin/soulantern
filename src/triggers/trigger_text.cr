require "lapis"

module Soulantern
  # TrenchBroom / FuncGodot brush entity trigger that displays text on the TriggerTextLabel
  # subtitle banner while the player is inside the trigger zone.
  node TriggerText < Area3D do
    @[Export]
    property text : String = ""
    @[Export]
    property once : Bool = false
    @[Export]
    property fade_duration : Float32 = 0.35_f32

    @has_displayed : Bool = false

    def _func_godot_apply_properties(props : Dictionary) : Void
      if props.has_key?("text")
        @text = props["text"].as_string
      elsif props.has_key?("message")
        @text = props["message"].as_string
      end
      if props.has_key?("once")
        @once = props["once"].as_bool
      end
    end

    def _ready : Void
      return if Engine.is_editor_hint

      self.collision_layer = 0_u32
      self.collision_mask = 2_u32 # Detect Player

      body_entered >> ->(body : Godot::Node) { on_body_entered(body) }
      body_exited >> ->(body : Godot::Node) { on_body_exited(body) }
    end

    def on_body_entered(body : Godot::Node) : Void
      return if @once && @has_displayed
      return unless body.in_group_or_ancestor?("player") || body.self_or_ancestor?(PlayerController)

      @has_displayed = true
      if ttl = Godot.get_tree?.try(&.get_root?.try(&.get_node?("TriggerTextLabel")))
        ttl.call("show_text", @text, @fade_duration)
      end
    end

    def on_body_exited(body : Godot::Node) : Void
      return unless body.in_group_or_ancestor?("player") || body.self_or_ancestor?(PlayerController)

      if ttl = Godot.get_tree?.try(&.get_root?.try(&.get_node?("TriggerTextLabel")))
        ttl.call("hide_text", @fade_duration)
      end

      if @once
        self.monitoring = false
        queue_free
      end
    end
  end
end

