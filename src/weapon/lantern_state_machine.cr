require "lapis"

module Soulantern
  # Finite State Machine orchestrating weapon transitions between IDLE and DASH states.
  node LanternStateMachine < Godot::Node do
    signal state_changed(from_state : String, to_state : String)

    property current_state_name : String = "IDLE"
    property lantern : Godot::Node? = nil

    def _ready : Void
      change_state("IDLE")
    end

    def is_in_state(name : String) : Bool
      @current_state_name == name
    end

    def change_state(new_state : String) : Void
      return if @current_state_name == new_state
      old = @current_state_name
      @current_state_name = new_state
      emit(state_changed, old, new_state)
    end
  end
end
