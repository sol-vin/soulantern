require "lapis"

module Soulantern
  # Autoload UI controller for displaying trigger text overlay at the bottom of the screen.
  # Managed as a persistent singleton with animated alpha fading.
  @[Autoload(name: "TriggerTextLabel")]
  node TriggerTextLabel < CanvasLayer do
    @[Export]
    property default_fade_duration : Float32 = 0.35_f32

    unique_node? panel_container, Control, "PanelContainer"
    unique_node? text_label, Label, "Label"

    @tween : Tween? = nil
    @current_source : Godot::Object? = nil

    def _ready : Void
      self.layer = 120

      unless text_label
        if inst = "res://scenes/ui/trigger_text_label.tscn" > Godot::Node?
          if inst.has_node("RootControl")
            ctrl = inst.get_node("RootControl")
            inst.remove_child(ctrl)
            self << ctrl
          else
            self << inst
          end
        end
      end

      hide_immediate
    end

    # Displays text on screen with a fade-in animation.
    def show_text(message : String, duration : Float32 = -1.0_f32) : Void
      panel = panel_container
      label = text_label
      return unless panel && label
      return if message.empty?

      label.text = message

      if tw = @tween
        tw.kill if tw.is_valid
      end

      fade_time = duration < 0.0_f32 ? @default_fade_duration : duration
      panel.visible = true

      if fade_time <= 0.0_f32
        mod = panel.modulate
        panel.modulate = Color.new(mod.r, mod.g, mod.b, 1.0_f32)
      else
        tw = create_tween
        if tw
          @tween = tw
          tw.tween_property(panel, "modulate:a", 1.0_f32, fade_time)
            .set_trans(Tween::TransitionType::TransSine)
            .set_ease(Tween::EaseType::EaseOut)
        end
      end
    end

    # Overload for calls that pass source object
    def show_text_from(source : Godot::Object?, message : String, duration : Float32 = -1.0_f32) : Void
      @current_source = source
      show_text(message, duration)
    end

    # Fades out and hides the text.
    def hide_text(duration : Float32 = -1.0_f32) : Void
      panel = panel_container
      return unless panel && panel.visible

      if tw = @tween
        tw.kill if tw.is_valid
      end

      fade_time = duration < 0.0_f32 ? @default_fade_duration : duration

      if fade_time <= 0.0_f32
        hide_immediate
      else
        tw = create_tween
        if tw
          @tween = tw
          tw.tween_property(panel, "modulate:a", 0.0_f32, fade_time)
            .set_trans(Tween::TransitionType::TransSine)
            .set_ease(Tween::EaseType::EaseIn)
          tw.finished >> ->on_fade_out_complete
        end
      end
    end

    def on_fade_out_complete : Void
      if p = panel_container
        p.visible = false
      end
      @current_source = nil
    end

    # Immediately hides the overlay and clears text without animation.
    def hide_immediate : Void
      if tw = @tween
        tw.kill if tw.is_valid
      end
      @current_source = nil
      if p = panel_container
        mod = p.modulate
        p.modulate = Color.new(mod.r, mod.g, mod.b, 0.0_f32)
        p.visible = false
      end
      if l = text_label
        l.text = ""
      end
    end

    def clear_text : Void
      hide_immediate
    end

    def is_showing : Bool
      if p = panel_container
        p.visible && p.modulate.a > 0.0_f32
      else
        false
      end
    end

    def get_current_text : String
      text_label.try(&.text) || ""
    end
  end
end
