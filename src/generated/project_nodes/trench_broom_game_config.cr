# Generated strongly typed wrapper for GDScript node `TrenchBroomGameConfig`
# Script Path: res://addons/func_godot/src/trenchbroom/trenchbroom_game_config.gd
module Godot
  class TrenchBroomGameConfig < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `_export_file` (Void)
    def _export_file : String
      call_str("get", "_export_file")
    end

    def _export_file=(val) : Void
      call("set", "_export_file", val)
    end

    # Property `game_name` (String)
    def game_name : String
      call_str("get", "game_name")
    end

    def game_name=(val) : Void
      call("set", "game_name", val)
    end

    # Property `icon` (Godot::Texture2D?)
    def icon : Godot::Texture2D?
      call_obj_as(Godot::Texture2D, "get", "icon")
    end

    def icon=(val) : Void
      call("set", "icon", val)
    end

    # Property `map_formats` (Void)
    def map_formats : String
      call_str("get", "map_formats")
    end

    def map_formats=(val) : Void
      call("set", "map_formats", val)
    end

    # Property `Textures` (Void)
    def textures : String
      call_str("get", "Textures")
    end

    def textures=(val) : Void
      call("set", "Textures", val)
    end

    # Property `textures_root_folder` (String)
    def textures_root_folder : String
      call_str("get", "textures_root_folder")
    end

    def textures_root_folder=(val) : Void
      call("set", "textures_root_folder", val)
    end

    # Property `texture_exclusion_patterns` (Void)
    def texture_exclusion_patterns : String
      call_str("get", "texture_exclusion_patterns")
    end

    def texture_exclusion_patterns=(val) : Void
      call("set", "texture_exclusion_patterns", val)
    end

    # Property `palette_path` (String)
    def palette_path : String
      call_str("get", "palette_path")
    end

    def palette_path=(val) : Void
      call("set", "palette_path", val)
    end

    # Property `Entities` (Void)
    def entities : String
      call_str("get", "Entities")
    end

    def entities=(val) : Void
      call("set", "Entities", val)
    end

    # Property `fgd_file` (Godot::FuncGodotFGDFile?)
    def fgd_file : Godot::FuncGodotFGDFile?
      call_obj_as(Godot::FuncGodotFGDFile, "get", "fgd_file")
    end

    def fgd_file=(val) : Void
      call("set", "fgd_file", val)
    end

    # Property `entity_scale` (String)
    def entity_scale : String
      call_str("get", "entity_scale")
    end

    def entity_scale=(val) : Void
      call("set", "entity_scale", val)
    end

    # Property `generate_model_point_class_models` (Bool)
    def generate_model_point_class_models : Bool
      call_bool("get", "generate_model_point_class_models")
    end

    def generate_model_point_class_models=(val) : Void
      call("set", "generate_model_point_class_models", val)
    end

    # Property `Tags` (Void)
    def tags : String
      call_str("get", "Tags")
    end

    def tags=(val) : Void
      call("set", "Tags", val)
    end

    # Property `brush_tags` (Void)
    def brush_tags : String
      call_str("get", "brush_tags")
    end

    def brush_tags=(val) : Void
      call("set", "brush_tags", val)
    end

    # Property `brushface_tags` (Void)
    def brushface_tags : String
      call_str("get", "brushface_tags")
    end

    def brushface_tags=(val) : Void
      call("set", "brushface_tags", val)
    end

    # Property `Face Attributes` (Void)
    def face_attributes : String
      call_str("get", "Face Attributes")
    end

    def face_attributes=(val) : Void
      call("set", "Face Attributes", val)
    end

    # Property `default_uv_scale` (Void)
    def default_uv_scale : String
      call_str("get", "default_uv_scale")
    end

    def default_uv_scale=(val) : Void
      call("set", "default_uv_scale", val)
    end

    # Property `Compatibility` (Void)
    def compatibility : String
      call_str("get", "Compatibility")
    end

    def compatibility=(val) : Void
      call("set", "Compatibility", val)
    end

    # Property `game_config_version` (Godot::TrenchBroomGameConfigGameConfigVersion?)
    def game_config_version : Int64
      call_i64("get", "game_config_version")
    end

    def game_config_version=(val) : Void
      call("set", "game_config_version", val)
    end

    # Method `_get_match_key` -> String
    def _get_match_key(tag_match_type : Int64) : String
      call_str("_get_match_key", tag_match_type)
    end

    # Method `_build_class_text` -> String
    def _build_class_text : String
      call_str("_build_class_text")
    end

    # Method `_parse_tags` -> String
    def _parse_tags(tags : Godot::Array) : String
      call_str("_parse_tags", tags)
    end

    # Method `_parse_flags` -> String
    def _parse_flags(flags : Godot::Array) : String
      call_str("_parse_flags", flags)
    end

    # Method `_parse_default_uv_scale` -> String
    def _parse_default_uv_scale(texture_scale : Godot::Vector2) : String
      call_str("_parse_default_uv_scale", texture_scale)
    end

    # Method `export_file` -> Void
    def export_file : Void
      call("export_file")
      nil
    end

    # Method `_get_game_config_v4_text` -> String
    def _get_game_config_v4_text : String
      call_str("_get_game_config_v4_text")
    end

    # Method `_get_game_config_v9v8_text` -> String
    def _get_game_config_v9v8_text : String
      call_str("_get_game_config_v9v8_text")
    end
  end
end

alias TrenchBroomGameConfig = Godot::TrenchBroomGameConfig
