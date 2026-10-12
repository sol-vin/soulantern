require "lapis"

module Godot
  class Object
    def null? : Bool
      pointer.null?
    end
  end

  class SceneTree
    def get_root? : Window?
      r = get_root
      r.pointer.null? ? nil : r
    end

    def get_first_node_in_group?(group : String) : Node?
      node = get_first_node_in_group(group)
      node.pointer.null? ? nil : node
    end
  end

  class Node
    def get_viewport? : Viewport?
      vp = get_viewport
      vp.pointer.null? ? nil : vp
    end

    def get_parent? : Node?
      p = get_parent
      p.pointer.null? ? nil : p
    end

    def process_mode=(mode : ProcessMode)
      set_process_mode(mode)
    end
  end

  class Control
    def mouse_filter=(filter : MouseFilter)
      set_mouse_filter(filter)
    end

    def anchors_preset=(preset : LayoutPreset | Int)
      set_anchors_preset(preset)
    end
  end

  class Viewport
    def size : Vector2
      get_visible_rect.size
    end
  end

  class Engine
    def self.is_editor_hint : Bool
      instance.is_editor_hint
    end

    def self.is_editor_hint? : Bool
      instance.is_editor_hint?
    end
  end

  class Time
    def self.get_ticks_msec : Int64
      instance.get_ticks_msec
    end
  end

  class ResourceLoader
    def self.exists(path : String, type_hint : String = "") : Bool
      instance.exists(path, type_hint)
    end

    def self.exists?(path : String, type_hint : String = "") : Bool
      instance.exists?(path, type_hint)
    end

    def self.load(path : String, type_hint : String = "", cache_mode : CacheMode | Int = 1) : Resource
      instance.load(path, type_hint, cache_mode)
    end
  end

  class AudioServer
    def self.get_bus_index(bus_name : String) : Int32
      instance.get_bus_index(bus_name).to_i32
    end

    def self.is_bus_mute(bus_index : Int32 | Int64) : Bool
      instance.is_bus_mute(bus_index.to_i64)
    end

    def self.set_bus_mute(bus_index : Int32 | Int64, enable : Bool) : Void
      instance.set_bus_mute(bus_index.to_i64, enable)
    end

    def self.get_bus_volume_db(bus_index : Int32 | Int64) : Float32
      instance.get_bus_volume_db(bus_index.to_i64).to_f32
    end

    def self.set_bus_volume_db(bus_index : Int32 | Int64, volume_db : Float32 | Float64) : Void
      instance.set_bus_volume_db(bus_index.to_i64, volume_db.to_f64)
    end

    def self.get_master_volume : Float32
      idx = get_bus_index("Master")
      return 1.0_f32 if idx < 0
      return 0.0_f32 if is_bus_mute(idx)
      Math.exp(get_bus_volume_db(idx) * 0.11512925464970228_f32).to_f32
    end

    def self.set_master_volume(linear_val : Float32) : Void
      idx = get_bus_index("Master")
      return if idx < 0
      val = Math.max(0.0_f32, Math.min(1.0_f32, linear_val))
      if val <= 0.001_f32
        set_bus_mute(idx, true)
      else
        set_bus_mute(idx, false)
        db = val > 0.0_f32 ? (Math.log(val) * 8.685889638065037_f32).to_f32 : -80.0_f32
        set_bus_volume_db(idx, db)
      end
    end
  end

  class Input
    def self.is_action_pressed(action : String, exact_match : Bool = false) : Bool
      instance.is_action_pressed(action, exact_match)
    end

    def self.is_action_pressed?(action : String, exact_match : Bool = false) : Bool
      instance.is_action_pressed(action, exact_match)
    end

    def self.is_action_just_pressed(action : String, exact_match : Bool = false) : Bool
      instance.is_action_just_pressed(action, exact_match)
    end

    def self.is_action_just_pressed?(action : String, exact_match : Bool = false) : Bool
      instance.is_action_just_pressed(action, exact_match)
    end

    def self.is_action_just_released(action : String, exact_match : Bool = false) : Bool
      instance.is_action_just_released(action, exact_match)
    end

    def self.is_action_just_released?(action : String, exact_match : Bool = false) : Bool
      instance.is_action_just_released(action, exact_match)
    end

    def self.get_axis(negative_action : String, positive_action : String) : Float32
      instance.get_axis(negative_action, positive_action).to_f32
    end

    def self.get_action_strength(action : String, exact_match : Bool = false) : Float32
      instance.get_action_strength(action, exact_match).to_f32
    end

    def self.mouse_mode : MouseMode
      instance.get_mouse_mode
    end

    def self.mouse_mode=(mode : MouseMode | Int) : Void
      instance.set_mouse_mode(mode)
    end
  end

  class OS
    def self.shell_open(uri : String) : Error
      instance.shell_open(uri)
    end
  end
end
