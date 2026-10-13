require "lapis"

module Soulantern
  # In-game Pause Menu overlay controller.
  node PauseMenu < Control do
    onready resume_btn : Button = "%ResumeButton"
    onready quit_btn : Button = "%QuitButton"
    onready volume_slider : HSlider = "%VolumeSlider"
    onready volume_label : Label = "%PercentLabel"

    def _ready : Void
      self.process_mode = Node::ProcessMode::ProcessModeAlways
      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      resume_btn.pressed >> ->on_resume_pressed
      quit_btn.pressed >> ->on_quit_pressed

      vol = AudioServer.get_master_volume
      vs = volume_slider
      vs.value = vol.to_f64
      vs.value_changed >> ->(new_val : Float64) { on_volume_changed(new_val.to_f32) }
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
      if vl = volume_label
        pct = (val * 100.0_f32).round.to_i32
        vl.text = "#{pct}%"
      end
    end
  end
end
