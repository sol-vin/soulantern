require "lapis"

module Soulantern
  # In-game Pause Menu overlay controller.
  node PauseMenu < Control do
    node_ref? resume_btn, Button, "CenterContainer/PanelContainer/VBoxContainer/ResumeButton"
    node_ref? quit_btn, Button, "CenterContainer/PanelContainer/VBoxContainer/QuitButton"
    node_ref? volume_slider, HSlider, "CenterContainer/PanelContainer/VBoxContainer/VolumeContainer/HBoxContainer/VolumeSlider"
    node_ref? volume_label, Label, "CenterContainer/PanelContainer/VBoxContainer/VolumeContainer/HBoxContainer/PercentLabel"

    unique_node? u_resume_btn, Button, "ResumeButton"
    unique_node? u_quit_btn, Button, "QuitButton"
    unique_node? u_volume_slider, HSlider, "VolumeSlider"
    unique_node? u_volume_label, Label, "PercentLabel"

    def find_resume_button : Button?
      resume_btn || u_resume_btn
    end

    def find_quit_button : Button?
      quit_btn || u_quit_btn
    end

    def find_volume_slider : HSlider?
      volume_slider || u_volume_slider
    end

    def find_volume_label : Label?
      volume_label || u_volume_label
    end

    def _ready : Void
      self.process_mode = Node::ProcessMode::ProcessModeAlways
      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      if btn = find_resume_button
        btn.pressed >> ->on_resume_pressed
      end

      if btn = find_quit_button
        btn.pressed >> ->on_quit_pressed
      end

      vol = AudioServer.get_master_volume

      if vs = find_volume_slider
        vs.value = vol.to_f64
        vs.value_changed >> ->(new_val : Float64) { on_volume_changed(new_val.to_f32) }
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
      if vl = find_volume_label
        pct = (val * 100.0_f32).round.to_i32
        vl.text = "#{pct}%"
      end
    end
  end
end
