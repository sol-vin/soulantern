# Generated strongly typed wrapper for GDScript node `FuncGodotData`
# Script Path: res://addons/func_godot/src/core/data.gd
module Godot
  class FuncGodotData < Godot::RefCounted
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end
  end
end

alias FuncGodotData = Godot::FuncGodotData
