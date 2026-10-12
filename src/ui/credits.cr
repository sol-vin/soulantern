require "lapis"

module Soulantern
  # Credits screen UI controller.
  node Credits < Control do
    SOLVIN_URL = "https://sol.vin"
    BOUNCYTEM_URL = "https://bouncytem.bandcamp.com/album/terra-infernus"

    def _ready : Void
      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      if has_node("CenterContainer/PanelContainer/VBoxContainer/CreatorVBox/SolvinButton") &&
         (solvin_btn = get_node("CenterContainer/PanelContainer/VBoxContainer/CreatorVBox/SolvinButton").as?(Button))
        solvin_btn.pressed.connect do
          OS.shell_open(SOLVIN_URL)
        end
      end

      if has_node("CenterContainer/PanelContainer/VBoxContainer/MusicVBox/BouncyTemButton") &&
         (music_btn = get_node("CenterContainer/PanelContainer/VBoxContainer/MusicVBox/BouncyTemButton").as?(Button))
        music_btn.pressed.connect do
          OS.shell_open(BOUNCYTEM_URL)
        end
      end

      ["CenterContainer/PanelContainer/VBoxContainer/BackButton", "BackButton", "%BackButton"].each do |path|
        if has_node(path) && (btn = get_node(path).as?(Button))
          btn.pressed.connect do
            return_to_menu
          end
          break
        end
      end
    end

    def _unhandled_input(event : InputEvent) : Void
      if key = event.as?(InputEventKey)
        if key.pressed && !key.echo
          return_to_menu
        end
      end
    end

    def return_to_menu : Void
      if tree = Godot.get_tree?
        tree.change_scene_to_file("res://mainmenu.tscn")
      end
    end
  end
end
