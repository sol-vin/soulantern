require "lapis"

module Soulantern
  # Main Menu UI controller.
  node MainMenu < Control do
    onready new_game_btn : Button = "%NewGameButton"
    onready credits_btn : Button = "%CreditsButton"
    onready quit_btn : Button = "%QuitButton"
    onready volume_slider : HSlider = "%VolumeSlider"
    onready volume_label : Label = "%PercentLabel"

    def _ready : Void
      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      unless Engine.is_editor_hint
        DisplayServer.window_set_mode(DisplayServer::WindowMode::WindowModeFullscreen)
      end

      # Wire button interactions with signal piping
      new_game_btn.pressed >> ->on_new_game_pressed
      credits_btn.pressed >> ->on_credits_pressed
      quit_btn.pressed >> ->on_quit_pressed

      # Initialize volume controls
      vol = AudioServer.get_master_volume
      vs = volume_slider
      vs.value = vol.to_f64
      vs.value_changed >> ->(new_val : Float64) { on_volume_changed(new_val.to_f32) }
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
