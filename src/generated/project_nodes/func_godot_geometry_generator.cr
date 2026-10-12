# Generated strongly typed wrapper for GDScript node `FuncGodotGeometryGenerator`
# Script Path: res://addons/func_godot/src/core/geometry_generator.gd
module Godot
  class FuncGodotGeometryGenerator < Godot::RefCounted
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `map_settings` (Godot::FuncGodotMapSettings?)
    def map_settings : Godot::FuncGodotMapSettings?
      call_obj_as(Godot::FuncGodotMapSettings, "get", "map_settings")
    end

    def map_settings=(val) : Void
      call("set", "map_settings", val)
    end

    # Property `hyperplane_size` (Float64)
    def hyperplane_size : Float64
      call_f64("get", "hyperplane_size")
    end

    def hyperplane_size=(val) : Void
      call("set", "hyperplane_size", val)
    end

    # Property `entity_data` (Void)
    def entity_data : String
      call_str("get", "entity_data")
    end

    def entity_data=(val) : Void
      call("set", "entity_data", val)
    end

    # Property `texture_materials` (Void)
    def texture_materials : String
      call_str("get", "texture_materials")
    end

    def texture_materials=(val) : Void
      call("set", "texture_materials", val)
    end

    # Property `texture_sizes` (Void)
    def texture_sizes : String
      call_str("get", "texture_sizes")
    end

    def texture_sizes=(val) : Void
      call("set", "texture_sizes", val)
    end

    # Method `_init` -> Void
    def _init(settings : Godot::FuncGodotMapSettings, hplane_size : Float64) : Void
      call("_init", settings, hplane_size)
      nil
    end

    # Method `is_skip` -> Bool
    def is_skip(face : Godot::RefCounted) : Bool
      call_bool("is_skip", face)
    end

    # Method `is_clip` -> Bool
    def is_clip(face : Godot::RefCounted) : Bool
      call_bool("is_clip", face)
    end

    # Method `is_origin` -> Bool
    def is_origin(face : Godot::RefCounted) : Bool
      call_bool("is_origin", face)
    end

    # Method `sample_bezier_curve` -> Void
    def sample_bezier_curve(controls : Godot::Array, t : Float64) : Void
      call("sample_bezier_curve", controls, t)
      nil
    end

    # Method `sample_bezier_surface` -> Void
    def sample_bezier_surface(controls : Godot::Array, width : Int64, height : Int64, u : Float64, v : Float64) : Void
      call("sample_bezier_surface", controls, width, height, u, v)
      nil
    end

    # Method `get_triangle_indices` -> Void
    def get_triangle_indices(width : Int64, height : Int64) : Void
      call("get_triangle_indices", width, height)
      nil
    end

    # Method `create_patch_mesh` -> Void
    def create_patch_mesh(data : Godot::Array, mesh : Godot::Mesh) : Void
      call("create_patch_mesh", data, mesh)
      nil
    end

    # Method `generate_base_winding` -> Void
    def generate_base_winding(plane : Godot::Plane) : Void
      call("generate_base_winding", plane)
      nil
    end

    # Method `generate_face_vertices` -> Void
    def generate_face_vertices(brush : Godot::RefCounted, face_index : Int64, vertex_merge_distance : Float64) : Void
      call("generate_face_vertices", brush, face_index, vertex_merge_distance)
      nil
    end

    # Method `generate_brush_vertices` -> Void
    def generate_brush_vertices(entity_index : Int64, brush_index : Int64) : Void
      call("generate_brush_vertices", entity_index, brush_index)
      nil
    end

    # Method `generate_entity_vertices` -> Void
    def generate_entity_vertices(entity_index : Int64) : Void
      call("generate_entity_vertices", entity_index)
      nil
    end

    # Method `determine_entity_origins` -> Void
    def determine_entity_origins(entity_index : Int64) : Void
      call("determine_entity_origins", entity_index)
      nil
    end

    # Method `wind_entity_faces` -> Void
    def wind_entity_faces(entity_index : Int64) : Void
      call("wind_entity_faces", entity_index)
      nil
    end

    # Method `smooth_entity_vertices` -> Void
    def smooth_entity_vertices(entity_index : Int64) : Void
      call("smooth_entity_vertices", entity_index)
      nil
    end

    # Method `generate_entity_surfaces` -> Void
    def generate_entity_surfaces(entity_index : Int64) : Void
      call("generate_entity_surfaces", entity_index)
      nil
    end

    # Method `unwrap_uv2s` -> Void
    def unwrap_uv2s(entity_index : Int64, texel_size : Float64) : Void
      call("unwrap_uv2s", entity_index, texel_size)
      nil
    end

    # Method `build` -> Godot::Error?
    def build(build_flags : Int64, entities : Godot::Array) : Godot::Error?
      call_i64("build", build_flags, entities)
    end

    # Bound Signal `declare_step`
    def declare_step : Godot::BoundSignal
      signal("declare_step")
    end
  end
end

alias FuncGodotGeometryGenerator = Godot::FuncGodotGeometryGenerator
