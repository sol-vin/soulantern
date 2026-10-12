# Generated strongly typed wrapper for GDScript node `FuncGodotParser`
# Script Path: res://addons/func_godot/src/core/parser.gd
module Godot
  class FuncGodotParser < Godot::RefCounted
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Method `parse_map_data` -> Godot::RefCounted?
    def parse_map_data(map_file : String, map_settings : Godot::FuncGodotMapSettings) : Godot::RefCounted?
      call_obj_as(Godot::RefCounted, "parse_map_data", map_file, map_settings)
    end

    # Method `_parse_quake_map` -> Godot::RefCounted?
    def _parse_quake_map(map_data : Godot::PackedStringArray, map_settings : Godot::FuncGodotMapSettings, parse_data : Godot::RefCounted) : Godot::RefCounted?
      call_obj_as(Godot::RefCounted, "_parse_quake_map", map_data, map_settings, parse_data)
    end

    # Method `_parse_vmf` -> Godot::RefCounted?
    def _parse_vmf(map_data : Godot::PackedStringArray, map_settings : Godot::FuncGodotMapSettings, parse_data : Godot::RefCounted) : Godot::RefCounted?
      call_obj_as(Godot::RefCounted, "_parse_vmf", map_data, map_settings, parse_data)
    end

    # Bound Signal `declare_step`
    def declare_step : Godot::BoundSignal
      signal("declare_step")
    end
  end
end

alias FuncGodotParser = Godot::FuncGodotParser
