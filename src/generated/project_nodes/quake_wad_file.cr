# Generated strongly typed wrapper for GDScript node `QuakeWadFile`
# Script Path: res://addons/func_godot/src/import/quake_wad_file.gd
module Godot
  class QuakeWadFile < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `textures` (Void)
    def textures : String
      call_str("get", "textures")
    end

    def textures=(val) : Void
      call("set", "textures", val)
    end

    # Method `_init` -> Void
    def _init(textures : Godot::Dictionary) : Void
      call("_init", textures)
      nil
    end
  end
end

alias QuakeWadFile = Godot::QuakeWadFile
