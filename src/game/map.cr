require "lapis"

module Soulantern
  # Map container node managing level geometry and entity post-processing.
  node Map < Node3D do
    signal on_rebuild_complete

    @[Export]

    property local_map_file : String = ""

    def on_build_complete : Void
      all_nodes = Array(Godot::Node).new
      collect_all_descendants(self, all_nodes)

      all_nodes.each do |child|
        next if child == self
        if child.has_method("on_map_build")
          child.call("on_map_build") rescue nil
        elsif child.has_method("rebuild")
          child.call("rebuild") rescue nil
        end
      end

      emit(on_rebuild_complete)
    end

    def collect_all_descendants(node : Godot::Node, result : Array(Godot::Node)) : Void
      children = node.get_children
      (0...children.size).each do |i|
        c = children[i].as(Godot::Node)
        result << c
        collect_all_descendants(c, result)
      end
    end
  end
end
