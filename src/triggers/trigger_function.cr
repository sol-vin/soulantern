require "lapis"

module Soulantern
  # TrenchBroom / FuncGodot brush entity trigger that invokes a function through
  # the global Functions singleton when entered by the Player.
  node TriggerFunction < Area3D do
    @[Export]
    property function : String = ""
    @[Export]
    property target_function : String = ""
    @[Export]
    property once : Bool = false

    @func_godot_properties : Hash(String, Variant) = Hash(String, Variant).new
    @has_triggered : Bool = false

    def _func_godot_apply_properties(props : Dictionary) : Void
      if props.has_key?("function")
        @function = props["function"].as_string
        @target_function = @function
      elsif props.has_key?("target_function")
        @target_function = props["target_function"].as_string
      elsif props.has_key?("function_name")
        @target_function = props["function_name"].as_string
      end

      if props.has_key?("once")
        @once = props["once"].as_bool
      end
    end

    def _ready : Void
      return if Engine.is_editor_hint

      self.collision_layer = 0_u32
      self.collision_mask = 2_u32 # Detect Player CharacterBody3D

      body_entered >> ->(body : Godot::Node) { on_body_entered(body) }
    end

    def on_body_entered(body : Godot::Node) : Void
      return if @once && @has_triggered
      return unless is_player(body)

      @has_triggered = true

      fn = !@function.empty? ? @function : (!@target_function.empty? ? @target_function : self.name)
      Godot.log_info("TriggerFunction", "Triggered '#{fn}'")

      if func = Godot.get_tree?.try(&.get_root?.try(&.get_node?("Functions")))
        func.call("execute_function", fn)
      end

      if @once
        self.monitoring = false
        queue_free
      end
    end

    def is_player(node : Godot::Node) : Bool
      return true if node.as?(PlayerController) || (node << PlayerController?)
      curr : Godot::Node? = node
      while curr
        return true if curr.is_in_group("player") || curr.name == "Player"
        curr = curr.get_parent?
      end
      false
    end
  end
end
