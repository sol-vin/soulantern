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

      # Duplicate template child light to all target positions if templates exist
      children = get_children
      template_light : OmniLight3D? = nil
      (0...children.size).each do |i|
        if l = children[i].as?(OmniLight3D)
          template_light = l
          break
        end
      end

      return unless template_light

      # Find matching targets in references
      all_descendants = Array(Godot::Node).new
      collect_descendants(ref_node, all_descendants)

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
                  node3d.add_child(clone)
                end
              end
            end
          end
        end
      end
    end

    def collect_descendants(node : Godot::Node, result : Array(Godot::Node)) : Void
      children = node.get_children
      (0...children.size).each do |i|
        c = children[i].as(Godot::Node)
        result << c
        collect_descendants(c, result)
      end
    end
  end
end
