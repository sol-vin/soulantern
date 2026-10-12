# Generated strongly typed wrapper for GDScript node `FuncGodotFGDFile`
# Script Path: res://addons/func_godot/src/fgd/func_godot_fgd_file.gd
module Godot
  class FuncGodotFGDFile < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `export_file` (Void)
    def export_file : String
      call_str("get", "export_file")
    end

    def export_file=(val) : Void
      call("set", "export_file", val)
    end

    # Property `Map Editor` (Void)
    def map_editor : String
      call_str("get", "Map Editor")
    end

    def map_editor=(val) : Void
      call("set", "Map Editor", val)
    end

    # Property `target_map_editor` (Godot::FuncGodotFGDFileFuncGodotTargetMapEditors?)
    def target_map_editor : Int64
      call_i64("get", "target_map_editor")
    end

    def target_map_editor=(val) : Void
      call("set", "target_map_editor", val)
    end

    # Property `FGD` (Void)
    def fgd : String
      call_str("get", "FGD")
    end

    def fgd=(val) : Void
      call("set", "FGD", val)
    end

    # Property `fgd_name` (String)
    def fgd_name : String
      call_str("get", "fgd_name")
    end

    def fgd_name=(val) : Void
      call("set", "fgd_name", val)
    end

    # Property `base_fgd_files` (Void)
    def base_fgd_files : String
      call_str("get", "base_fgd_files")
    end

    def base_fgd_files=(val) : Void
      call("set", "base_fgd_files", val)
    end

    # Property `entity_definitions` (Void)
    def entity_definitions : String
      call_str("get", "entity_definitions")
    end

    def entity_definitions=(val) : Void
      call("set", "entity_definitions", val)
    end

    # Property `generate_model_point_class_models` (Bool)
    def generate_model_point_class_models : Bool
      call_bool("get", "generate_model_point_class_models")
    end

    def generate_model_point_class_models=(val) : Void
      call("set", "generate_model_point_class_models", val)
    end

    # Method `export_button` -> Void
    def export_button : Void
      call("export_button")
      nil
    end

    # Method `do_export_file` -> Void
    def do_export_file(target_editor : Godot::FuncGodotFGDFileFuncGodotTargetMapEditors, fgd_output_folder : String) : Void
      call("do_export_file", target_editor, fgd_output_folder)
      nil
    end

    # Method `build_class_text` -> String
    def build_class_text(target_editor : Godot::FuncGodotFGDFileFuncGodotTargetMapEditors) : String
      call_str("build_class_text", target_editor)
    end

    # Method `get_fgd_classes` -> Void
    def get_fgd_classes : Void
      call("get_fgd_classes")
      nil
    end

    # Method `get_entity_definitions` -> Void
    def get_entity_definitions : Void
      call("get_entity_definitions")
      nil
    end

    # Method `_generate_base_class_list` -> Void
    def _generate_base_class_list(entity_def : Godot::Resource, visited_base_classes) : Void
      call("_generate_base_class_list", entity_def, visited_base_classes)
      nil
    end
  end
end

alias FuncGodotFGDFile = Godot::FuncGodotFGDFile
