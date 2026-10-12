# Generated strongly typed wrapper for GDScript node `NetRadiantCustomGamePackConfig`
# Script Path: res://addons/func_godot/src/netradiant_custom/netradiant_custom_gamepack_config.gd
module Godot
  class NetRadiantCustomGamePackConfig < Godot::Resource
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

    # Property `gamepack_name` (String)
    def gamepack_name : String
      call_str("get", "gamepack_name")
    end

    def gamepack_name=(val) : Void
      call("set", "gamepack_name", val)
    end

    # Property `game_name` (String)
    def game_name : String
      call_str("get", "game_name")
    end

    def game_name=(val) : Void
      call("set", "game_name", val)
    end

    # Property `base_game_path` (String)
    def base_game_path : String
      call_str("get", "base_game_path")
    end

    def base_game_path=(val) : Void
      call("set", "base_game_path", val)
    end

    # Property `fgd_file` (Godot::FuncGodotFGDFile?)
    def fgd_file : Godot::FuncGodotFGDFile?
      call_obj_as(Godot::FuncGodotFGDFile, "get", "fgd_file")
    end

    def fgd_file=(val) : Void
      call("set", "fgd_file", val)
    end

    # Property `generate_model_point_class_models` (Bool)
    def generate_model_point_class_models : Bool
      call_bool("get", "generate_model_point_class_models")
    end

    def generate_model_point_class_models=(val) : Void
      call("set", "generate_model_point_class_models", val)
    end

    # Property `netradiant_custom_shaders` (Void)
    def netradiant_custom_shaders : String
      call_str("get", "netradiant_custom_shaders")
    end

    def netradiant_custom_shaders=(val) : Void
      call("set", "netradiant_custom_shaders", val)
    end

    # Property `model_types` (Void)
    def model_types : String
      call_str("get", "model_types")
    end

    def model_types=(val) : Void
      call("set", "model_types", val)
    end

    # Property `sound_types` (Void)
    def sound_types : String
      call_str("get", "sound_types")
    end

    def sound_types=(val) : Void
      call("set", "sound_types", val)
    end

    # Property `map_type` (Godot::NetRadiantCustomGamePackConfigNetRadiantCustomMapType?)
    def map_type : Int64
      call_i64("get", "map_type")
    end

    def map_type=(val) : Void
      call("set", "map_type", val)
    end

    # Property `Textures` (Void)
    def textures : String
      call_str("get", "Textures")
    end

    def textures=(val) : Void
      call("set", "Textures", val)
    end

    # Property `texture_types` (Void)
    def texture_types : String
      call_str("get", "texture_types")
    end

    def texture_types=(val) : Void
      call("set", "texture_types", val)
    end

    # Property `default_scale` (String)
    def default_scale : String
      call_str("get", "default_scale")
    end

    def default_scale=(val) : Void
      call("set", "default_scale", val)
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

    # Property `Build Menu` (Void)
    def build_menu : String
      call_str("get", "Build Menu")
    end

    def build_menu=(val) : Void
      call("set", "Build Menu", val)
    end

    # Property `default_build_menu_variables` (Void)
    def default_build_menu_variables : String
      call_str("get", "default_build_menu_variables")
    end

    def default_build_menu_variables=(val) : Void
      call("set", "default_build_menu_variables", val)
    end

    # Property `default_build_menu_commands` (Void)
    def default_build_menu_commands : String
      call_str("get", "default_build_menu_commands")
    end

    def default_build_menu_commands=(val) : Void
      call("set", "default_build_menu_commands", val)
    end

    # Method `_build_shader_text` -> String
    def _build_shader_text : String
      call_str("_build_shader_text")
    end

    # Method `_build_gamepack_text` -> String
    def _build_gamepack_text : String
      call_str("_build_gamepack_text")
    end

    # Method `export_file` -> Void
    def export_file : Void
      call("export_file")
      nil
    end
  end
end

alias NetRadiantCustomGamePackConfig = Godot::NetRadiantCustomGamePackConfig
