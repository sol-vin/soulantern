require "lapis"

module Soulantern
  # Root node of the game level. Coordinates level rebuilds and lifecycle events.
  node Level < Node3D do
    signal on_load
    signal on_unload
    signal on_rebuild

    def rebuild : Void
      Godot.log_info("Level", "Rebuilding Level '#{name}'...")
      emit(on_rebuild)
    end

    def load : Void
      emit(on_load)
    end

    def unload : Void
      emit(on_unload)
    end
  end
end
