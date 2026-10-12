# Generated strongly typed wrapper for GDScript node `FuncGodotPlugin`
# Script Path: res://addons/func_godot/src/func_godot_plugin.gd
module Godot
  class FuncGodotPlugin < Godot::EditorPlugin
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `map_import_plugin` (Godot::QuakeMapImportPlugin?)
    def map_import_plugin : Godot::QuakeMapImportPlugin?
      call_obj_as(Godot::QuakeMapImportPlugin, "get", "map_import_plugin")
    end

    def map_import_plugin=(val) : Void
      call("set", "map_import_plugin", val)
    end

    # Property `palette_import_plugin` (Godot::QuakePaletteImportPlugin?)
    def palette_import_plugin : Godot::QuakePaletteImportPlugin?
      call_obj_as(Godot::QuakePaletteImportPlugin, "get", "palette_import_plugin")
    end

    def palette_import_plugin=(val) : Void
      call("set", "palette_import_plugin", val)
    end

    # Property `wad_import_plugin` (Godot::QuakeWadImportPlugin?)
    def wad_import_plugin : Godot::QuakeWadImportPlugin?
      call_obj_as(Godot::QuakeWadImportPlugin, "get", "wad_import_plugin")
    end

    def wad_import_plugin=(val) : Void
      call("set", "wad_import_plugin", val)
    end

    # Property `edited_object_ref` (Godot::WeakRef?)
    def edited_object_ref : Godot::WeakRef?
      call_obj_as(Godot::WeakRef, "get", "edited_object_ref")
    end

    def edited_object_ref=(val) : Void
      call("set", "edited_object_ref", val)
    end

    # Method `_get_plugin_name` -> String
    def _get_plugin_name : String
      call_str("_get_plugin_name")
    end

    # Method `_handles` -> Bool
    def _handles(object : Godot::Object) : Bool
      call_bool("_handles", object)
    end

    # Method `_edit` -> Void
    def _edit(object : Godot::Object) : Void
      call("_edit", object)
      nil
    end

    # Method `_enter_tree` -> Void
    def _enter_tree : Void
      call("_enter_tree")
      nil
    end

    # Method `_exit_tree` -> Void
    def _exit_tree : Void
      call("_exit_tree")
      nil
    end

    # Method `func_godot_map_build_complete` -> Void
    def func_godot_map_build_complete(func_godot_map : Godot::FuncGodotMap) : Void
      call("func_godot_map_build_complete", func_godot_map)
      nil
    end
  end
end

alias FuncGodotPlugin = Godot::FuncGodotPlugin
