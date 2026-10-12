@tool
class_name PalletteSwapScreenSpaceCanvas
extends CanvasLayer

## Screen-space post-processing CanvasLayer for 2D CanvasItem and HUD palette rendering.
## Automatically manages a full-screen ColorRect with mouse_filter set to IGNORE and ShaderMaterial.

const DEFAULT_SHADER_PATH: String = "res://shaders/palette_swap/palette_swap_canvas.gdshader"
const DEFAULT_MATERIAL_PATH: String = "res://shaders/palette_swap/palette_swap_canvas.material"
const FALLBACK_TEMPLATE_PATH: String = "res://addons/advanced_palette_swap/shaders/palette_swap_canvas.gdshader"

@export_file("*.material", "*.tres") var material_path: String = DEFAULT_MATERIAL_PATH:
	set(value):
		material_path = value
		setup_screenspace_canvas()

@export_file("*.gdshader") var shader_path: String = DEFAULT_SHADER_PATH:
	set(value):
		shader_path = value
		_update_material_shader(true)

@export var use_screen_texture: bool = true:
	set(value):
		use_screen_texture = value
		_update_param("use_screen_texture", use_screen_texture)

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
			setup_screenspace_canvas()

var _color_rect: ColorRect = null

func _ready() -> void:
	if layer == 1:
		# Elevate to layer 128 so it defaults to rendering over standard HUD canvas items
		layer = 128
	setup_screenspace_canvas()

## Returns the ColorRect responsible for screen-space canvas post-processing
func get_color_rect() -> ColorRect:
	if _color_rect and is_instance_valid(_color_rect):
		return _color_rect
	
	_color_rect = get_node_or_null("ScreenColorRect") as ColorRect
	if not _color_rect:
		for child in get_children():
			if child is ColorRect:
				_color_rect = child
				break
	return _color_rect

## Configures the full-screen ColorRect and ShaderMaterial
func setup_screenspace_canvas() -> void:
	var rect = get_color_rect()
	if not rect:
		rect = ColorRect.new()
		rect.name = "ScreenColorRect"
		add_child(rect)
		if Engine.is_editor_hint():
			rect.owner = self
		_color_rect = rect

	# Ensure it covers the full viewport and doesn't block UI input
	rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Try loading material from material_path if exists
	if not material_path.is_empty() and (FileAccess.file_exists(material_path) or ResourceLoader.exists(material_path)):
		var loaded_mat = ResourceLoader.load(material_path, "ShaderMaterial", ResourceLoader.CACHE_MODE_REPLACE) as ShaderMaterial
		if loaded_mat:
			rect.material = loaded_mat

	# Ensure ShaderMaterial is assigned
	var mat := rect.material as ShaderMaterial
	if mat == null:
		mat = ShaderMaterial.new()
		rect.material = mat

	_update_material_shader(true)
	_update_param("use_screen_texture", use_screen_texture)
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

	var p_use_screen = mat.get_shader_parameter("use_screen_texture")
	if p_use_screen != null: use_screen_texture = bool(p_use_screen)
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
	var rect = get_color_rect()
	if not rect:
		return
	var mat := rect.material as ShaderMaterial
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
	var rect = get_color_rect()
	if rect and rect.material is ShaderMaterial:
		(rect.material as ShaderMaterial).set_shader_parameter(param_name, value)
