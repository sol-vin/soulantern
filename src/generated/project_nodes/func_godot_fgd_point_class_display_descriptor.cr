# Generated strongly typed wrapper for GDScript node `FuncGodotFGDPointClassDisplayDescriptor`
# Script Path: res://addons/func_godot/src/fgd/func_godot_fgd_point_class_display_descriptor.gd
module Godot
  class FuncGodotFGDPointClassDisplayDescriptor < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `display_asset_path` (String)
    def display_asset_path : String
      call_str("get", "display_asset_path")
    end

    def display_asset_path=(val) : Void
      call("set", "display_asset_path", val)
    end

    # Property `TrenchBroom Options` (Void)
    def trench_broom_options : String
      call_str("get", "TrenchBroom Options")
    end

    def trench_broom_options=(val) : Void
      call("set", "TrenchBroom Options", val)
    end

    # Property `scale` (String)
    def scale : String
      call_str("get", "scale")
    end

    def scale=(val) : Void
      call("set", "scale", val)
    end

    # Property `skin` (String)
    def skin : String
      call_str("get", "skin")
    end

    def skin=(val) : Void
      call("set", "skin", val)
    end

    # Property `frame` (String)
    def frame : String
      call_str("get", "frame")
    end

    def frame=(val) : Void
      call("set", "frame", val)
    end

    # Property `conditional` (String)
    def conditional : String
      call_str("get", "conditional")
    end

    def conditional=(val) : Void
      call("set", "conditional", val)
    end
  end
end

alias FuncGodotFGDPointClassDisplayDescriptor = Godot::FuncGodotFGDPointClassDisplayDescriptor
