# Generated strongly typed wrapper for GDScript node `NetRadiantCustomShader`
# Script Path: res://addons/func_godot/src/netradiant_custom/netradiant_custom_shader.gd
module Godot
  class NetRadiantCustomShader < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `texture_path` (String)
    def texture_path : String
      call_str("get", "texture_path")
    end

    def texture_path=(val) : Void
      call("set", "texture_path", val)
    end

    # Property `shader_attributes` (Void)
    def shader_attributes : String
      call_str("get", "shader_attributes")
    end

    def shader_attributes=(val) : Void
      call("set", "shader_attributes", val)
    end
  end
end

alias NetRadiantCustomShader = Godot::NetRadiantCustomShader
