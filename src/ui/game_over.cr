require "lapis"

module Soulantern
  # Game Over screen UI controller.
  node GameOver < Control do
    def _ready : Void
      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      ["CenterContainer/PanelContainer/VBoxContainer/ButtonsVBox/RestartButton", "%RetryButton", "RestartButton", "VBoxContainer/Retry"].each do |path|
        if has_node(path) && (btn = get_node(path).as?(Button))
          btn.pressed.connect do
            on_retry_pressed
          end
          break
        end
      end

      ["CenterContainer/PanelContainer/VBoxContainer/ButtonsVBox/MainMenuButton", "%MainMenuButton", "MainMenuButton", "VBoxContainer/MainMenu"].each do |path|
        if has_node(path) && (btn = get_node(path).as?(Button))
          btn.pressed.connect do
            on_main_menu_pressed
          end
          break
        end
      end
    end

    def on_retry_pressed : Void
      if tree = Godot.get_tree?
        if root = tree.get_root?
          if root.has_node("Functions")
            root.get_node("Functions").call("restart_level")
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
