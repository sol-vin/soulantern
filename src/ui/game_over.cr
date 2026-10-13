require "lapis"

module Soulantern
  # Game Over screen UI controller.
  node GameOver < Control do
    onready restart_btn : Button = "%RestartButton"
    onready menu_btn : Button = "%MainMenuButton"

    def _ready : Void
      Input.mouse_mode = Input::MouseMode::MouseModeVisible
      restart_btn.pressed >> ->on_retry_pressed
      menu_btn.pressed >> ->on_main_menu_pressed
    end

    def on_retry_pressed : Void
      if tree = Godot.get_tree?
        if root = tree.get_root?
          if func = root.get_node?("Functions")
            func.call("restart_level")
            return
          end
        end
        tree.change_scene_to_file("res://node_3d.tscn")
      end
    end

    def on_main_menu_pressed : Void
      if tree = Godot.get_tree?
        tree.change_scene_to_file("res://mainmenu.tscn")
      end
    end
  end
end
