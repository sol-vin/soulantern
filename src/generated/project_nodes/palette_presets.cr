# Generated strongly typed wrapper for GDScript node `PalettePresets`
# Script Path: res://addons/advanced_palette_swap/core/palette_presets.gd
module Godot
  class PalettePresets < Godot::RefCounted
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Method `get_preset_names` -> Void
    def get_preset_names : Void
      call("get_preset_names")
      nil
    end

    # Method `get_preset_colors` -> Void
    def get_preset_colors(preset_name : String) : Void
      call("get_preset_colors", preset_name)
      nil
    end

    # Method `get_default_palette_files` -> Void
    def get_default_palette_files : Void
      call("get_default_palette_files")
      nil
    end
  end
end

alias PalettePresets = Godot::PalettePresets
