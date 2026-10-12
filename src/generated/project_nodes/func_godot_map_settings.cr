# Generated strongly typed wrapper for GDScript node `FuncGodotMapSettings`
# Script Path: res://addons/func_godot/src/map/func_godot_map_settings.gd
module Godot
  class FuncGodotMapSettings < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `Build Settings` (Void)
    def build_settings : String
      call_str("get", "Build Settings")
    end

    def build_settings=(val) : Void
      call("set", "Build Settings", val)
    end

    # Property `scale_factor` (Float64)
    def scale_factor : Float64
      call_f64("get", "scale_factor")
    end

    def scale_factor=(val) : Void
      call("set", "scale_factor", val)
    end

    # Property `inverse_scale_factor` (Float64)
    def inverse_scale_factor : Float64
      call_f64("get", "inverse_scale_factor")
    end

    def inverse_scale_factor=(val) : Void
      call("set", "inverse_scale_factor", val)
    end

    # Property `entity_fgd` (Godot::FuncGodotFGDFile?)
    def entity_fgd : Godot::FuncGodotFGDFile?
      call_obj_as(Godot::FuncGodotFGDFile, "get", "entity_fgd")
    end

    def entity_fgd=(val) : Void
      call("set", "entity_fgd", val)
    end

    # Property `use_groups_hierarchy` (Bool)
    def use_groups_hierarchy : Bool
      call_bool("get", "use_groups_hierarchy")
    end

    def use_groups_hierarchy=(val) : Void
      call("set", "use_groups_hierarchy", val)
    end

    # Property `uv_unwrap_texel_size` (Float64)
    def uv_unwrap_texel_size : Float64
      call_f64("get", "uv_unwrap_texel_size")
    end

    def uv_unwrap_texel_size=(val) : Void
      call("set", "uv_unwrap_texel_size", val)
    end

    # Property `Entity Settings` (Void)
    def entity_settings : String
      call_str("get", "Entity Settings")
    end

    def entity_settings=(val) : Void
      call("set", "Entity Settings", val)
    end

    # Property `entity_node_groups` (Void)
    def entity_node_groups : String
      call_str("get", "entity_node_groups")
    end

    def entity_node_groups=(val) : Void
      call("set", "entity_node_groups", val)
    end

    # Property `Entity Property Names` (Void)
    def entity_property_names : String
      call_str("get", "Entity Property Names")
    end

    def entity_property_names=(val) : Void
      call("set", "Entity Property Names", val)
    end

    # Property `entity_name_property` (String)
    def entity_name_property : String
      call_str("get", "entity_name_property")
    end

    def entity_name_property=(val) : Void
      call("set", "entity_name_property", val)
    end

    # Property `entity_smoothing_property` (String)
    def entity_smoothing_property : String
      call_str("get", "entity_smoothing_property")
    end

    def entity_smoothing_property=(val) : Void
      call("set", "entity_smoothing_property", val)
    end

    # Property `entity_smoothing_angle_property` (String)
    def entity_smoothing_angle_property : String
      call_str("get", "entity_smoothing_angle_property")
    end

    def entity_smoothing_angle_property=(val) : Void
      call("set", "entity_smoothing_angle_property", val)
    end

    # Property `vertex_merge_distance_property` (String)
    def vertex_merge_distance_property : String
      call_str("get", "vertex_merge_distance_property")
    end

    def vertex_merge_distance_property=(val) : Void
      call("set", "vertex_merge_distance_property", val)
    end

    # Property `cull_interior_faces_property` (String)
    def cull_interior_faces_property : String
      call_str("get", "cull_interior_faces_property")
    end

    def cull_interior_faces_property=(val) : Void
      call("set", "cull_interior_faces_property", val)
    end

    # Property `Textures` (Void)
    def textures : String
      call_str("get", "Textures")
    end

    def textures=(val) : Void
      call("set", "Textures", val)
    end

    # Property `base_texture_dir` (String)
    def base_texture_dir : String
      call_str("get", "base_texture_dir")
    end

    def base_texture_dir=(val) : Void
      call("set", "base_texture_dir", val)
    end

    # Property `texture_file_extensions` (Void)
    def texture_file_extensions : String
      call_str("get", "texture_file_extensions")
    end

    def texture_file_extensions=(val) : Void
      call("set", "texture_file_extensions", val)
    end

    # Property `Hint Textures` (Void)
    def hint_textures : String
      call_str("get", "Hint Textures")
    end

    def hint_textures=(val) : Void
      call("set", "Hint Textures", val)
    end

    # Property `clip_texture` (String)
    def clip_texture : String
      call_str("get", "clip_texture")
    end

    def clip_texture=(val) : Void
      call("set", "clip_texture", val)
    end

    # Property `skip_texture` (String)
    def skip_texture : String
      call_str("get", "skip_texture")
    end

    def skip_texture=(val) : Void
      call("set", "skip_texture", val)
    end

    # Property `origin_texture` (String)
    def origin_texture : String
      call_str("get", "origin_texture")
    end

    def origin_texture=(val) : Void
      call("set", "origin_texture", val)
    end

    # Property `texture_wads` (Void)
    def texture_wads : String
      call_str("get", "texture_wads")
    end

    def texture_wads=(val) : Void
      call("set", "texture_wads", val)
    end

    # Property `Materials` (Void)
    def materials : String
      call_str("get", "Materials")
    end

    def materials=(val) : Void
      call("set", "Materials", val)
    end

    # Property `base_material_dir` (String)
    def base_material_dir : String
      call_str("get", "base_material_dir")
    end

    def base_material_dir=(val) : Void
      call("set", "base_material_dir", val)
    end

    # Property `material_file_extension` (String)
    def material_file_extension : String
      call_str("get", "material_file_extension")
    end

    def material_file_extension=(val) : Void
      call("set", "material_file_extension", val)
    end

    # Property `default_material` (Godot::Material?)
    def default_material : Godot::Material?
      call_obj_as(Godot::Material, "get", "default_material")
    end

    def default_material=(val) : Void
      call("set", "default_material", val)
    end

    # Property `default_material_albedo_uniform` (String)
    def default_material_albedo_uniform : String
      call_str("get", "default_material_albedo_uniform")
    end

    def default_material_albedo_uniform=(val) : Void
      call("set", "default_material_albedo_uniform", val)
    end

    # Property `shader_material_uniform_map_patterns` (Void)
    def shader_material_uniform_map_patterns : String
      call_str("get", "shader_material_uniform_map_patterns")
    end

    def shader_material_uniform_map_patterns=(val) : Void
      call("set", "shader_material_uniform_map_patterns", val)
    end

    # Property `BaseMaterial3D Map Patterns` (Void)
    def base_material3_d_map_patterns : String
      call_str("get", "BaseMaterial3D Map Patterns")
    end

    def base_material3_d_map_patterns=(val) : Void
      call("set", "BaseMaterial3D Map Patterns", val)
    end

    # Property `albedo_map_pattern` (String)
    def albedo_map_pattern : String
      call_str("get", "albedo_map_pattern")
    end

    def albedo_map_pattern=(val) : Void
      call("set", "albedo_map_pattern", val)
    end

    # Property `normal_map_pattern` (String)
    def normal_map_pattern : String
      call_str("get", "normal_map_pattern")
    end

    def normal_map_pattern=(val) : Void
      call("set", "normal_map_pattern", val)
    end

    # Property `metallic_map_pattern` (String)
    def metallic_map_pattern : String
      call_str("get", "metallic_map_pattern")
    end

    def metallic_map_pattern=(val) : Void
      call("set", "metallic_map_pattern", val)
    end

    # Property `roughness_map_pattern` (String)
    def roughness_map_pattern : String
      call_str("get", "roughness_map_pattern")
    end

    def roughness_map_pattern=(val) : Void
      call("set", "roughness_map_pattern", val)
    end

    # Property `emission_map_pattern` (String)
    def emission_map_pattern : String
      call_str("get", "emission_map_pattern")
    end

    def emission_map_pattern=(val) : Void
      call("set", "emission_map_pattern", val)
    end

    # Property `ao_map_pattern` (String)
    def ao_map_pattern : String
      call_str("get", "ao_map_pattern")
    end

    def ao_map_pattern=(val) : Void
      call("set", "ao_map_pattern", val)
    end

    # Property `height_map_pattern` (String)
    def height_map_pattern : String
      call_str("get", "height_map_pattern")
    end

    def height_map_pattern=(val) : Void
      call("set", "height_map_pattern", val)
    end

    # Property `orm_map_pattern` (String)
    def orm_map_pattern : String
      call_str("get", "orm_map_pattern")
    end

    def orm_map_pattern=(val) : Void
      call("set", "orm_map_pattern", val)
    end

    # Property `save_generated_materials` (Bool)
    def save_generated_materials : Bool
      call_bool("get", "save_generated_materials")
    end

    def save_generated_materials=(val) : Void
      call("set", "save_generated_materials", val)
    end
  end
end

alias FuncGodotMapSettings = Godot::FuncGodotMapSettings
