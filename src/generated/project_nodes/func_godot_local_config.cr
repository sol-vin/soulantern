# Generated strongly typed wrapper for GDScript node `FuncGodotLocalConfig`
# Script Path: res://addons/func_godot/src/util/func_godot_local_config.gd
module Godot
  class FuncGodotLocalConfig < Godot::Resource
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `_save_settings` (Void)
    def _save_settings : String
      call_str("get", "_save_settings")
    end

    def _save_settings=(val) : Void
      call("set", "_save_settings", val)
    end

    # Property `_load_settings` (Void)
    def _load_settings : String
      call_str("get", "_load_settings")
    end

    def _load_settings=(val) : Void
      call("set", "_load_settings", val)
    end

    # Property `_settings_dict` (Void)
    def _settings_dict : String
      call_str("get", "_settings_dict")
    end

    def _settings_dict=(val) : Void
      call("set", "_settings_dict", val)
    end

    # Property `_loaded` (Bool)
    def _loaded : Bool
      call_bool("get", "_loaded")
    end

    def _loaded=(val) : Void
      call("set", "_loaded", val)
    end

    # Method `get_setting` -> Void
    def get_setting(name : Godot::FuncGodotLocalConfigPROPERTY) : Void
      call("get_setting", name)
      nil
    end

    # Method `_get_property_list` -> Void
    def _get_property_list : Void
      call("_get_property_list")
      nil
    end

    # Method `_get` -> Void
    def _get(property : String) : Void
      call("_get", property)
      nil
    end

    # Method `_set` -> Bool
    def _set(property : String, value) : Bool
      call_bool("_set", property, value)
    end

    # Method `_get_default_value` -> Void
    def _get_default_value(type_id) : Void
      call("_get_default_value", type_id)
      nil
    end

    # Method `_get_config_property` -> Void
    def _get_config_property(name : String) : Void
      call("_get_config_property", name)
      nil
    end

    # Method `reload_func_godot_settings` -> Void
    def reload_func_godot_settings : Void
      call("reload_func_godot_settings")
      nil
    end

    # Method `_apply_defaults` -> Void
    def _apply_defaults : Void
      call("_apply_defaults")
      nil
    end

    # Method `_try_loading` -> Void
    def _try_loading : Void
      call("_try_loading")
      nil
    end

    # Method `export_func_godot_settings` -> Void
    def export_func_godot_settings : Void
      call("export_func_godot_settings")
      nil
    end
  end
end

alias FuncGodotLocalConfig = Godot::FuncGodotLocalConfig
