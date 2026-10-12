require "lapis"

module Soulantern
  # Game Over screen UI controller.
  node GameOver < Control do
    node_ref? restart_btn, Button, "CenterContainer/PanelContainer/VBoxContainer/ButtonsVBox/RestartButton"
    node_ref? menu_btn, Button, "CenterContainer/PanelContainer/VBoxContainer/ButtonsVBox/MainMenuButton"
    unique_node? u_restart_btn, Button, "RestartButton"
    unique_node? u_retry_btn, Button, "RetryButton"
    unique_node? u_menu_btn, Button, "MainMenuButton"

    def _ready : Void
      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      if btn = restart_btn || u_restart_btn || u_retry_btn
        btn.pressed >> ->on_retry_pressed
      end

      if btn = menu_btn || u_menu_btn
        btn.pressed >> ->on_main_menu_pressed
      end
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
