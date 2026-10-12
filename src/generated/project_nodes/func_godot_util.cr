# Generated strongly typed wrapper for GDScript node `FuncGodotUtil`
# Script Path: res://addons/func_godot/src/util/func_godot_util.gd
module Godot
  class FuncGodotUtil < Godot::RefCounted
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Method `print_profile_info` -> Void
    def print_profile_info(message : String, signature : String) : Void
      call("print_profile_info", message, signature)
      nil
    end

    # Method `newline` -> String
    def newline : String
      call_str("newline")
    end

    # Method `op_vec3_sum` -> Void
    def op_vec3_sum(lhs : Godot::Vector3, rhs : Godot::Vector3) : Void
      call("op_vec3_sum", lhs, rhs)
      nil
    end

    # Method `op_vec3_avg` -> Void
    def op_vec3_avg(array : Godot::Array) : Void
      call("op_vec3_avg", array)
      nil
    end

    # Method `id_to_opengl` -> Void
    def id_to_opengl(vec : Godot::Vector3) : Void
      call("id_to_opengl", vec)
      nil
    end

    # Method `is_point_in_convex_hull` -> Bool
    def is_point_in_convex_hull(planes : Godot::Array, vertex : Godot::Vector3) : Bool
      call_bool("is_point_in_convex_hull", planes, vertex)
    end

    # Method `elevate_quadratic` -> Void
    def elevate_quadratic(p0 : Godot::Vector3, p1 : Godot::Vector3, p2 : Godot::Vector3) : Void
      call("elevate_quadratic", p0, p1, p2)
      nil
    end

    # Method `create_curve` -> Godot::Curve3D?
    def create_curve(start : Godot::Vector3, control : Godot::Vector3, end_val : Godot::Vector3, bake_interval : Float64) : Godot::Curve3D?
      call_obj_as(Godot::Curve3D, "create_curve", start, control, end_val, bake_interval)
    end

    # Method `update_ref_curve` -> Void
    def update_ref_curve(curve : Godot::Curve3D, p0 : Godot::Vector3, p1 : Godot::Vector3, p2 : Godot::Vector3, bake_interval : Float64) : Void
      call("update_ref_curve", curve, p0, p1, p2, bake_interval)
      nil
    end

    # Method `load_texture` -> Godot::Texture2D?
    def load_texture(texture_name : String, wad_resources : Godot::Array, map_settings : Godot::FuncGodotMapSettings) : Godot::Texture2D?
      call_obj_as(Godot::Texture2D, "load_texture", texture_name, wad_resources, map_settings)
    end

    # Method `is_skip` -> Bool
    def is_skip(texture : String, map_settings : Godot::FuncGodotMapSettings) : Bool
      call_bool("is_skip", texture, map_settings)
    end

    # Method `is_clip` -> Bool
    def is_clip(texture : String, map_settings : Godot::FuncGodotMapSettings) : Bool
      call_bool("is_clip", texture, map_settings)
    end

    # Method `is_origin` -> Bool
    def is_origin(texture : String, map_settings : Godot::FuncGodotMapSettings) : Bool
      call_bool("is_origin", texture, map_settings)
    end

    # Method `filter_face` -> Bool
    def filter_face(texture : String, map_settings : Godot::FuncGodotMapSettings) : Bool
      call_bool("filter_face", texture, map_settings)
    end

    # Method `build_base_material` -> Void
    def build_base_material(map_settings : Godot::FuncGodotMapSettings, material : Godot::BaseMaterial3D, texture : String) : Void
      call("build_base_material", map_settings, material, texture)
      nil
    end

    # Method `build_texture_map` -> Void
    def build_texture_map(entity_data : Godot::Array, map_settings : Godot::FuncGodotMapSettings) : Void
      call("build_texture_map", entity_data, map_settings)
      nil
    end

    # Method `get_valve_uv` -> Void
    def get_valve_uv(vertex : Godot::Vector3, u_axis : Godot::Vector3, v_axis : Godot::Vector3, uv_basis : Godot::Transform2D, texture_size : Godot::Vector2) : Void
      call("get_valve_uv", vertex, u_axis, v_axis, uv_basis, texture_size)
      nil
    end

    # Method `get_quake_uv` -> Void
    def get_quake_uv(vertex : Godot::Vector3, normal : Godot::Vector3, uv_in : Godot::Transform2D, texture_size : Godot::Vector2) : Void
      call("get_quake_uv", vertex, normal, uv_in, texture_size)
      nil
    end

    # Method `get_face_vertex_uv` -> Void
    def get_face_vertex_uv(vertex : Godot::Vector3, face : Godot::RefCounted, texture_size : Godot::Vector2) : Void
      call("get_face_vertex_uv", vertex, face, texture_size)
      nil
    end

    # Method `get_valve_tangent` -> Void
    def get_valve_tangent(u : Godot::Vector3, v : Godot::Vector3, normal : Godot::Vector3) : Void
      call("get_valve_tangent", u, v, normal)
      nil
    end

    # Method `get_quake_tangent` -> Void
    def get_quake_tangent(normal : Godot::Vector3, uv_y_scale : Float64, uv_rotation : Float64) : Void
      call("get_quake_tangent", normal, uv_y_scale, uv_rotation)
      nil
    end

    # Method `get_face_tangent` -> Void
    def get_face_tangent(face : Godot::RefCounted) : Void
      call("get_face_tangent", face)
      nil
    end

    # Method `smooth_mesh_by_angle` -> Godot::ArrayMesh?
    def smooth_mesh_by_angle(mesh : Godot::ArrayMesh, angle_deg : Float64) : Godot::ArrayMesh?
      call_obj_as(Godot::ArrayMesh, "smooth_mesh_by_angle", mesh, angle_deg)
    end
  end
end

alias FuncGodotUtil = Godot::FuncGodotUtil
