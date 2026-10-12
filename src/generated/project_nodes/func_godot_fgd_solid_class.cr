# Generated strongly typed wrapper for GDScript node `FuncGodotFGDSolidClass`
# Script Path: res://addons/func_godot/src/fgd/func_godot_fgd_solid_class.gd
module Godot
  class FuncGodotFGDSolidClass < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `spawn_type` (Godot::FuncGodotFGDSolidClassSpawnType?)
    def spawn_type : Int64
      call_i64("get", "spawn_type")
    end

    def spawn_type=(val) : Void
      call("set", "spawn_type", val)
    end

    # Property `origin_type` (Godot::FuncGodotFGDSolidClassOriginType?)
    def origin_type : Int64
      call_i64("get", "origin_type")
    end

    def origin_type=(val) : Void
      call("set", "origin_type", val)
    end

    # Property `Visual Build` (Void)
    def visual_build : String
      call_str("get", "Visual Build")
    end

    def visual_build=(val) : Void
      call("set", "Visual Build", val)
    end

    # Property `build_visuals` (Bool)
    def build_visuals : Bool
      call_bool("get", "build_visuals")
    end

    def build_visuals=(val) : Void
      call("set", "build_visuals", val)
    end

    # Property `global_illumination_mode` (Godot::GeometryInstance3DGIMode?)
    def global_illumination_mode : Int64
      call_i64("get", "global_illumination_mode")
    end

    def global_illumination_mode=(val) : Void
      call("set", "global_illumination_mode", val)
    end

    # Property `use_in_baked_light` (Bool)
    def use_in_baked_light : Bool
      call_bool("get", "use_in_baked_light")
    end

    def use_in_baked_light=(val) : Void
      call("set", "use_in_baked_light", val)
    end

    # Property `shadow_casting_setting` (Godot::GeometryInstance3DShadowCastingSetting?)
    def shadow_casting_setting : Int64
      call_i64("get", "shadow_casting_setting")
    end

    def shadow_casting_setting=(val) : Void
      call("set", "shadow_casting_setting", val)
    end

    # Property `build_occlusion` (Bool)
    def build_occlusion : Bool
      call_bool("get", "build_occlusion")
    end

    def build_occlusion=(val) : Void
      call("set", "build_occlusion", val)
    end

    # Property `render_layers` (Int64)
    def render_layers : Int64
      call_i64("get", "render_layers")
    end

    def render_layers=(val) : Void
      call("set", "render_layers", val)
    end

    # Property `Collision Build` (Void)
    def collision_build : String
      call_str("get", "Collision Build")
    end

    def collision_build=(val) : Void
      call("set", "Collision Build", val)
    end

    # Property `collision_shape_type` (Godot::FuncGodotFGDSolidClassCollisionShapeType?)
    def collision_shape_type : Int64
      call_i64("get", "collision_shape_type")
    end

    def collision_shape_type=(val) : Void
      call("set", "collision_shape_type", val)
    end

    # Property `collision_layer` (Int64)
    def collision_layer : Int64
      call_i64("get", "collision_layer")
    end

    def collision_layer=(val) : Void
      call("set", "collision_layer", val)
    end

    # Property `collision_mask` (Int64)
    def collision_mask : Int64
      call_i64("get", "collision_mask")
    end

    def collision_mask=(val) : Void
      call("set", "collision_mask", val)
    end

    # Property `collision_priority` (Float64)
    def collision_priority : Float64
      call_f64("get", "collision_priority")
    end

    def collision_priority=(val) : Void
      call("set", "collision_priority", val)
    end

    # Property `collision_shape_margin` (Float64)
    def collision_shape_margin : Float64
      call_f64("get", "collision_shape_margin")
    end

    def collision_shape_margin=(val) : Void
      call("set", "collision_shape_margin", val)
    end

    # Property `Mesh Metadata` (Void)
    def mesh_metadata : String
      call_str("get", "Mesh Metadata")
    end

    def mesh_metadata=(val) : Void
      call("set", "Mesh Metadata", val)
    end

    # Property `add_textures_metadata` (Bool)
    def add_textures_metadata : Bool
      call_bool("get", "add_textures_metadata")
    end

    def add_textures_metadata=(val) : Void
      call("set", "add_textures_metadata", val)
    end

    # Property `add_vertex_metadata` (Bool)
    def add_vertex_metadata : Bool
      call_bool("get", "add_vertex_metadata")
    end

    def add_vertex_metadata=(val) : Void
      call("set", "add_vertex_metadata", val)
    end

    # Property `add_face_position_metadata` (Bool)
    def add_face_position_metadata : Bool
      call_bool("get", "add_face_position_metadata")
    end

    def add_face_position_metadata=(val) : Void
      call("set", "add_face_position_metadata", val)
    end

    # Property `add_face_normal_metadata` (Bool)
    def add_face_normal_metadata : Bool
      call_bool("get", "add_face_normal_metadata")
    end

    def add_face_normal_metadata=(val) : Void
      call("set", "add_face_normal_metadata", val)
    end

    # Property `add_collision_shape_to_face_indices_metadata` (Bool)
    def add_collision_shape_to_face_indices_metadata : Bool
      call_bool("get", "add_collision_shape_to_face_indices_metadata")
    end

    def add_collision_shape_to_face_indices_metadata=(val) : Void
      call("set", "add_collision_shape_to_face_indices_metadata", val)
    end

    # Property `add_collision_shape_face_range_metadata` (Bool)
    def add_collision_shape_face_range_metadata : Bool
      call_bool("get", "add_collision_shape_face_range_metadata")
    end

    def add_collision_shape_face_range_metadata=(val) : Void
      call("set", "add_collision_shape_face_range_metadata", val)
    end

    # Property `Scripting` (Void)
    def scripting : String
      call_str("get", "Scripting")
    end

    def scripting=(val) : Void
      call("set", "Scripting", val)
    end

    # Property `script_class` (Godot::Script?)
    def script_class : Godot::Script?
      call_obj_as(Godot::Script, "get", "script_class")
    end

    def script_class=(val) : Void
      call("set", "script_class", val)
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

alias FuncGodotFGDSolidClass = Godot::FuncGodotFGDSolidClass
