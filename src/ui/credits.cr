require "lapis"

module Soulantern
  # Credits screen UI controller.
  node Credits < Control do
    SOLVIN_URL = "https://sol.vin"
    BOUNCYTEM_URL = "https://bouncytem.bandcamp.com/album/terra-infernus"

    onready solvin_btn : Button = "%SolvinButton"
    onready music_btn : Button = "%BouncyTemButton"
    onready back_btn : Button = "%BackButton"

    def _ready : Void
      Input.mouse_mode = Input::MouseMode::MouseModeVisible
      solvin_btn.pressed >> ->{ OS.shell_open(SOLVIN_URL) }
      music_btn.pressed >> ->{ OS.shell_open(BOUNCYTEM_URL) }
      back_btn.pressed >> ->return_to_menu
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
