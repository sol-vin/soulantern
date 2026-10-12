require "lapis"

module Soulantern
  # Credits screen UI controller.
  node Credits < Control do
    SOLVIN_URL = "https://sol.vin"
    BOUNCYTEM_URL = "https://bouncytem.bandcamp.com/album/terra-infernus"

    node_ref? solvin_btn, Button, "CenterContainer/PanelContainer/VBoxContainer/CreatorVBox/SolvinButton"
    node_ref? music_btn, Button, "CenterContainer/PanelContainer/VBoxContainer/MusicVBox/BouncyTemButton"
    node_ref? back_btn, Button, "CenterContainer/PanelContainer/VBoxContainer/BackButton"
    unique_node? u_back_btn, Button, "BackButton"

    def _ready : Void
      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      if btn = solvin_btn
        btn.pressed >> ->{ OS.shell_open(SOLVIN_URL) }
      end

      if btn = music_btn
        btn.pressed >> ->{ OS.shell_open(BOUNCYTEM_URL) }
      end

      if btn = back_btn || u_back_btn
        btn.pressed >> ->return_to_menu
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
