# Generated strongly typed wrapper for GDScript node `QuakeMapFile`
# Script Path: res://addons/func_godot/src/import/quake_map_file.gd
module Godot
  class QuakeMapFile < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `revision` (Int64)
    def revision : Int64
      call_i64("get", "revision")
    end

    def revision=(val) : Void
      call("set", "revision", val)
    end

    # Property `map_data` (String)
    def map_data : String
      call_str("get", "map_data")
    end

    def map_data=(val) : Void
      call("set", "map_data", val)
    end
  end
end

alias QuakeMapFile = Godot::QuakeMapFile
