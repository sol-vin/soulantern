# Generated strongly typed wrapper for GDScript node `TrenchBroomTag`
# Script Path: res://addons/func_godot/src/trenchbroom/trenchbroom_tag.gd
module Godot
  class TrenchBroomTag < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `tag_name` (String)
    def tag_name : String
      call_str("get", "tag_name")
    end

    def tag_name=(val) : Void
      call("set", "tag_name", val)
    end

    # Property `tag_attributes` (Void)
    def tag_attributes : String
      call_str("get", "tag_attributes")
    end

    def tag_attributes=(val) : Void
      call("set", "tag_attributes", val)
    end

    # Property `tag_match_type` (Godot::TrenchBroomTagTagMatchType?)
    def tag_match_type : Int64
      call_i64("get", "tag_match_type")
    end

    def tag_match_type=(val) : Void
      call("set", "tag_match_type", val)
    end

    # Property `tag_pattern` (String)
    def tag_pattern : String
      call_str("get", "tag_pattern")
    end

    def tag_pattern=(val) : Void
      call("set", "tag_pattern", val)
    end

    # Property `texture_name` (String)
    def texture_name : String
      call_str("get", "texture_name")
    end

    def texture_name=(val) : Void
      call("set", "texture_name", val)
    end
  end
end

alias TrenchBroomTag = Godot::TrenchBroomTag
