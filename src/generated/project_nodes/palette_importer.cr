# Generated strongly typed wrapper for GDScript node `PaletteImporter`
# Script Path: res://addons/advanced_palette_swap/core/palette_importer.gd
module Godot
  class PaletteImporter < Godot::RefCounted
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Method `import_file` -> Godot::PaletteResource?
    def import_file(file_path : String, skip_transparent : Bool) : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "import_file", file_path, skip_transparent)
    end

    # Method `import_from_gpl` -> Godot::PaletteResource?
    def import_from_gpl(file_path : String) : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "import_from_gpl", file_path)
    end

    # Method `parse_gpl_string` -> Godot::PaletteResource?
    def parse_gpl_string(content : String, default_name : String) : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "parse_gpl_string", content, default_name)
    end

    # Method `import_from_pal` -> Godot::PaletteResource?
    def import_from_pal(file_path : String) : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "import_from_pal", file_path)
    end

    # Method `_parse_riff_pal` -> Godot::PaletteResource?
    def _parse_riff_pal(file : Godot::FileAccess, default_name : String) : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "_parse_riff_pal", file, default_name)
    end

    # Method `parse_pal_string` -> Godot::PaletteResource?
    def parse_pal_string(content : String, default_name : String) : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "parse_pal_string", content, default_name)
    end

    # Method `import_from_png` -> Godot::PaletteResource?
    def import_from_png(file_path : String, skip_transparent : Bool) : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "import_from_png", file_path, skip_transparent)
    end

    # Method `extract_colors_from_image` -> Godot::PaletteResource?
    def extract_colors_from_image(image : Godot::Image, palette_name : String, skip_transparent : Bool) : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "extract_colors_from_image", image, palette_name, skip_transparent)
    end

    # Method `import_from_hex` -> Godot::PaletteResource?
    def import_from_hex(file_path : String) : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "import_from_hex", file_path)
    end

    # Method `import_from_json` -> Godot::PaletteResource?
    def import_from_json(file_path : String) : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "import_from_json", file_path)
    end

    # Method `batch_import_files` -> Void
    def batch_import_files(file_paths : Godot::PackedStringArray, destination_dir : String, skip_transparent : Bool) : Void
      call("batch_import_files", file_paths, destination_dir, skip_transparent)
      nil
    end

    # Method `batch_import_directory` -> Void
    def batch_import_directory(source_dir : String, destination_dir : String, recursive : Bool, skip_transparent : Bool) : Void
      call("batch_import_directory", source_dir, destination_dir, recursive, skip_transparent)
      nil
    end

    # Method `_tokenize_whitespace` -> Void
    def _tokenize_whitespace(text : String) : Void
      call("_tokenize_whitespace", text)
      nil
    end

    # Method `_is_hex_string` -> Bool
    def _is_hex_string(s : String) : Bool
      call_bool("_is_hex_string", s)
    end

    # Method `_sanitize_filename` -> String
    def _sanitize_filename(name : String) : String
      call_str("_sanitize_filename", name)
    end

    # Method `_rescan_filesystem` -> Void
    def _rescan_filesystem(paths : Godot::PackedStringArray) : Void
      call("_rescan_filesystem", paths)
      nil
    end
  end
end

alias PaletteImporter = Godot::PaletteImporter
