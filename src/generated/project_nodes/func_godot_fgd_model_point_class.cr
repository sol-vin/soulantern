# Generated strongly typed wrapper for GDScript node `FuncGodotFGDModelPointClass`
# Script Path: res://addons/func_godot/src/fgd/func_godot_fgd_model_point_class.gd
module Godot
  class FuncGodotFGDModelPointClass < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `target_map_editor` (Godot::FuncGodotFGDModelPointClassTargetMapEditor?)
    def target_map_editor : Int64
      call_i64("get", "target_map_editor")
    end

    def target_map_editor=(val) : Void
      call("set", "target_map_editor", val)
    end

    # Property `models_sub_folder` (String)
    def models_sub_folder : String
      call_str("get", "models_sub_folder")
    end

    def models_sub_folder=(val) : Void
      call("set", "models_sub_folder", val)
    end

    # Property `scale_expression` (String)
    def scale_expression : String
      call_str("get", "scale_expression")
    end

    def scale_expression=(val) : Void
      call("set", "scale_expression", val)
    end

    # Property `generate_size_property` (Bool)
    def generate_size_property : Bool
      call_bool("get", "generate_size_property")
    end

    def generate_size_property=(val) : Void
      call("set", "generate_size_property", val)
    end

    # Property `rotation_offset` (Void)
    def rotation_offset : String
      call_str("get", "rotation_offset")
    end

    def rotation_offset=(val) : Void
      call("set", "rotation_offset", val)
    end

    # Property `generate_gd_ignore_file` (Void)
    def generate_gd_ignore_file : String
      call_str("get", "generate_gd_ignore_file")
    end

    def generate_gd_ignore_file=(val) : Void
      call("set", "generate_gd_ignore_file", val)
    end

    # Property `_model_generation_enabled` (Bool)
    def _model_generation_enabled : Bool
      call_bool("get", "_model_generation_enabled")
    end

    def _model_generation_enabled=(val) : Void
      call("set", "_model_generation_enabled", val)
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

    # Method `_generate_gd_ignore_file` -> Void
    def _generate_gd_ignore_file : Void
      call("_generate_gd_ignore_file")
      nil
    end

    # Method `build_def_text` -> String
    def build_def_text(target_editor : Godot::FuncGodotFGDFileFuncGodotTargetMapEditors) : String
      call_str("build_def_text", target_editor)
    end

    # Method `_generate_model` -> Void
    def _generate_model : Void
      call("_generate_model")
      nil
    end

    # Method `_get_node` -> Godot::Node3D?
    def _get_node : Godot::Node3D?
      call_obj_as(Godot::Node3D, "_get_node")
    end

    # Method `_get_export_dir` -> String
    def _get_export_dir : String
      call_str("_get_export_dir")
    end

    # Method `_get_local_path` -> String
    def _get_local_path : String
      call_str("_get_local_path")
    end

    # Method `_get_model_folder` -> String
    def _get_model_folder : String
      call_str("_get_model_folder")
    end

    # Method `_get_game_path` -> String
    def _get_game_path : String
      call_str("_get_game_path")
    end

    # Method `_create_gltf_file` -> Bool
    def _create_gltf_file(gltf_state : Godot::GLTFState, path : String, node : Godot::Node3D) : Bool
      call_bool("_create_gltf_file", gltf_state, path, node)
    end

    # Method `_save_to_file_system` -> Void
    def _save_to_file_system(gltf_document : Godot::GLTFDocument, gltf_state : Godot::GLTFState, path : String) : Void
      call("_save_to_file_system", gltf_document, gltf_state, path)
      nil
    end

    # Method `_generate_size_from_aabb` -> Void
    def _generate_size_from_aabb(meshes : Godot::Array, nodes : Godot::Array) : Void
      call("_generate_size_from_aabb", meshes, nodes)
      nil
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

alias FuncGodotFGDModelPointClass = Godot::FuncGodotFGDModelPointClass
