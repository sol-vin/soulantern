# Generated strongly typed wrapper for GDScript node `PaletteGenerator`
# Script Path: res://addons/advanced_palette_swap/core/palette_generator.gd
module Godot
  class PaletteGenerator < Godot::RefCounted
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Method `srgb_to_linear` -> Float64
    def srgb_to_linear(c : Float64) : Float64
      call_f64("srgb_to_linear", c)
    end

    # Method `color_to_oklab` -> Void
    def color_to_oklab(color : Godot::Color) : Void
      call("color_to_oklab", color)
      nil
    end

    # Method `generate_shaderinc_code` -> String
    def generate_shaderinc_code(colors : Godot::Array) : String
      call_str("generate_shaderinc_code", colors)
    end

    # Method `write_palette_files` -> Void
    def write_palette_files(output_dir : String, colors : Godot::Array, overwrite_main_shader : Bool, params : Godot::Dictionary) : Void
      call("write_palette_files", output_dir, colors, overwrite_main_shader, params)
      nil
    end

    # Method `read_material_parameters` -> Void
    def read_material_parameters(material_path : String) : Void
      call("read_material_parameters", material_path)
      nil
    end

    # Method `rescan_filesystem` -> Void
    def rescan_filesystem(paths : Godot::PackedStringArray) : Void
      call("rescan_filesystem", paths)
      nil
    end

    # Method `export_to_json` -> Bool
    def export_to_json(filepath : String, colors : Godot::Array) : Bool
      call_bool("export_to_json", filepath, colors)
    end

    # Method `import_from_json` -> Void
    def import_from_json(filepath : String) : Void
      call("import_from_json", filepath)
      nil
    end

    # Method `export_to_hex` -> Bool
    def export_to_hex(filepath : String, colors : Godot::Array) : Bool
      call_bool("export_to_hex", filepath, colors)
    end

    # Method `import_from_hex` -> Void
    def import_from_hex(filepath : String) : Void
      call("import_from_hex", filepath)
      nil
    end
  end
end

alias PaletteGenerator = Godot::PaletteGenerator
