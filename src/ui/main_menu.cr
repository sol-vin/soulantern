require "lapis"

module Soulantern
  # Main Menu UI controller.
  node MainMenu < Control do
    @volume_slider : HSlider? = nil
    @volume_label : Label? = nil

    def _ready : Void
      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      ["CenterContainer/PanelContainer/VBoxContainer/ButtonsVBox/NewGameButton", "VBoxContainer/NewGame", "%NewGameButton", "NewGameButton"].each do |path|
        if has_node(path) && (btn = get_node(path).as?(Button))
          btn.pressed.connect do
            on_new_game_pressed
          end
          break
        end
      end

      ["CenterContainer/PanelContainer/VBoxContainer/ButtonsVBox/CreditsButton", "VBoxContainer/Credits", "%CreditsButton", "CreditsButton"].each do |path|
        if has_node(path) && (btn = get_node(path).as?(Button))
          btn.pressed.connect do
            on_credits_pressed
          end
          break
        end
      end

      ["CenterContainer/PanelContainer/VBoxContainer/ButtonsVBox/QuitButton", "VBoxContainer/Quit", "%QuitButton", "QuitButton"].each do |path|
        if has_node(path) && (btn = get_node(path).as?(Button))
          btn.pressed.connect do
            on_quit_pressed
          end
          break
        end
      end

      # Find slider and label
      ["CenterContainer/PanelContainer/VBoxContainer/VolumeContainer/HBoxContainer/VolumeSlider", "%VolumeSlider", "VolumeSlider"].each do |path|
        if has_node(path) && (slider = get_node(path).as?(HSlider))
          @volume_slider = slider
          break
        end
      end

      ["CenterContainer/PanelContainer/VBoxContainer/VolumeContainer/HBoxContainer/PercentLabel", "%VolumePercent", "PercentLabel", "VolumePercent"].each do |path|
        if has_node(path) && (lbl = get_node(path).as?(Label))
          @volume_label = lbl
          break
        end
      end

      # Initialize volume
      vol = AudioServer.get_master_volume

      if vs = @volume_slider
        vs.value = vol.to_f64
        vs.value_changed.connect do |new_val|
          on_volume_changed(new_val.to_f32)
        end
      end
      update_volume_label(vol)
    end

    def on_new_game_pressed : Void
      if tree = Godot.get_tree?
        tree.change_scene_to_file("res://opening.tscn")
      end
    end

    def on_credits_pressed : Void
      if tree = Godot.get_tree?
        tree.change_scene_to_file("res://credits.tscn")
      end
    end

    def on_quit_pressed : Void
      if tree = Godot.get_tree?
        tree.quit
      end
    end

    def on_volume_changed(val : Float32) : Void
      AudioServer.set_master_volume(val)
      update_volume_label(val)
    end

    def update_volume_label(val : Float32) : Void
      if vl = @volume_label
        pct = (val * 100.0_f32).round.to_i32
        vl.text = "#{pct}%"
      end
    end
  end
end
