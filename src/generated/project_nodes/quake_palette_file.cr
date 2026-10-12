# Generated strongly typed wrapper for GDScript node `QuakePaletteFile`
# Script Path: res://addons/func_godot/src/import/quake_palette_file.gd
module Godot
  class QuakePaletteFile < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `colors` (Void)
    def colors : String
      call_str("get", "colors")
    end

    def colors=(val) : Void
      call("set", "colors", val)
    end

    # Method `_init` -> Void
    def _init(colors) : Void
      call("_init", colors)
      nil
    end
  end
end

alias QuakePaletteFile = Godot::QuakePaletteFile
