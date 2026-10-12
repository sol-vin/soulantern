# Generated strongly typed wrapper for GDScript node `QuakePaletteImportPlugin`
# Script Path: res://addons/func_godot/src/import/quake_palette_import_plugin.gd
module Godot
  class QuakePaletteImportPlugin < Godot::EditorImportPlugin
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Method `_get_importer_name` -> String
    def _get_importer_name : String
      call_str("_get_importer_name")
    end

    # Method `_get_visible_name` -> String
    def _get_visible_name : String
      call_str("_get_visible_name")
    end

    # Method `_get_resource_type` -> String
    def _get_resource_type : String
      call_str("_get_resource_type")
    end

    # Method `_get_recognized_extensions` -> Void
    def _get_recognized_extensions : Void
      call("_get_recognized_extensions")
      nil
    end

    # Method `_get_save_extension` -> String
    def _get_save_extension : String
      call_str("_get_save_extension")
    end

    # Method `_get_import_options` -> Void
    def _get_import_options(path, preset) : Void
      call("_get_import_options", path, preset)
      nil
    end

    # Method `_get_preset_count` -> Int64
    def _get_preset_count : Int64
      call_i64("_get_preset_count")
    end

    # Method `_get_priority` -> Float64
    def _get_priority : Float64
      call_f64("_get_priority")
    end

    # Method `_get_import_order` -> Int64
    def _get_import_order : Int64
      call_i64("_get_import_order")
    end

    # Method `_import` -> Godot::Error?
    def _import(source_file, save_path, options, r_platform_variants, r_gen_files) : Godot::Error?
      call_i64("_import", source_file, save_path, options, r_platform_variants, r_gen_files)
    end
  end
end

alias QuakePaletteImportPlugin = Godot::QuakePaletteImportPlugin
