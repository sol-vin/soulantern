@tool
class_name PalletteSwapScreenSpaceMesh
extends MeshInstance3D

## Screen-space post-processing MeshInstance3D for limited palette rendering.
## Automatically sets up a full-screen QuadMesh and ShaderMaterial on ready.

const DEFAULT_SHADER_PATH: String = "res://shaders/palette_swap/palette_swap.gdshader"
const DEFAULT_MATERIAL_PATH: String = "res://shaders/palette_swap/palette_swap.material"
const FALLBACK_TEMPLATE_PATH: String = "res://addons/advanced_palette_swap/shaders/palette_swap.gdshader"

@export_file("*.material", "*.tres") var material_path: String = DEFAULT_MATERIAL_PATH:
	set(value):
		material_path = value
		setup_screenspace_mesh()

@export_file("*.gdshader") var shader_path: String = DEFAULT_SHADER_PATH:
	set(value):
		shader_path = value
		_update_material_shader(true)

@export_range(0.0, 1.0, 0.01) var dither_strength: float = 0.0:
	set(value):
		dither_strength = value
		_update_param("dither_strength", dither_strength)

@export_enum("Perceptual OKLab:0", "Perceptual Redmean:1", "Euclidean sRGB:2", "Chromaticity (Ignore Lightness):3", "Hue Angle Only:4", "Hue Priority (Chroma-Weighted):5", "Luminance Only (Value Ramp):6", "Chroma Only:7", "Color Warmth (Cool vs Warm):8", "HSV Cylindrical:9", "HSV Hue Only:10") var color_distance_mode: int = 0:
	set(value):
		color_distance_mode = value
		_update_param("color_distance_mode", color_distance_mode)

@export_group("Input Adjustments")
@export_range(-1.0, 1.0, 0.01) var input_lightness: float = 0.0:
	set(value):
		input_lightness = value
		_update_param("input_lightness", input_lightness)

@export_range(0.0, 3.0, 0.01) var input_saturation: float = 1.0:
	set(value):
		input_saturation = value
		_update_param("input_saturation", input_saturation)

@export_range(0.0, 3.0, 0.01) var input_contrast: float = 1.0:
	set(value):
		input_contrast = value
		_update_param("input_contrast", input_contrast)

@export_subgroup("Color Channels")
@export_range(0.0, 2.0, 0.01) var input_red: float = 1.0:
	set(value):
		input_red = value
		_update_param("input_red", input_red)

@export_range(0.0, 2.0, 0.01) var input_green: float = 1.0:
	set(value):
		input_green = value
		_update_param("input_green", input_green)

@export_range(0.0, 2.0, 0.01) var input_blue: float = 1.0:
	set(value):
		input_blue = value
		_update_param("input_blue", input_blue)

@export_group("")
@export var reapply_setup: bool = false:
	set(value):
		if value:
			setup_screenspace_mesh()

func _ready() -> void:
	setup_screenspace_mesh()

## Configures the QuadMesh and ShaderMaterial
func setup_screenspace_mesh() -> void:
	# Configure QuadMesh
	if not (mesh is QuadMesh):
		var quad := QuadMesh.new()
		quad.size = Vector2(2.0, 2.0)
		mesh = quad
	else:
		var quad := mesh as QuadMesh
		if quad.size != Vector2(2.0, 2.0):
			quad.size = Vector2(2.0, 2.0)

	# Prevent frustum culling regardless of camera direction
	extra_cull_margin = 16384.0

	# Try loading material from material_path if exists
	if not material_path.is_empty() and (FileAccess.file_exists(material_path) or ResourceLoader.exists(material_path)):
		var loaded_mat = ResourceLoader.load(material_path, "ShaderMaterial", ResourceLoader.CACHE_MODE_REPLACE) as ShaderMaterial
		if loaded_mat:
			material_override = loaded_mat

	# Ensure ShaderMaterial is assigned
	var mat := material_override as ShaderMaterial
	if mat == null:
		mat = ShaderMaterial.new()
		material_override = mat

	_update_material_shader(true)
	_update_param("dither_strength", dither_strength)
	_update_param("color_distance_mode", color_distance_mode)
	_update_param("input_lightness", input_lightness)
	_update_param("input_saturation", input_saturation)
	_update_param("input_contrast", input_contrast)
	_update_param("input_red", input_red)
	_update_param("input_green", input_green)
	_update_param("input_blue", input_blue)

## Reads shader parameters from the material file into this node's properties
func sync_from_material_file() -> void:
	if material_path.is_empty() or (not FileAccess.file_exists(material_path) and not ResourceLoader.exists(material_path)):
		return

	var mat := ResourceLoader.load(material_path, "ShaderMaterial", ResourceLoader.CACHE_MODE_REPLACE) as ShaderMaterial
	if not mat:
		return

	var p_dither = mat.get_shader_parameter("dither_strength")
	if p_dither != null: dither_strength = float(p_dither)
	var p_mode = mat.get_shader_parameter("color_distance_mode")
	if p_mode != null: color_distance_mode = int(p_mode)
	var p_light = mat.get_shader_parameter("input_lightness")
	if p_light != null: input_lightness = float(p_light)
	var p_sat = mat.get_shader_parameter("input_saturation")
	if p_sat != null: input_saturation = float(p_sat)
	var p_con = mat.get_shader_parameter("input_contrast")
	if p_con != null: input_contrast = float(p_con)
	var p_r = mat.get_shader_parameter("input_red")
	if p_r != null: input_red = float(p_r)
	var p_g = mat.get_shader_parameter("input_green")
	if p_g != null: input_green = float(p_g)
	var p_b = mat.get_shader_parameter("input_blue")
	if p_b != null: input_blue = float(p_b)

func _update_material_shader(force_reload: bool = false) -> void:
	var mat := material_override as ShaderMaterial
	if not mat:
		return

	var target_path = shader_path
	if not ResourceLoader.exists(target_path):
		target_path = FALLBACK_TEMPLATE_PATH

	if ResourceLoader.exists(target_path):
		var cache_mode = ResourceLoader.CACHE_MODE_REPLACE if force_reload else ResourceLoader.CACHE_MODE_REUSE
		var shader_res = ResourceLoader.load(target_path, "", cache_mode) as Shader
		mat.shader = shader_res

func _update_param(param_name: StringName, value: Variant) -> void:
	var mat := material_override as ShaderMaterial
	if mat:
		mat.set_shader_parameter(param_name, value)
