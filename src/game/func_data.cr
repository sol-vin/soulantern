require "lapis"

module Soulantern
  # TrenchBroom entity data container node for properties and metadata.
  node FuncData < Node3D do
    @[Export]
    property key : String = ""
    @[Export]
    property value : String = ""
    @[Export]
    property targetname : String = ""

    def _func_godot_apply_properties(props : Dictionary) : Void
      if props.has_key?("key")
        @key = props["key"].as_string
      end
      if props.has_key?("value")
        @value = props["value"].as_string
      end
      if props.has_key?("targetname")
        @targetname = props["targetname"].as_string
      end
      if props.has_key?("name") && !props["name"].as_string.strip.empty?
        self.name = props["name"].as_string.strip
      end
    end
  end
end
