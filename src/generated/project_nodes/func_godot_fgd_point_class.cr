# Generated strongly typed wrapper for GDScript node `FuncGodotFGDPointClass`
# Script Path: res://addons/func_godot/src/fgd/func_godot_fgd_point_class.gd
module Godot
  class FuncGodotFGDPointClass < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `scene_file` (Godot::PackedScene?)
    def scene_file : Godot::PackedScene?
      call_obj_as(Godot::PackedScene, "get", "scene_file")
    end

    def scene_file=(val) : Void
      call("set", "scene_file", val)
    end

    # Property `script_class` (Godot::Script?)
    def script_class : Godot::Script?
      call_obj_as(Godot::Script, "get", "script_class")
    end

    def script_class=(val) : Void
      call("set", "script_class", val)
    end

    # Property `apply_rotation_on_map_build` (Bool)
    def apply_rotation_on_map_build : Bool
      call_bool("get", "apply_rotation_on_map_build")
    end

    def apply_rotation_on_map_build=(val) : Void
      call("set", "apply_rotation_on_map_build", val)
    end

    # Property `apply_scale_on_map_build` (Bool)
    def apply_scale_on_map_build : Bool
      call_bool("get", "apply_scale_on_map_build")
    end

    def apply_scale_on_map_build=(val) : Void
      call("set", "apply_scale_on_map_build", val)
    end

    # Property `display_descriptors` (Void)
    def display_descriptors : String
      call_str("get", "display_descriptors")
    end

    def display_descriptors=(val) : Void
      call("set", "display_descriptors", val)
    end

    # Property `prefix` (String)
    def prefix : String
      call_str("get", "prefix")
    end

    def prefix=(val) : Void
      call("set", "prefix", val)
    end

    # Property `Entity Definition` (Void)
    def entity_definition : String
      call_str("get", "Entity Definition")
    end

    def entity_definition=(val) : Void
      call("set", "Entity Definition", val)
    end

    # Property `classname` (String)
    def classname : String
      call_str("get", "classname")
    end

    def classname=(val) : Void
      call("set", "classname", val)
    end

    # Property `description` (String)
    def description : String
      call_str("get", "description")
    end

    def description=(val) : Void
      call("set", "description", val)
    end

    # Property `func_godot_internal` (Bool)
    def func_godot_internal : Bool
      call_bool("get", "func_godot_internal")
    end

    def func_godot_internal=(val) : Void
      call("set", "func_godot_internal", val)
    end

    # Property `base_classes` (Void)
    def base_classes : String
      call_str("get", "base_classes")
    end

    def base_classes=(val) : Void
      call("set", "base_classes", val)
    end

    # Property `class_properties` (Void)
    def class_properties : String
      call_str("get", "class_properties")
    end

    def class_properties=(val) : Void
      call("set", "class_properties", val)
    end

    # Property `class_property_descriptions` (Void)
    def class_property_descriptions : String
      call_str("get", "class_property_descriptions")
    end

    def class_property_descriptions=(val) : Void
      call("set", "class_property_descriptions", val)
    end

    # Property `auto_apply_to_matching_node_properties` (Bool)
    def auto_apply_to_matching_node_properties : Bool
      call_bool("get", "auto_apply_to_matching_node_properties")
    end

    def auto_apply_to_matching_node_properties=(val) : Void
      call("set", "auto_apply_to_matching_node_properties", val)
    end

    # Property `meta_properties` (Void)
    def meta_properties : String
      call_str("get", "meta_properties")
    end

    def meta_properties=(val) : Void
      call("set", "meta_properties", val)
    end

    # Property `Node Generation` (Void)
    def node_generation : String
      call_str("get", "Node Generation")
    end

    def node_generation=(val) : Void
      call("set", "Node Generation", val)
    end

    # Property `node_class` (String)
    def node_class : String
      call_str("get", "node_class")
    end

    def node_class=(val) : Void
      call("set", "node_class", val)
    end

    # Property `name_property` (String)
    def name_property : String
      call_str("get", "name_property")
    end

    def name_property=(val) : Void
      call("set", "name_property", val)
    end

    # Property `node_groups` (Void)
    def node_groups : String
      call_str("get", "node_groups")
    end

    def node_groups=(val) : Void
      call("set", "node_groups", val)
    end

    # Method `_init` -> Void
    def _init : Void
      call("_init")
      nil
    end

    # Method `_build_model_branch_text` -> String
    def _build_model_branch_text(descriptor : Godot::FuncGodotFGDPointClassDisplayDescriptor) : String
      call_str("_build_model_branch_text", descriptor)
    end

    # Method `_build_model_text` -> String
    def _build_model_text : String
      call_str("_build_model_text")
    end

    # Method `_build_studio_text` -> String
    def _build_studio_text : String
      call_str("_build_studio_text")
    end

    # Method `build_def_text` -> String
    def build_def_text(target_editor : Godot::FuncGodotFGDFileFuncGodotTargetMapEditors) : String
      call_str("build_def_text", target_editor)
    end

    # Method `build_def_text` -> String
    def build_def_text(target_editor : Godot::FuncGodotFGDFileFuncGodotTargetMapEditors) : String
      call_str("build_def_text", target_editor)
    end

    # Method `retrieve_all_class_properties` -> Void
    def retrieve_all_class_properties(properties : Godot::Dictionary) : Void
      call("retrieve_all_class_properties", properties)
      nil
    end

    # Method `retrieve_all_class_property_descriptions` -> Void
    def retrieve_all_class_property_descriptions(descriptions : Godot::Dictionary) : Void
      call("retrieve_all_class_property_descriptions", descriptions)
      nil
    end
  end
end

alias FuncGodotFGDPointClass = Godot::FuncGodotFGDPointClass
