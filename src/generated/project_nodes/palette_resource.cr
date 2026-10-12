# Generated strongly typed wrapper for GDScript node `PaletteResource`
# Script Path: res://addons/advanced_palette_swap/core/color_palette.gd
module Godot
  class PaletteResource < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `palette_name` (String)
    def palette_name : String
      call_str("get", "palette_name")
    end

    def palette_name=(val) : Void
      call("set", "palette_name", val)
    end

    # Property `colors` (Void)
    def colors : String
      call_str("get", "colors")
    end

    def colors=(val) : Void
      call("set", "colors", val)
    end

    # Property `author` (String)
    def author : String
      call_str("get", "author")
    end

    def author=(val) : Void
      call("set", "author", val)
    end

    # Property `comment` (String)
    def comment : String
      call_str("get", "comment")
    end

    def comment=(val) : Void
      call("set", "comment", val)
    end

    # Method `_init` -> Void
    def _init(p_name : String, p_colors : Godot::Array, p_author : String, p_comment : String) : Void
      call("_init", p_name, p_colors, p_author, p_comment)
      nil
    end

    # Method `get_colors` -> Void
    def get_colors : Void
      call("get_colors")
      nil
    end

    # Method `set_colors` -> Void
    def set_colors(new_colors : Godot::Array) : Void
      call("set_colors", new_colors)
      nil
    end

    # Method `size` -> Int64
    def size : Int64
      call_i64("size")
    end

    # Method `is_empty` -> Bool
    def is_empty : Bool
      call_bool("is_empty")
    end

    # Method `to_hex_array` -> Void
    def to_hex_array : Void
      call("to_hex_array")
      nil
    end

    # Method `save_to_file` -> Godot::Error?
    def save_to_file(path : String) : Godot::Error?
      call_i64("save_to_file", path)
    end

    # Method `load_from_file` -> Godot::PaletteResource?
    def load_from_file(path : String) : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "load_from_file", path)
    end

    # Method `create` -> Godot::PaletteResource?
    def create(p_name : String, p_colors : Godot::Array, p_author : String, p_comment : String) : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "create", p_name, p_colors, p_author, p_comment)
    end
  end
end

alias PaletteResource = Godot::PaletteResource
