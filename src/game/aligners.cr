require "lapis"

module Soulantern
  # Automated light and mesh aligner for TrenchBroom marker entities.
  node MassAligner < Node3D do
    @[Export]
    property references : NodePath = NodePath.new
    @[Export]
    property targets : Array(String) = [] of String

    def _ready : Void
      return if Engine.is_editor_hint
      align_all
    end

    def align_all : Void
      ref_node = get_node_or_null(references)
      return unless ref_node

      template_light = get_children.find { |c| c.as?(OmniLight3D) }.try(&.as?(OmniLight3D))
      return unless template_light

      all_descendants = ref_node.get_nodes("**")

      all_descendants.each do |node|
        targets.each do |pat|
          clean_pat = pat.gsub("*", "")
          if node.name.includes?(clean_pat)
            if node3d = node.as?(Node3D)
              # Attach active light clone if not already present
              unless node3d.has_node("Light")
                clone = template_light.duplicate.as?(OmniLight3D)
                if clone
                  clone.name = "Light"
                  clone.visible = true
                  clone.process_mode = Node::ProcessMode::ProcessModeAlways
                  node3d << clone
                end
              end
            end
          end
        end
      end
    end
  end
end
