# Generated strongly typed wrapper for GDScript node `FuncGodotMap`
# Script Path: res://addons/func_godot/src/map/func_godot_map.gd
module Godot
  class FuncGodotMap < Godot::Node3D
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `_build_func` (Void)
    def _build_func : String
      call_str("get", "_build_func")
    end

    def _build_func=(val) : Void
      call("set", "_build_func", val)
    end

    # Property `_clear_func` (Void)
    def _clear_func : String
      call_str("get", "_clear_func")
    end

    def _clear_func=(val) : Void
      call("set", "_clear_func", val)
    end

    # Property `Map` (Void)
    def map : String
      call_str("get", "Map")
    end

    def map=(val) : Void
      call("set", "Map", val)
    end

    # Property `local_map_file` (String)
    def local_map_file : String
      call_str("get", "local_map_file")
    end

    def local_map_file=(val) : Void
      call("set", "local_map_file", val)
    end

    # Property `global_map_file` (String)
    def global_map_file : String
      call_str("get", "global_map_file")
    end

    def global_map_file=(val) : Void
      call("set", "global_map_file", val)
    end

    # Property `_map_file_internal` (String)
    def _map_file_internal : String
      call_str("get", "_map_file_internal")
    end

    def _map_file_internal=(val) : Void
      call("set", "_map_file_internal", val)
    end

    # Property `map_settings` (Godot::FuncGodotMapSettings?)
    def map_settings : Godot::FuncGodotMapSettings?
      call_obj_as(Godot::FuncGodotMapSettings, "get", "map_settings")
    end

    def map_settings=(val) : Void
      call("set", "map_settings", val)
    end

    # Property `Build` (Void)
    def build : String
      call_str("get", "Build")
    end

    def build=(val) : Void
      call("set", "Build", val)
    end

    # Property `build_flags` (Int64)
    def build_flags : Int64
      call_i64("get", "build_flags")
    end

    def build_flags=(val) : Void
      call("set", "build_flags", val)
    end

    # Property `hyperplane_size` (Float64)
    def hyperplane_size : Float64
      call_f64("get", "hyperplane_size")
    end

    def hyperplane_size=(val) : Void
      call("set", "hyperplane_size", val)
    end

    # Method `fail_build` -> Void
    def fail_build(reason : String, notify : Bool) : Void
      call("fail_build", reason, notify)
      nil
    end

    # Method `clear_children` -> Void
    def clear_children : Void
      call("clear_children")
      nil
    end

    # Method `verify` -> Godot::Error?
    def verify : Godot::Error?
      call_i64("verify")
    end

    # Method `build` -> Void
    def build : Void
      call("build")
      nil
    end

    # Bound Signal `build_failed`
    def build_failed : Godot::BoundSignal
      signal("build_failed")
    end

    # Bound Signal `build_complete`
    def build_complete : Godot::BoundSignal
      signal("build_complete")
    end
  end
end

alias FuncGodotMap = Godot::FuncGodotMap
