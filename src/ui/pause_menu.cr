require "lapis"

module Soulantern
  # In-game Pause Menu overlay controller.
  node PauseMenu < Control do
    @volume_slider : HSlider? = nil
    @volume_label : Label? = nil

    def _ready : Void
      self.process_mode = Node::ProcessMode::ProcessModeAlways
      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      ["CenterContainer/PanelContainer/VBoxContainer/ResumeButton", "%ResumeButton", "ResumeButton", "VBoxContainer/Resume"].each do |path|
        if has_node(path) && (btn = get_node(path).as?(Button))
          btn.pressed.connect do
            on_resume_pressed
          end
          break
        end
      end

      ["CenterContainer/PanelContainer/VBoxContainer/QuitButton", "%QuitButton", "QuitButton", "%MainMenuButton", "VBoxContainer/MainMenu"].each do |path|
        if has_node(path) && (btn = get_node(path).as?(Button))
          btn.pressed.connect do
            on_quit_pressed
          end
          break
        end
      end

      # Find Volume
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

      vol = AudioServer.get_master_volume

      if vs = @volume_slider
        vs.value = vol.to_f64
        vs.value_changed.connect do |new_val|
          on_volume_changed(new_val.to_f32)
        end
      end
      update_volume_label(vol)
    end

    def on_resume_pressed : Void
      if tree = Godot.get_tree?
        if root = tree.get_root?
          if root.has_node("Functions")
            root.get_node("Functions").call("close_pause_menu")
            return
          end
        end
        tree.paused = false
      end
      Input.mouse_mode = Input::MouseMode::MouseModeCaptured
      if p = get_parent?
        p.queue_free
      else
        queue_free
      end
    end

    def on_quit_pressed : Void
      if tree = Godot.get_tree?
        if root = tree.get_root?
          if root.has_node("Functions")
            root.get_node("Functions").call("close_pause_menu")
          end
        end
        tree.paused = false
        tree.change_scene_to_file("res://mainmenu.tscn")
      end
      if p = get_parent?
        p.queue_free
      else
        queue_free
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
