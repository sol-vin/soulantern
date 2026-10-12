# Generated strongly typed wrapper for GDScript node `PalletteSwapScreenSpaceCanvas`
# Script Path: res://addons/advanced_palette_swap/nodes/palette_swap_screen_space_canvas.gd
module Godot
  class PalletteSwapScreenSpaceCanvas < Godot::CanvasLayer
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `material_path` (String)
    def material_path : String
      call_str("get", "material_path")
    end

    def material_path=(val) : Void
      call("set", "material_path", val)
    end

    # Property `shader_path` (String)
    def shader_path : String
      call_str("get", "shader_path")
    end

    def shader_path=(val) : Void
      call("set", "shader_path", val)
    end

    # Property `use_screen_texture` (Bool)
    def use_screen_texture : Bool
      call_bool("get", "use_screen_texture")
    end

    def use_screen_texture=(val) : Void
      call("set", "use_screen_texture", val)
    end

    # Property `dither_strength` (Float64)
    def dither_strength : Float64
      call_f64("get", "dither_strength")
    end

    def dither_strength=(val) : Void
      call("set", "dither_strength", val)
    end

    # Property `color_distance_mode` (Int64)
    def color_distance_mode : Int64
      call_i64("get", "color_distance_mode")
    end

    def color_distance_mode=(val) : Void
      call("set", "color_distance_mode", val)
    end

    # Property `Input Adjustments` (Void)
    def input_adjustments : String
      call_str("get", "Input Adjustments")
    end

    def input_adjustments=(val) : Void
      call("set", "Input Adjustments", val)
    end

    # Property `input_lightness` (Float64)
    def input_lightness : Float64
      call_f64("get", "input_lightness")
    end

    def input_lightness=(val) : Void
      call("set", "input_lightness", val)
    end

    # Property `input_saturation` (Float64)
    def input_saturation : Float64
      call_f64("get", "input_saturation")
    end

    def input_saturation=(val) : Void
      call("set", "input_saturation", val)
    end

    # Property `input_contrast` (Float64)
    def input_contrast : Float64
      call_f64("get", "input_contrast")
    end

    def input_contrast=(val) : Void
      call("set", "input_contrast", val)
    end

    # Property `Color Channels` (Void)
    def color_channels : String
      call_str("get", "Color Channels")
    end

    def color_channels=(val) : Void
      call("set", "Color Channels", val)
    end

    # Property `input_red` (Float64)
    def input_red : Float64
      call_f64("get", "input_red")
    end

    def input_red=(val) : Void
      call("set", "input_red", val)
    end

    # Property `input_green` (Float64)
    def input_green : Float64
      call_f64("get", "input_green")
    end

    def input_green=(val) : Void
      call("set", "input_green", val)
    end

    # Property `input_blue` (Float64)
    def input_blue : Float64
      call_f64("get", "input_blue")
    end

    def input_blue=(val) : Void
      call("set", "input_blue", val)
    end

    # Property `reapply_setup` (Bool)
    def reapply_setup : Bool
      call_bool("get", "reapply_setup")
    end

    def reapply_setup=(val) : Void
      call("set", "reapply_setup", val)
    end

    # Property `_color_rect` (Godot::ColorRect?)
    def _color_rect : Godot::ColorRect?
      call_obj_as(Godot::ColorRect, "get", "_color_rect")
    end

    def _color_rect=(val) : Void
      call("set", "_color_rect", val)
    end

    # Method `_ready` -> Void
    def _ready : Void
      call("_ready")
      nil
    end

    # Method `get_color_rect` -> Godot::ColorRect?
    def get_color_rect : Godot::ColorRect?
      call_obj_as(Godot::ColorRect, "get_color_rect")
    end

    # Method `setup_screenspace_canvas` -> Void
    def setup_screenspace_canvas : Void
      call("setup_screenspace_canvas")
      nil
    end

    # Method `sync_from_material_file` -> Void
    def sync_from_material_file : Void
      call("sync_from_material_file")
      nil
    end

    # Method `_update_material_shader` -> Void
    def _update_material_shader(force_reload : Bool) : Void
      call("_update_material_shader", force_reload)
      nil
    end

    # Method `_update_param` -> Void
    def _update_param(param_name : String, value) : Void
      call("_update_param", param_name, value)
      nil
    end
  end
end

alias PalletteSwapScreenSpaceCanvas = Godot::PalletteSwapScreenSpaceCanvas
