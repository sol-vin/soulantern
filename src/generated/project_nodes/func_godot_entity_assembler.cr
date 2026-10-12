# Generated strongly typed wrapper for GDScript node `FuncGodotEntityAssembler`
# Script Path: res://addons/func_godot/src/core/entity_assembler.gd
module Godot
  class FuncGodotEntityAssembler < Godot::RefCounted
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `map_settings` (Godot::FuncGodotMapSettings?)
    def map_settings : Godot::FuncGodotMapSettings?
      call_obj_as(Godot::FuncGodotMapSettings, "get", "map_settings")
    end

    def map_settings=(val) : Void
      call("set", "map_settings", val)
    end

    # Property `build_flags` (Int64)
    def build_flags : Int64
      call_i64("get", "build_flags")
    end

    def build_flags=(val) : Void
      call("set", "build_flags", val)
    end

    # Method `_init` -> Void
    def _init(settings : Godot::FuncGodotMapSettings) : Void
      call("_init", settings)
      nil
    end

    # Method `get_script_by_class_name` -> Godot::Script?
    def get_script_by_class_name(name_of_class : String) : Godot::Script?
      call_obj_as(Godot::Script, "get_script_by_class_name", name_of_class)
    end

    # Method `generate_group_node` -> Godot::Node3D?
    def generate_group_node(group_data : Godot::RefCounted) : Godot::Node3D?
      call_obj_as(Godot::Node3D, "generate_group_node", group_data)
    end

    # Method `generate_solid_entity_node` -> Godot::Node?
    def generate_solid_entity_node(node : Godot::Node, node_name : String, data : Godot::RefCounted, definition : Godot::FuncGodotFGDSolidClass) : Godot::Node?
      call_obj_as(Godot::Node, "generate_solid_entity_node", node, node_name, data, definition)
    end

    # Method `generate_point_entity_node` -> Godot::Node?
    def generate_point_entity_node(node : Godot::Node, node_name : String, properties : Godot::Dictionary, definition : Godot::FuncGodotFGDPointClass) : Godot::Node?
      call_obj_as(Godot::Node, "generate_point_entity_node", node, node_name, properties, definition)
    end

    # Method `apply_entity_properties` -> Void
    def apply_entity_properties(node : Godot::Node, data : Godot::RefCounted) : Void
      call("apply_entity_properties", node, data)
      nil
    end

    # Method `generate_entity_node` -> Godot::Node?
    def generate_entity_node(entity_data : Godot::RefCounted, entity_index : Int64) : Godot::Node?
      call_obj_as(Godot::Node, "generate_entity_node", entity_data, entity_index)
    end

    # Method `build` -> Void
    def build(map_node : Godot::FuncGodotMap, entities : Godot::Array, groups : Godot::Array) : Void
      call("build", map_node, entities, groups)
      nil
    end

    # Bound Signal `declare_step`
    def declare_step : Godot::BoundSignal
      signal("declare_step")
    end
  end
end

alias FuncGodotEntityAssembler = Godot::FuncGodotEntityAssembler
