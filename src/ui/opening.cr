require "lapis"

module Soulantern
  # Opening splash / title sequence controller.
  node Opening < Control do
    @transitioning : Bool = false

    def _ready : Void
      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      ["CenterContainer/PanelContainer/VBoxContainer/StartButton", "StartButton", "%StartButton"].each do |path|
        if has_node(path) && (btn = get_node(path).as?(Button))
          btn.pressed.connect do
            start_game
          end
          break
        end
      end
    end

    def _unhandled_input(event : InputEvent) : Void
      return if @transitioning

      if key = event.as?(InputEventKey)
        if key.pressed && !key.echo
          start_game
        end
      elsif mouse = event.as?(InputEventMouseButton)
        if mouse.pressed
          start_game
        end
      end
    end

    def start_game : Void
      return if @transitioning
      @transitioning = true

      if tree = Godot.get_tree?
        tree.change_scene_to_file("res://node_3d.tscn")
      end
    end
  end
end
