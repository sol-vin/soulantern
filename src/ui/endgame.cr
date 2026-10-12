require "lapis"

module Soulantern
  # Victory screen controller displayed upon completing the game.
  # Shows "THANK YOU FOR PLAYING" and auto-transitions to Credits after 5 seconds.
  node EndGame < Control do
    onready? skip_btn : Button? = "%SkipButton"

    @transitioned : Bool = false

    def _ready : Void
      Input.mouse_mode = Input::MouseMode::MouseModeVisible

      if btn = skip_btn
        btn.pressed >> ->go_to_credits
      end

      # 5-second automatic progression
      if tree = Godot.get_tree?
        if timer = tree.create_timer(5.0_f64)
          timer.timeout >> ->go_to_credits
        end
      end
    end

    def _unhandled_input(event : InputEvent) : Void
      return if @transitioned

      if key = event.as?(InputEventKey)
        if key.pressed && !key.echo
          go_to_credits
        end
      elsif mouse = event.as?(InputEventMouseButton)
        if mouse.pressed
          go_to_credits
        end
      end
    end

    def go_to_credits : Void
      return if @transitioned
      @transitioned = true

      if tree = Godot.get_tree?
        tree.change_scene_to_file("res://credits.tscn")
      end
    end
  end
end
