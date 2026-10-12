require "lapis"

module Soulantern
  # Main Menu UI controller.
  node MainMenu < Control do
    unique_node? new_game_btn, Button, "NewGameButton"
    unique_node? credits_btn, Button, "CreditsButton"
    unique_node? quit_btn, Button, "QuitButton"
    unique_node? volume_slider, HSlider, "VolumeSlider"
    unique_node? volume_label, Label, "PercentLabel"

    def _ready : Void
      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      # Wire button interactions with signal piping
      new_game_btn.try(&.pressed.>> ->on_new_game_pressed)
      credits_btn.try(&.pressed.>> ->on_credits_pressed)
      quit_btn.try(&.pressed.>> ->on_quit_pressed)

      # Initialize volume controls
      vol = AudioServer.get_master_volume
      if vs = volume_slider
        vs.value = vol.to_f64
        vs.value_changed >> ->(new_val : Float64) { on_volume_changed(new_val.to_f32) }
      end
      update_volume_label(vol)
    end

    def on_new_game_pressed : Void
      Godot.get_tree?.try(&.change_scene_to_file("res://opening.tscn"))
    end

    def on_credits_pressed : Void
      Godot.get_tree?.try(&.change_scene_to_file("res://credits.tscn"))
    end

    def on_quit_pressed : Void
      Godot.get_tree?.try(&.quit)
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
