@tool
class_name PaletteEditorTab
extends Control

## Streamlined editor interface for Advanced Palette Swap.
## Primary workflow centered on an interactive drag-and-drop Color Spectrum Chart
## with right-click context menu (Change Color, Insert Ahead, Insert Behind, Delete).

const PalettePresets = preload("res://addons/advanced_palette_swap/core/palette_presets.gd")
const PaletteGenerator = preload("res://addons/advanced_palette_swap/core/palette_generator.gd")
const PaletteResource = preload("res://addons/advanced_palette_swap/core/color_palette.gd")
const PaletteImporter = preload("res://addons/advanced_palette_swap/core/palette_importer.gd")
const ScreenSpaceCanvas = preload("res://addons/advanced_palette_swap/nodes/palette_swap_screen_space_canvas.gd")

var current_colors: Array[Color] = []
var _plugin: EditorPlugin = null

# UI References
var _main_scroll: ScrollContainer
var _color_filter_option: OptionButton
var _selected_color_count_filter: int = -1
var _all_palettes: Array[Dictionary] = []
var _preset_option: OptionButton
var _preset_items: Array[Dictionary] = []
var _output_dir_edit: LineEdit
var _status_label: Label
var _count_label: Label
var _spectrum_container: HBoxContainer
var _spectrum_scroll: ScrollContainer

# Input Pre-processing Adjustment Values
var input_lightness: float = 0.0
var input_saturation: float = 1.0
var input_contrast: float = 1.0
var input_red: float = 1.0
var input_green: float = 1.0
var input_blue: float = 1.0

const DISTANCE_MODE_NAMES: Array[String] = [
	"Perceptual OKLab",
	"Perceptual Redmean",
	"Euclidean sRGB",
	"Chromaticity (Ignore Lightness)",
	"Hue Angle Only",
	"Hue Priority (Chroma-Weighted)",
	"Luminance Only (Value Ramp)",
	"Chroma Only",
	"Color Warmth (Cool vs Warm)",
	"HSV Cylindrical",
	"HSV Hue Only"
]

var color_distance_mode: int = 0:
	set(value):
		color_distance_mode = clampi(value, 0, DISTANCE_MODE_NAMES.size() - 1)
		if _distance_mode_option and _distance_mode_option.selected != color_distance_mode:
			_distance_mode_option.selected = color_distance_mode

var _distance_mode_option: OptionButton

# Input Adjustment UI References
var _adjustments_panel: PanelContainer
var _adjustments_content: VBoxContainer
var _adjustments_toggle_btn: Button
var _adjustments_summary_lbl: Label

var _lightness_slider: HSlider
var _lightness_spin: SpinBox
var _saturation_slider: HSlider
var _saturation_spin: SpinBox
var _contrast_slider: HSlider
var _contrast_spin: SpinBox

var _red_slider: HSlider
var _red_spin: SpinBox
var _green_slider: HSlider
var _green_spin: SpinBox
var _blue_slider: HSlider
var _blue_spin: SpinBox

# Context Menu and Popups
var _context_menu: PopupMenu
var _context_menu_index: int = -1
var _last_click_pos: Vector2 = Vector2.ZERO

var _picker_popup: PopupPanel
var _popup_color_picker: ColorPicker
var _picker_title_lbl: Label
var _active_color_index: int = -1

var _file_dialog: FileDialog
var _save_dialog: FileDialog
var _is_exporting: bool = false

# Importer Dialog UI References
var _importer_dialog: AcceptDialog
var _single_import_path_edit: LineEdit
var _single_file_picker: FileDialog
var _single_skip_trans_cb: CheckBox
var _single_preview_lbl: Label
var _single_preview_container: HBoxContainer
var _single_loaded_palette: PaletteResource = null

var _batch_src_edit: LineEdit
var _batch_dest_edit: LineEdit
var _batch_dir_picker: FileDialog
var _batch_dest_picker: FileDialog
var _batch_recursive_cb: CheckBox
var _batch_skip_trans_cb: CheckBox
var _batch_log_edit: TextEdit

# Array of instantiated SpectrumSwatchControl nodes
var _swatch_nodes: Array[SpectrumSwatchControl] = []

# --- Inner Class: Individual Draggable Color Spectrum Swatch ---
class SpectrumSwatchControl extends PanelContainer:
	var index: int = 0
	var color: Color = Color.BLACK
	var parent_tab: PaletteEditorTab = null

	var _color_rect: ColorRect
	var _index_label: Label
	var _hex_label: Label
	var _drop_indicator_left: ColorRect
	var _drop_indicator_right: ColorRect
	var _highlight_border: ReferenceRect
	var _drag_started: bool = false
	var _mouse_pressed: bool = false
	var _press_pos: Vector2 = Vector2.ZERO

	func _init(idx: int, col: Color, tab: PaletteEditorTab) -> void:
		index = idx
		color = col
		parent_tab = tab

		custom_minimum_size = Vector2(70, 200)
		size_flags_horizontal = Control.SIZE_EXPAND_FILL
		size_flags_vertical = Control.SIZE_EXPAND_FILL
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

		_build_swatch()

	func _build_swatch() -> void:
		# Background Color Rect
		_color_rect = ColorRect.new()
		_color_rect.color = color
		_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_color_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(_color_rect)

		# Overlay Margin
		var margin = MarginContainer.new()
		margin.mouse_filter = Control.MOUSE_FILTER_IGNORE
		margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		margin.add_theme_constant_override("margin_left", 6)
		margin.add_theme_constant_override("margin_top", 8)
		margin.add_theme_constant_override("margin_right", 6)
		margin.add_theme_constant_override("margin_bottom", 8)
		add_child(margin)

		var vbox = VBoxContainer.new()
		vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		margin.add_child(vbox)

		# Top: Index Pill Badge
		var top_panel = PanelContainer.new()
		top_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		top_panel.modulate = Color(1.0, 1.0, 1.0, 0.88)
		_index_label = Label.new()
		_index_label.text = "#%02d" % (index + 1)
		_index_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_index_label.add_theme_font_size_override("font_size", 12)
		top_panel.add_child(_index_label)
		vbox.add_child(top_panel)

		vbox.add_spacer(false)

		# Center: Drag icon hint
		var hint_lbl = Label.new()
		hint_lbl.text = "⠿"
		hint_lbl.modulate = Color(1.0, 1.0, 1.0, 0.45)
		hint_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hint_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vbox.add_child(hint_lbl)

		vbox.add_spacer(false)

		# Bottom: Hex Label Pill Badge
		var bottom_panel = PanelContainer.new()
		bottom_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bottom_panel.modulate = Color(1.0, 1.0, 1.0, 0.88)
		_hex_label = Label.new()
		_hex_label.text = "#" + color.to_html(false).to_lower()
		_hex_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		_hex_label.add_theme_font_size_override("font_size", 11)
		bottom_panel.add_child(_hex_label)
		vbox.add_child(bottom_panel)

		# Drop Indicator Lines (Left & Right)
		_drop_indicator_left = ColorRect.new()
		_drop_indicator_left.color = Color(0.2, 0.9, 1.0, 0.9)
		_drop_indicator_left.custom_minimum_size = Vector2(4, 0)
		_drop_indicator_left.set_anchors_and_offsets_preset(Control.PRESET_LEFT_WIDE)
		_drop_indicator_left.visible = false
		_drop_indicator_left.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(_drop_indicator_left)

		_drop_indicator_right = ColorRect.new()
		_drop_indicator_right.color = Color(0.2, 0.9, 1.0, 0.9)
		_drop_indicator_right.custom_minimum_size = Vector2(4, 0)
		_drop_indicator_right.set_anchors_and_offsets_preset(Control.PRESET_RIGHT_WIDE)
		_drop_indicator_right.visible = false
		_drop_indicator_right.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(_drop_indicator_right)

		# Tooltip
		tooltip_text = "Color #%02d (#%s)\n• Left-click: Change Color\n• Right-click: Context Menu\n• Drag & Drop: Reorder" % [
			index + 1, color.to_html(false).to_lower()
		]

		mouse_exited.connect(_on_mouse_exited)

	func update_color(new_col: Color) -> void:
		color = new_col
		if _color_rect:
			_color_rect.color = new_col
		if _hex_label:
			_hex_label.text = "#" + new_col.to_html(false).to_lower()
		tooltip_text = "Color #%02d (#%s)\n• Left-click: Change Color\n• Right-click: Context Menu\n• Drag & Drop: Reorder" % [
			index + 1, new_col.to_html(false).to_lower()
		]

	func _on_mouse_exited() -> void:
		_drop_indicator_left.visible = false
		_drop_indicator_right.visible = false

	# --- Drag and Drop Implementation ---
	func _get_drag_data(_at_position: Vector2) -> Variant:
		_drag_started = true
		_mouse_pressed = false

		var preview = PanelContainer.new()
		preview.custom_minimum_size = Vector2(80, 80)

		var preview_rect = ColorRect.new()
		preview_rect.color = color
		preview_rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		preview.add_child(preview_rect)

		var preview_lbl = Label.new()
		preview_lbl.text = "#%02d\n#%s" % [index + 1, color.to_html(false).to_lower()]
		preview_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		preview_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		preview_lbl.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		preview.add_child(preview_lbl)

		if is_inside_tree():
			set_drag_preview(preview)

		return {
			"type": "palette_color",
			"from_index": index,
			"color": color
		}

	func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
		if data is Dictionary and data.get("type") == "palette_color":
			var is_right = at_position.x > size.x * 0.5
			_drop_indicator_left.visible = not is_right
			_drop_indicator_right.visible = is_right
			return true
		_drop_indicator_left.visible = false
		_drop_indicator_right.visible = false
		return false

	func _drop_data(at_position: Vector2, data: Variant) -> void:
		_drop_indicator_left.visible = false
		_drop_indicator_right.visible = false
		_drag_started = false
		_mouse_pressed = false
		if data is Dictionary and data.get("type") == "palette_color":
			var from_idx: int = data.get("from_index", -1)
			var insert_after: bool = at_position.x > size.x * 0.5
			parent_tab.move_color(from_idx, index, insert_after)

	# --- Mouse Click Inputs ---
	func _gui_input(event: InputEvent) -> void:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				accept_event()
				parent_tab.open_context_menu(index, event.global_position)
			elif event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					_mouse_pressed = true
					_drag_started = false
					_press_pos = event.position
					# Do not accept_event() or open popup on press, allowing Godot to detect drag motion!
				else:
					# Mouse button released
					if _mouse_pressed and not _drag_started:
						_mouse_pressed = false
						# Only open color picker if the mouse didn't drag
						if event.position.distance_to(_press_pos) < 6.0:
							accept_event()
							parent_tab.open_color_picker_popup(index, event.global_position)
					_mouse_pressed = false
					_drag_started = false


# --- PaletteEditorTab Implementation ---

func _init() -> void:
	size_flags_horizontal = Control.SIZE_EXPAND_FILL
	size_flags_vertical = Control.SIZE_EXPAND_FILL

func _ready() -> void:
	_build_ui()
	_setup_popups()
	_setup_importer_dialog()
	_refresh_preset_list()
	_load_preset("Game Boy (DMG)")
	_sync_adjustments_from_scene()

func set_editor_plugin(plugin: EditorPlugin) -> void:
	_plugin = plugin

func _build_ui() -> void:
	for child in get_children():
		child.queue_free()

	# Root vertical & horizontal scroll container for full plugin scrolling
	_main_scroll = ScrollContainer.new()
	_main_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_main_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_main_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	_main_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	_main_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_main_scroll)

	var root_margin = MarginContainer.new()
	root_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_margin.add_theme_constant_override("margin_left", 16)
	root_margin.add_theme_constant_override("margin_top", 14)
	root_margin.add_theme_constant_override("margin_right", 16)
	root_margin.add_theme_constant_override("margin_bottom", 14)
	_main_scroll.add_child(root_margin)

	var main_vbox = VBoxContainer.new()
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_theme_constant_override("separation", 10)
	root_margin.add_child(main_vbox)

	# --- 1. Top Header Bar ---
	var header_panel = PanelContainer.new()
	var header_margin = MarginContainer.new()
	header_margin.add_theme_constant_override("margin_left", 14)
	header_margin.add_theme_constant_override("margin_top", 10)
	header_margin.add_theme_constant_override("margin_right", 14)
	header_margin.add_theme_constant_override("margin_bottom", 10)
	header_panel.add_child(header_margin)

	var header_flow = HFlowContainer.new()
	header_flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_flow.add_theme_constant_override("h_separation", 16)
	header_flow.add_theme_constant_override("v_separation", 10)
	header_margin.add_child(header_flow)

	var title_vbox = VBoxContainer.new()
	title_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var title_lbl = Label.new()
	title_lbl.text = "Advanced Palette Swap"
	title_lbl.add_theme_font_size_override("font_size", 18)
	var subtitle_lbl = Label.new()
	subtitle_lbl.text = "Screen-space palette limiting & code generator"
	subtitle_lbl.modulate = Color(0.7, 0.7, 0.7)
	title_vbox.add_child(title_lbl)
	title_vbox.add_child(subtitle_lbl)
	header_flow.add_child(title_vbox)

	# Target folder and primary actions
	var gen_vbox = VBoxContainer.new()
	gen_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	gen_vbox.add_theme_constant_override("separation", 6)

	var dir_flow = HFlowContainer.new()
	dir_flow.add_theme_constant_override("h_separation", 8)
	dir_flow.add_theme_constant_override("v_separation", 4)
	dir_flow.alignment = FlowContainer.ALIGNMENT_END

	var dir_lbl = Label.new()
	dir_lbl.text = "Target Directory:"
	dir_flow.add_child(dir_lbl)

	_output_dir_edit = LineEdit.new()
	_output_dir_edit.text = "res://shaders/palette_swap"
	_output_dir_edit.custom_minimum_size = Vector2(240, 0)
	dir_flow.add_child(_output_dir_edit)
	gen_vbox.add_child(dir_flow)

	var action_flow = HFlowContainer.new()
	action_flow.add_theme_constant_override("h_separation", 8)
	action_flow.add_theme_constant_override("v_separation", 6)
	action_flow.alignment = FlowContainer.ALIGNMENT_END

	var mode_flow = HBoxContainer.new()
	mode_flow.add_theme_constant_override("separation", 4)
	var mode_lbl = Label.new()
	mode_lbl.text = "Matching Mode:"
	mode_lbl.tooltip_text = "Color matching distance mode used to map scene colors to palette entries."
	mode_flow.add_child(mode_lbl)

	_distance_mode_option = OptionButton.new()
	_distance_mode_option.tooltip_text = "Select color matching algorithm (Perceptual OKLab, Chromaticity, Hue Angle, Hue Priority, Luminance Ramp, etc.)."
	for i in range(DISTANCE_MODE_NAMES.size()):
		_distance_mode_option.add_item(DISTANCE_MODE_NAMES[i], i)
	_distance_mode_option.selected = color_distance_mode
	_distance_mode_option.item_selected.connect(func(idx: int):
		color_distance_mode = idx
	)
	mode_flow.add_child(_distance_mode_option)
	action_flow.add_child(mode_flow)

	var generate_btn = Button.new()
	generate_btn.text = "⚡ Apply & Generate (Shader & Material)"
	generate_btn.tooltip_text = "Generates palette.gdshaderinc, palette_swap.gdshader, and palette_swap.material, and hooks into scene meshes."
	generate_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	generate_btn.pressed.connect(_on_generate_pressed)
	action_flow.add_child(generate_btn)

	var sync_mat_btn = Button.new()
	sync_mat_btn.text = "🔄 Sync from Material"
	sync_mat_btn.tooltip_text = "Reloads shader parameters and input adjustments from palette_swap.material on disk."
	sync_mat_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	sync_mat_btn.pressed.connect(func(): _sync_from_material_file())
	action_flow.add_child(sync_mat_btn)

	var add_mesh_btn = Button.new()
	add_mesh_btn.text = "➕ Add Mesh to Current Scene"
	add_mesh_btn.tooltip_text = "Adds a PalletteSwapScreenSpaceMesh node to the currently edited scene."
	add_mesh_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_mesh_btn.pressed.connect(_on_add_mesh_to_scene_pressed)
	action_flow.add_child(add_mesh_btn)

	var add_canvas_btn = Button.new()
	add_canvas_btn.text = "➕ Add Canvas/HUD Swap to Current Scene"
	add_canvas_btn.tooltip_text = "Adds a PalletteSwapScreenSpaceCanvas node (CanvasLayer) to the currently edited scene for 2D CanvasItem and HUD palette swapping."
	add_canvas_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_canvas_btn.pressed.connect(_on_add_canvas_to_scene_pressed)
	action_flow.add_child(add_canvas_btn)

	gen_vbox.add_child(action_flow)
	header_flow.add_child(gen_vbox)
	main_vbox.add_child(header_panel)

	# --- 2. Toolbar (Presets, Colors, Import/Export) ---
	var tool_panel = PanelContainer.new()
	var tool_margin = MarginContainer.new()
	tool_margin.add_theme_constant_override("margin_left", 10)
	tool_margin.add_theme_constant_override("margin_top", 8)
	tool_margin.add_theme_constant_override("margin_right", 10)
	tool_margin.add_theme_constant_override("margin_bottom", 8)
	tool_panel.add_child(tool_margin)

	var tool_flow = HFlowContainer.new()
	tool_flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tool_flow.add_theme_constant_override("h_separation", 10)
	tool_flow.add_theme_constant_override("v_separation", 8)
	tool_margin.add_child(tool_flow)

	# Group 1: Palette Selection & Color Filter
	var select_group = HBoxContainer.new()
	select_group.add_theme_constant_override("separation", 6)

	var filter_lbl = Label.new()
	filter_lbl.text = "Colors:"
	select_group.add_child(filter_lbl)

	_color_filter_option = OptionButton.new()
	_color_filter_option.custom_minimum_size = Vector2(120, 0)
	_color_filter_option.tooltip_text = "Filter available palettes by number of colors"
	_color_filter_option.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_color_filter_option.item_selected.connect(_on_color_filter_selected)
	select_group.add_child(_color_filter_option)

	var preset_lbl = Label.new()
	preset_lbl.text = "Palette:"
	select_group.add_child(preset_lbl)

	_preset_option = OptionButton.new()
	_preset_option.custom_minimum_size = Vector2(210, 0)
	_preset_option.tooltip_text = "Select a default or custom palette"
	_preset_option.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_preset_option.item_selected.connect(_on_preset_selected)
	select_group.add_child(_preset_option)

	var refresh_presets_btn = Button.new()
	refresh_presets_btn.text = "🔄"
	refresh_presets_btn.tooltip_text = "Refresh palettes list from project and default addons"
	refresh_presets_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	refresh_presets_btn.pressed.connect(_refresh_preset_list)
	select_group.add_child(refresh_presets_btn)

	var load_preset_btn = Button.new()
	load_preset_btn.text = "Load"
	load_preset_btn.tooltip_text = "Load selected palette into editor"
	load_preset_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	load_preset_btn.pressed.connect(_load_current_selected_preset)
	select_group.add_child(load_preset_btn)

	tool_flow.add_child(select_group)

	# Group 2: Palette Actions
	var action_group = HBoxContainer.new()
	action_group.add_theme_constant_override("separation", 6)

	var add_color_btn = Button.new()
	add_color_btn.text = "+ Add Color"
	add_color_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	add_color_btn.pressed.connect(_on_add_color_pressed)
	action_group.add_child(add_color_btn)

	var sort_btn = Button.new()
	sort_btn.text = "Sort Brightness"
	sort_btn.tooltip_text = "Sort colors by luminance (dark to light)"
	sort_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	sort_btn.pressed.connect(_on_sort_luminance_pressed)
	action_group.add_child(sort_btn)

	var reverse_btn = Button.new()
	reverse_btn.text = "Reverse"
	reverse_btn.tooltip_text = "Reverse color order"
	reverse_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	reverse_btn.pressed.connect(_on_reverse_pressed)
	action_group.add_child(reverse_btn)

	var clear_btn = Button.new()
	clear_btn.text = "Clear"
	clear_btn.tooltip_text = "Clear palette"
	clear_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	clear_btn.pressed.connect(_on_clear_pressed)
	action_group.add_child(clear_btn)

	tool_flow.add_child(action_group)

	# Group 3: File & Import/Export Actions
	var file_group = HBoxContainer.new()
	file_group.add_theme_constant_override("separation", 6)

	var save_tres_btn = Button.new()
	save_tres_btn.text = "💾 Save .tres"
	save_tres_btn.tooltip_text = "Save current palette as a native Godot PaletteResource (.tres) resource."
	save_tres_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	save_tres_btn.pressed.connect(_on_save_tres_pressed)
	file_group.add_child(save_tres_btn)

	var importer_btn = Button.new()
	importer_btn.text = "📥 Importer..."
	importer_btn.tooltip_text = "Open Palette Importer dialog (GPL, PAL, PNG, Batch conversion to .tres)."
	importer_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	importer_btn.pressed.connect(_open_importer_dialog)
	file_group.add_child(importer_btn)

	var import_btn = Button.new()
	import_btn.text = "Quick Import..."
	import_btn.tooltip_text = "Quickly import palette from .gpl, .pal, .png, .hex, .json, or .tres file"
	import_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	import_btn.pressed.connect(_on_import_pressed)
	file_group.add_child(import_btn)

	var export_btn = Button.new()
	export_btn.text = "Export..."
	export_btn.tooltip_text = "Export palette to .tres, .hex, or .json file"
	export_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	export_btn.pressed.connect(_on_export_pressed)
	file_group.add_child(export_btn)

	tool_flow.add_child(file_group)

	# Group 4: Palette Count / Status Info
	var info_group = HBoxContainer.new()
	info_group.add_theme_constant_override("separation", 6)

	_count_label = Label.new()
	_count_label.text = "Colors: 0"
	info_group.add_child(_count_label)

	tool_flow.add_child(info_group)

	main_vbox.add_child(tool_panel)
	main_vbox.add_child(_build_input_adjustments_panel())

	# --- 3. Interactive Color Spectrum Chart (Main Workspace) ---
	var spectrum_panel = PanelContainer.new()
	spectrum_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spectrum_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spectrum_panel.custom_minimum_size = Vector2(0, 310)

	var spectrum_vbox = VBoxContainer.new()
	spectrum_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spectrum_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spectrum_vbox.add_theme_constant_override("separation", 8)

	var spectrum_margin = MarginContainer.new()
	spectrum_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spectrum_margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spectrum_margin.add_theme_constant_override("margin_left", 12)
	spectrum_margin.add_theme_constant_override("margin_top", 12)
	spectrum_margin.add_theme_constant_override("margin_right", 12)
	spectrum_margin.add_theme_constant_override("margin_bottom", 12)
	spectrum_panel.add_child(spectrum_margin)
	spectrum_margin.add_child(spectrum_vbox)

	# Interactive Hint Label
	var hint_hbox = HBoxContainer.new()
	var hint_lbl = Label.new()
	hint_lbl.text = "💡 Drag & Drop colors to reorder.  •  Left-click to change color with ColorPicker.  •  Right-click for context menu."
	hint_lbl.modulate = Color(0.85, 0.85, 0.85)
	hint_hbox.add_child(hint_lbl)
	spectrum_vbox.add_child(hint_hbox)

	# Scrollable Spectrum Chart
	_spectrum_scroll = ScrollContainer.new()
	_spectrum_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_spectrum_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_spectrum_scroll.custom_minimum_size = Vector2(0, 240)
	_spectrum_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	_spectrum_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_spectrum_scroll.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				if not event.shift_pressed:
					if _main_scroll:
						var delta = -50 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 50
						_main_scroll.scroll_vertical += delta
						_spectrum_scroll.accept_event()
				else:
					var h_delta = -50 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 50
					_spectrum_scroll.scroll_horizontal += h_delta
					_spectrum_scroll.accept_event()
	)

	_spectrum_container = HBoxContainer.new()
	_spectrum_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_spectrum_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_spectrum_container.add_theme_constant_override("separation", 6)
	_spectrum_scroll.add_child(_spectrum_container)

	spectrum_vbox.add_child(_spectrum_scroll)
	main_vbox.add_child(spectrum_panel)

	# --- 4. Status Bar ---
	var status_panel = PanelContainer.new()
	var status_margin = MarginContainer.new()
	status_margin.add_theme_constant_override("margin_left", 8)
	status_margin.add_theme_constant_override("margin_top", 4)
	status_margin.add_theme_constant_override("margin_right", 8)
	status_margin.add_theme_constant_override("margin_bottom", 4)
	status_panel.add_child(status_margin)

	_status_label = Label.new()
	_status_label.text = "Ready."
	status_margin.add_child(_status_label)
	main_vbox.add_child(status_panel)

## Initializes context menus and popups
func _setup_popups() -> void:
	# Right-click context menu
	_context_menu = PopupMenu.new()
	_context_menu.id_pressed.connect(_on_context_menu_item_pressed)
	add_child(_context_menu)

	# Color Picker Popup
	_picker_popup = PopupPanel.new()
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	_picker_popup.add_child(margin)

	var picker_vbox = VBoxContainer.new()
	picker_vbox.add_theme_constant_override("separation", 8)
	margin.add_child(picker_vbox)

	_picker_title_lbl = Label.new()
	_picker_title_lbl.text = "Change Color"
	_picker_title_lbl.add_theme_font_size_override("font_size", 14)
	picker_vbox.add_child(_picker_title_lbl)

	_popup_color_picker = ColorPicker.new()
	_popup_color_picker.edit_alpha = false
	_popup_color_picker.picker_shape = ColorPicker.SHAPE_HSV_WHEEL
	_popup_color_picker.color_changed.connect(_on_picker_color_changed)
	picker_vbox.add_child(_popup_color_picker)

	add_child(_picker_popup)

	# File Dialog
	_file_dialog = FileDialog.new()
	_file_dialog.access = FileDialog.ACCESS_RESOURCES
	_file_dialog.filters = PackedStringArray([
		"*.tres, *.gpl, *.pal, *.png, *.hex, *.json ; All Supported Palette Formats",
		"*.tres ; Godot PaletteResource",
		"*.gpl ; GIMP Palette",
		"*.pal ; PAL Palette (JASC / RIFF)",
		"*.png ; PNG Image (Unique Colors)",
		"*.hex ; Lospec Hex File",
		"*.json ; JSON Palette"
	])
	_file_dialog.file_selected.connect(_on_file_dialog_selected)
	add_child(_file_dialog)

	# Save Dialog (.tres)
	_save_dialog = FileDialog.new()
	_save_dialog.access = FileDialog.ACCESS_RESOURCES
	_save_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	_save_dialog.title = "Save PaletteResource (.tres)"
	_save_dialog.filters = PackedStringArray(["*.tres ; PaletteResource"])
	_save_dialog.file_selected.connect(_on_save_dialog_selected)
	add_child(_save_dialog)

## Sets up the Palette Importer dialog with Single File & Batch tabs
func _setup_importer_dialog() -> void:
	_importer_dialog = AcceptDialog.new()
	_importer_dialog.title = "Palette Importer & Batch Converter"
	_importer_dialog.min_size = Vector2i(700, 520)

	var tab_container = TabContainer.new()
	tab_container.custom_minimum_size = Vector2(660, 440)

	# --- Tab 1: Single File Import ---
	var single_margin = MarginContainer.new()
	single_margin.name = "Single File Import"
	single_margin.add_theme_constant_override("margin_left", 10)
	single_margin.add_theme_constant_override("margin_top", 10)
	single_margin.add_theme_constant_override("margin_right", 10)
	single_margin.add_theme_constant_override("margin_bottom", 10)

	var single_vbox = VBoxContainer.new()
	single_vbox.add_theme_constant_override("separation", 10)
	single_margin.add_child(single_vbox)

	var single_desc = Label.new()
	single_desc.text = "Import a single palette (.gpl, .pal, .png, .hex, .json, .tres) directly into editor or save as .tres."
	single_desc.modulate = Color(0.8, 0.8, 0.8)
	single_vbox.add_child(single_desc)

	var file_row = HBoxContainer.new()
	file_row.add_theme_constant_override("separation", 8)
	var file_lbl = Label.new()
	file_lbl.text = "Palette File:"
	file_row.add_child(file_lbl)

	_single_import_path_edit = LineEdit.new()
	_single_import_path_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_single_import_path_edit.text_changed.connect(func(_t): _preview_single_import())
	file_row.add_child(_single_import_path_edit)

	var browse_single_btn = Button.new()
	browse_single_btn.text = "Browse..."
	browse_single_btn.pressed.connect(func():
		_single_file_picker.popup_centered(Vector2i(700, 500))
	)
	file_row.add_child(browse_single_btn)
	single_vbox.add_child(file_row)

	_single_skip_trans_cb = CheckBox.new()
	_single_skip_trans_cb.text = "Skip transparent pixels (alpha = 0) when extracting from PNG"
	_single_skip_trans_cb.button_pressed = true
	_single_skip_trans_cb.toggled.connect(func(_b): _preview_single_import())
	single_vbox.add_child(_single_skip_trans_cb)

	_single_preview_lbl = Label.new()
	_single_preview_lbl.text = "No file selected."
	single_vbox.add_child(_single_preview_lbl)

	var preview_scroll = ScrollContainer.new()
	preview_scroll.custom_minimum_size = Vector2(0, 70)
	preview_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	preview_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_single_preview_container = HBoxContainer.new()
	_single_preview_container.custom_minimum_size = Vector2(0, 50)
	_single_preview_container.add_theme_constant_override("separation", 2)
	preview_scroll.add_child(_single_preview_container)
	single_vbox.add_child(preview_scroll)

	var single_actions_row = HFlowContainer.new()
	single_actions_row.add_theme_constant_override("h_separation", 10)
	single_actions_row.add_theme_constant_override("v_separation", 6)

	var preview_btn = Button.new()
	preview_btn.text = "🔍 Preview Palette"
	preview_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	preview_btn.pressed.connect(_preview_single_import)
	single_actions_row.add_child(preview_btn)

	var load_to_editor_btn = Button.new()
	load_to_editor_btn.text = "📥 Load into Palette Editor"
	load_to_editor_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	load_to_editor_btn.pressed.connect(_load_single_to_editor)
	single_actions_row.add_child(load_to_editor_btn)

	var save_as_tres_btn = Button.new()
	save_as_tres_btn.text = "💾 Save to res://palettes/ as .tres"
	save_as_tres_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	save_as_tres_btn.pressed.connect(_save_single_as_tres)
	single_actions_row.add_child(save_as_tres_btn)

	single_vbox.add_child(single_actions_row)
	tab_container.add_child(single_margin)

	# --- Tab 2: Batch Importer ---
	var batch_margin = MarginContainer.new()
	batch_margin.name = "Batch Convert to .tres"
	batch_margin.add_theme_constant_override("margin_left", 10)
	batch_margin.add_theme_constant_override("margin_top", 10)
	batch_margin.add_theme_constant_override("margin_right", 10)
	batch_margin.add_theme_constant_override("margin_bottom", 10)

	var batch_vbox = VBoxContainer.new()
	batch_vbox.add_theme_constant_override("separation", 10)
	batch_margin.add_child(batch_vbox)

	var batch_desc = Label.new()
	batch_desc.text = "Scan a folder of palette files (.gpl, .pal, .png, .hex, .json) and convert each into a .tres PaletteResource."
	batch_desc.modulate = Color(0.8, 0.8, 0.8)
	batch_vbox.add_child(batch_desc)

	# Source Dir
	var src_row = HBoxContainer.new()
	src_row.add_theme_constant_override("separation", 8)
	var src_lbl = Label.new()
	src_lbl.text = "Source Folder:"
	src_row.add_child(src_lbl)

	_batch_src_edit = LineEdit.new()
	_batch_src_edit.text = "res://"
	_batch_src_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	src_row.add_child(_batch_src_edit)

	var browse_src_btn = Button.new()
	browse_src_btn.text = "Browse..."
	browse_src_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	browse_src_btn.pressed.connect(func():
		_batch_dir_picker.popup_centered(Vector2i(700, 500))
	)
	src_row.add_child(browse_src_btn)
	batch_vbox.add_child(src_row)

	# Dest Dir
	var dest_row = HBoxContainer.new()
	dest_row.add_theme_constant_override("separation", 8)
	var dest_lbl = Label.new()
	dest_lbl.text = "Target Folder:"
	dest_row.add_child(dest_lbl)

	_batch_dest_edit = LineEdit.new()
	_batch_dest_edit.text = "res://palettes"
	_batch_dest_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dest_row.add_child(_batch_dest_edit)

	var browse_dest_btn = Button.new()
	browse_dest_btn.text = "Browse..."
	browse_dest_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	browse_dest_btn.pressed.connect(func():
		_batch_dest_picker.popup_centered(Vector2i(700, 500))
	)
	dest_row.add_child(browse_dest_btn)
	batch_vbox.add_child(dest_row)

	var batch_opts_row = HBoxContainer.new()
	batch_opts_row.add_theme_constant_override("separation", 16)
	_batch_recursive_cb = CheckBox.new()
	_batch_recursive_cb.text = "Include Subdirectories"
	batch_opts_row.add_child(_batch_recursive_cb)

	_batch_skip_trans_cb = CheckBox.new()
	_batch_skip_trans_cb.text = "Skip transparent PNG pixels"
	_batch_skip_trans_cb.button_pressed = true
	batch_opts_row.add_child(_batch_skip_trans_cb)
	batch_vbox.add_child(batch_opts_row)

	var run_batch_btn = Button.new()
	run_batch_btn.text = "🚀 Run Batch Conversion to .tres"
	run_batch_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	run_batch_btn.pressed.connect(_run_batch_import)
	batch_vbox.add_child(run_batch_btn)

	_batch_log_edit = TextEdit.new()
	_batch_log_edit.custom_minimum_size = Vector2(0, 140)
	_batch_log_edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_batch_log_edit.editable = false
	_batch_log_edit.text = "Ready to batch convert palette files."
	batch_vbox.add_child(_batch_log_edit)

	tab_container.add_child(batch_margin)

	_importer_dialog.add_child(tab_container)
	add_child(_importer_dialog)

	# File Pickers for Importer Dialog
	_single_file_picker = FileDialog.new()
	_single_file_picker.access = FileDialog.ACCESS_RESOURCES
	_single_file_picker.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	_single_file_picker.filters = PackedStringArray([
		"*.tres, *.gpl, *.pal, *.png, *.hex, *.json ; Supported Palette Files",
		"*.* ; All Files"
	])
	_single_file_picker.file_selected.connect(func(p):
		_single_import_path_edit.text = p
		_preview_single_import()
	)
	add_child(_single_file_picker)

	_batch_dir_picker = FileDialog.new()
	_batch_dir_picker.access = FileDialog.ACCESS_RESOURCES
	_batch_dir_picker.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	_batch_dir_picker.dir_selected.connect(func(d): _batch_src_edit.text = d)
	add_child(_batch_dir_picker)

	_batch_dest_picker = FileDialog.new()
	_batch_dest_picker.access = FileDialog.ACCESS_RESOURCES
	_batch_dest_picker.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	_batch_dest_picker.dir_selected.connect(func(d): _batch_dest_edit.text = d)
	add_child(_batch_dest_picker)

## Refreshes the color spectrum chart from current_colors
func _refresh_palette_view() -> void:
	_count_label.text = "Colors: %d" % current_colors.size()
	_swatch_nodes.clear()

	for child in _spectrum_container.get_children():
		child.queue_free()

	if current_colors.is_empty():
		var empty_lbl = Label.new()
		empty_lbl.text = "(Empty palette. Click '+ Add Color' or choose a preset above.)"
		empty_lbl.modulate = Color(0.6, 0.6, 0.6)
		empty_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		empty_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		empty_lbl.size_flags_vertical = Control.SIZE_EXPAND_FILL
		_spectrum_container.add_child(empty_lbl)
		return

	for i in range(current_colors.size()):
		var swatch = SpectrumSwatchControl.new(i, current_colors[i], self)
		_spectrum_container.add_child(swatch)
		_swatch_nodes.append(swatch)

## Updates a single swatch's visual color in real time
func _update_single_swatch(idx: int, col: Color) -> void:
	if idx >= 0 and idx < _swatch_nodes.size():
		_swatch_nodes[idx].update_color(col)

## Moves a color from one index to another (drag and drop)
func move_color(from_idx: int, to_idx: int, insert_after: bool = false) -> void:
	if from_idx < 0 or from_idx >= current_colors.size():
		return
	if to_idx < 0 or to_idx >= current_colors.size():
		return

	var target = to_idx
	if insert_after:
		target += 1
	if from_idx < target:
		target -= 1

	target = clampi(target, 0, current_colors.size() - 1)
	if from_idx == target:
		return

	var col = current_colors[from_idx]
	current_colors.remove_at(from_idx)
	current_colors.insert(target, col)

	_refresh_palette_view()
	_show_status("Moved Color #%02d to #%02d." % [from_idx + 1, target + 1], false)

## Opens the right-click context menu
func open_context_menu(index: int, pos: Vector2) -> void:
	_context_menu_index = index
	_last_click_pos = pos

	_context_menu.clear()
	_context_menu.add_item("🎨  Change Color", 0)
	_context_menu.add_item("➕  Insert Color Ahead", 1)
	_context_menu.add_item("➕  Insert Behind", 2)
	_context_menu.add_separator()
	_context_menu.add_item("🗑️  Delete", 3)

	_context_menu.position = Vector2i(pos)
	_context_menu.popup()

## Context menu item pressed handler
func _on_context_menu_item_pressed(id: int) -> void:
	match id:
		0: # Change Color
			open_color_picker_popup(_context_menu_index, _last_click_pos)
		1: # Insert Ahead
			var new_col = current_colors[_context_menu_index] if _context_menu_index < current_colors.size() else Color.WHITE
			current_colors.insert(_context_menu_index, new_col)
			_refresh_palette_view()
			open_color_picker_popup(_context_menu_index, _last_click_pos)
			_show_status("Inserted color ahead at #%02d." % (_context_menu_index + 1), false)
		2: # Insert Behind
			var insert_idx = _context_menu_index + 1
			var new_col = current_colors[_context_menu_index] if _context_menu_index < current_colors.size() else Color.WHITE
			current_colors.insert(insert_idx, new_col)
			_refresh_palette_view()
			open_color_picker_popup(insert_idx, _last_click_pos)
			_show_status("Inserted color behind at #%02d." % (insert_idx + 1), false)
		3: # Delete
			if _context_menu_index >= 0 and _context_menu_index < current_colors.size():
				current_colors.remove_at(_context_menu_index)
				_refresh_palette_view()
				_show_status("Deleted color.", false)

## Opens the ColorPicker popup for a specific color index
func open_color_picker_popup(index: int, pos: Vector2 = Vector2.ZERO) -> void:
	if not is_inside_tree():
		_active_color_index = index
		return
	if index < 0 or index >= current_colors.size():
		return

	_active_color_index = index
	var col = current_colors[index]
	_picker_title_lbl.text = "Change Color #%02d (#%s)" % [index + 1, col.to_html(false).to_lower()]

	_popup_color_picker.set_block_signals(true)
	_popup_color_picker.color = col
	_popup_color_picker.set_block_signals(false)

	if pos != Vector2.ZERO:
		var popup_size = Vector2i(320, 480)
		var view_rect = get_viewport_rect()
		var target_x = mini(int(pos.x), int(view_rect.size.x - popup_size.x - 10))
		var target_y = mini(int(pos.y), int(view_rect.size.y - popup_size.y - 10))
		_picker_popup.position = Vector2i(maxi(10, target_x), maxi(10, target_y))
		_picker_popup.popup()
	else:
		_picker_popup.popup_centered(Vector2i(320, 480))

## Live update when color in popup changes
func _on_picker_color_changed(new_color: Color) -> void:
	if _active_color_index >= 0 and _active_color_index < current_colors.size():
		current_colors[_active_color_index] = new_color
		_picker_title_lbl.text = "Change Color #%02d (#%s)" % [_active_color_index + 1, new_color.to_html(false).to_lower()]
		_update_single_swatch(_active_color_index, new_color)

func _refresh_preset_list() -> void:
	if not _preset_option or not _color_filter_option:
		return

	_all_palettes.clear()

	# 1. Built-in default presets from PalettePresets
	var names = PalettePresets.get_preset_names()
	for n in names:
		var colors = PalettePresets.get_preset_colors(n)
		_all_palettes.append({
			"name": n,
			"category": "default",
			"type": "builtin",
			"path": "",
			"color_count": colors.size(),
			"colors": colors,
			"author": "Built-in",
			"comment": ""
		})

	# 2. Default .tres palettes from res://addons/advanced_palette_swap/default_palettes
	var default_dir = "res://addons/advanced_palette_swap/default_palettes"
	if DirAccess.dir_exists_absolute(default_dir):
		var dir = DirAccess.open(default_dir)
		if dir:
			dir.list_dir_begin()
			var fn = dir.get_next()
			var default_files: PackedStringArray = []
			while fn != "":
				if fn.ends_with(".tres"):
					default_files.append(fn)
				fn = dir.get_next()
			dir.list_dir_end()
			default_files.sort()

			for f in default_files:
				var full_p = default_dir.path_join(f)
				var pal = PaletteResource.load_from_file(full_p)
				if pal:
					var p_name = pal.palette_name if not pal.palette_name.is_empty() else f.get_basename()
					_all_palettes.append({
						"name": p_name,
						"category": "default",
						"type": "tres",
						"path": full_p,
						"color_count": pal.size(),
						"colors": pal.colors,
						"author": pal.author,
						"comment": pal.comment
					})

	# 3. Custom .tres palettes from res://palettes
	var custom_dir = "res://palettes"
	if DirAccess.dir_exists_absolute(custom_dir):
		var dir = DirAccess.open(custom_dir)
		if dir:
			dir.list_dir_begin()
			var fn = dir.get_next()
			var custom_files: PackedStringArray = []
			while fn != "":
				if fn.ends_with(".tres"):
					custom_files.append(fn)
				fn = dir.get_next()
			dir.list_dir_end()
			custom_files.sort()

			for f in custom_files:
				var full_p = custom_dir.path_join(f)
				var pal = PaletteResource.load_from_file(full_p)
				if pal:
					var p_name = pal.palette_name if not pal.palette_name.is_empty() else f.get_basename()
					_all_palettes.append({
						"name": p_name,
						"category": "custom",
						"type": "tres",
						"path": full_p,
						"color_count": pal.size(),
						"colors": pal.colors,
						"author": pal.author,
						"comment": pal.comment
					})

	_update_color_filter_dropdown()
	_update_preset_dropdown()

func _update_color_filter_dropdown() -> void:
	if not _color_filter_option:
		return

	var counts_map: Dictionary = {}
	for pal in _all_palettes:
		var c: int = pal.get("color_count", 0)
		counts_map[c] = counts_map.get(c, 0) + 1

	var sorted_counts: Array = counts_map.keys()
	sorted_counts.sort()

	var prev_filter = _selected_color_count_filter

	_color_filter_option.clear()
	_color_filter_option.add_item("All Colors (%d)" % _all_palettes.size(), 0)
	_color_filter_option.set_item_metadata(0, -1)

	var select_idx = 0
	var item_idx = 1
	for count in sorted_counts:
		var label = "%d Colors (%d)" % [count, counts_map[count]]
		_color_filter_option.add_item(label, item_idx)
		_color_filter_option.set_item_metadata(item_idx, count)
		if count == prev_filter:
			select_idx = item_idx
		item_idx += 1

	_color_filter_option.selected = select_idx
	_selected_color_count_filter = _color_filter_option.get_item_metadata(select_idx)

func _on_color_filter_selected(index: int) -> void:
	if index < 0 or index >= _color_filter_option.item_count:
		return
	var count = _color_filter_option.get_item_metadata(index)
	_selected_color_count_filter = count if count != null else -1
	_update_preset_dropdown()

func _update_preset_dropdown() -> void:
	if not _preset_option:
		return

	var prev_selected_name: String = ""
	if _preset_option.selected >= 0 and _preset_option.selected < _preset_option.item_count:
		var prev_meta = _preset_option.get_item_metadata(_preset_option.selected)
		if prev_meta is Dictionary:
			prev_selected_name = prev_meta.get("name", "")

	_preset_option.clear()
	_preset_items.clear()

	var default_palettes: Array[Dictionary] = []
	var custom_palettes: Array[Dictionary] = []

	for pal in _all_palettes:
		if _selected_color_count_filter > 0 and pal.get("color_count", 0) != _selected_color_count_filter:
			continue
		if pal.get("category") == "default":
			default_palettes.append(pal)
		else:
			custom_palettes.append(pal)

	var target_select_idx = -1

	# 1. Default Palettes Section
	if default_palettes.size() > 0:
		_preset_option.add_separator("── Default Palettes (%d) ──" % default_palettes.size())
		for pal in default_palettes:
			var idx = _preset_option.item_count
			var label = "%s (%d)" % [pal.get("name", ""), pal.get("color_count", 0)]
			_preset_option.add_item(label, idx)
			_preset_option.set_item_metadata(idx, pal)
			_preset_items.append(pal)
			if pal.get("name") == prev_selected_name:
				target_select_idx = idx

	# 2. Custom Palettes Section
	if custom_palettes.size() > 0:
		_preset_option.add_separator("── Custom Palettes (%d) ──" % custom_palettes.size())
		for pal in custom_palettes:
			var idx = _preset_option.item_count
			var label = "⭐ %s (%d)" % [pal.get("name", ""), pal.get("color_count", 0)]
			_preset_option.add_item(label, idx)
			_preset_option.set_item_metadata(idx, pal)
			_preset_items.append(pal)
			if pal.get("name") == prev_selected_name:
				target_select_idx = idx

	if default_palettes.is_empty() and custom_palettes.is_empty():
		_preset_option.add_item("(No palettes with %d colors)" % _selected_color_count_filter, 0)
		_preset_option.set_item_disabled(0, true)
		return

	if target_select_idx >= 0:
		_preset_option.selected = target_select_idx
	else:
		for i in range(_preset_option.item_count):
			if not _preset_option.is_item_separator(i) and not _preset_option.is_item_disabled(i):
				_preset_option.selected = i
				break

func _load_current_selected_preset() -> void:
	if not _preset_option:
		return
	var idx = _preset_option.selected
	if idx < 0 or idx >= _preset_option.item_count:
		return
	if _preset_option.is_item_separator(idx) or _preset_option.is_item_disabled(idx):
		return
	var meta = _preset_option.get_item_metadata(idx)
	if meta is Dictionary:
		_load_palette_item(meta)

func _on_preset_selected(index: int) -> void:
	if index < 0 or index >= _preset_option.item_count:
		return
	if _preset_option.is_item_separator(index) or _preset_option.is_item_disabled(index):
		return
	var meta = _preset_option.get_item_metadata(index)
	if meta is Dictionary:
		_load_palette_item(meta)

func _load_palette_item(item: Dictionary) -> void:
	var item_name: String = item.get("name", "")
	var category: String = item.get("category", "default")
	var p_type: String = item.get("type", "builtin")
	var path: String = item.get("path", "")

	if p_type == "builtin":
		var colors = PalettePresets.get_preset_colors(item_name)
		if not colors.is_empty():
			current_colors = colors.duplicate()
			_refresh_palette_view()
			_show_status("Loaded default preset '%s' (%d colors)" % [item_name, current_colors.size()], false)
	elif p_type == "tres" and not path.is_empty():
		var pal = PaletteResource.load_from_file(path)
		if pal and not pal.is_empty():
			current_colors = pal.colors.duplicate()
			_refresh_palette_view()
			var type_text = "default" if category == "default" else "custom"
			var author_info = " by %s" % pal.author if not pal.author.is_empty() else ""
			_show_status("Loaded %s palette '%s'%s (%d colors)" % [type_text, pal.palette_name, author_info, current_colors.size()], false)
		else:
			_show_status("Failed to load palette from '%s'" % path, true)

func _load_preset(preset_name: String) -> void:
	for pal in _all_palettes:
		if pal.get("name") == preset_name:
			_load_palette_item(pal)
			return
	var colors = PalettePresets.get_preset_colors(preset_name)
	if not colors.is_empty():
		current_colors = colors.duplicate()
		_refresh_palette_view()
		_show_status("Loaded preset '%s' (%d colors)" % [preset_name, current_colors.size()], false)

func _load_tres_palette(path: String) -> void:
	for pal in _all_palettes:
		if pal.get("path") == path:
			_load_palette_item(pal)
			return
	var pal = PaletteImporter.import_file(path)
	if pal and not pal.is_empty():
		current_colors = pal.colors.duplicate()
		_refresh_palette_view()
		_show_status("Loaded palette '%s' (%d colors)" % [pal.palette_name, current_colors.size()], false)
	else:
		_show_status("Failed to load palette from '%s'" % path, true)

func _on_add_color_pressed() -> void:
	current_colors.append(Color.WHITE)
	_refresh_palette_view()
	open_color_picker_popup(current_colors.size() - 1)
	_show_status("Added new color to palette.", false)

func _on_sort_luminance_pressed() -> void:
	current_colors.sort_custom(func(a: Color, b: Color):
		var lum_a = a.r * 0.299 + a.g * 0.587 + a.b * 0.114
		var lum_b = b.r * 0.299 + b.g * 0.587 + b.b * 0.114
		return lum_a < lum_b
	)
	_refresh_palette_view()
	_show_status("Sorted colors by luminance (dark to light).", false)

func _on_reverse_pressed() -> void:
	current_colors.reverse()
	_refresh_palette_view()
	_show_status("Reversed color order.", false)

func _on_clear_pressed() -> void:
	current_colors.clear()
	_refresh_palette_view()
	_show_status("Cleared palette.", false)

func _on_generate_pressed() -> void:
	if current_colors.is_empty():
		_show_status("Cannot generate shader with an empty palette! Add at least one color.", true)
		return

	var out_dir = _output_dir_edit.text.strip_edges()
	var params = {
		"dither_strength": 0.0,
		"color_distance_mode": color_distance_mode,
		"input_lightness": input_lightness,
		"input_saturation": input_saturation,
		"input_contrast": input_contrast,
		"input_red": input_red,
		"input_green": input_green,
		"input_blue": input_blue
	}
	var result = PaletteGenerator.write_palette_files(out_dir, current_colors, false, params)

	if result.get("success", false):
		var inc_p: String = result.get("inc_path", "")
		var sh_p: String = result.get("shader_path", "")
		var mat_p: String = result.get("material_path", "")
		var c_sh_p: String = result.get("canvas_shader_path", "")
		var c_mat_p: String = result.get("canvas_material_path", "")

		# Rescan and reimport filesystem in Godot editor
		if Engine.is_editor_hint() and ClassDB.class_exists("EditorInterface"):
			var fs = EditorInterface.get_resource_filesystem()
			if fs:
				if FileAccess.file_exists(inc_p):
					fs.update_file(inc_p)
				if FileAccess.file_exists(sh_p):
					fs.update_file(sh_p)
				if FileAccess.file_exists(mat_p):
					fs.update_file(mat_p)
				if FileAccess.file_exists(c_sh_p):
					fs.update_file(c_sh_p)
				if FileAccess.file_exists(c_mat_p):
					fs.update_file(c_mat_p)
				fs.reimport_files(PackedStringArray([inc_p, sh_p, mat_p, c_sh_p, c_mat_p]))
				fs.scan()

			# Immediately refresh any PalletteSwapScreenSpaceMesh or PalletteSwapScreenSpaceCanvas in the active scene
			var edited_root = EditorInterface.get_edited_scene_root()
			if edited_root:
				_refresh_screenspace_meshes(edited_root, sh_p, mat_p, c_sh_p, c_mat_p)

		_show_status("Successfully generated shaders & materials (%d colors) and hooked into scene!" % current_colors.size(), false)
	else:
		_show_status("Error generating shaders: %s" % result.get("error", "Unknown error"), true)

func _refresh_screenspace_meshes(node: Node, shader_file_path: String, material_file_path: String = "", canvas_shader_path: String = "", canvas_material_path: String = "") -> void:
	if node is PalletteSwapScreenSpaceMesh:
		node.shader_path = shader_file_path
		if not material_file_path.is_empty():
			node.material_path = material_file_path
		node.color_distance_mode = color_distance_mode
		node.input_lightness = input_lightness
		node.input_saturation = input_saturation
		node.input_contrast = input_contrast
		node.input_red = input_red
		node.input_green = input_green
		node.input_blue = input_blue
		node.setup_screenspace_mesh()
	elif node is PalletteSwapScreenSpaceCanvas:
		if not canvas_shader_path.is_empty():
			node.shader_path = canvas_shader_path
		if not canvas_material_path.is_empty():
			node.material_path = canvas_material_path
		node.color_distance_mode = color_distance_mode
		node.input_lightness = input_lightness
		node.input_saturation = input_saturation
		node.input_contrast = input_contrast
		node.input_red = input_red
		node.input_green = input_green
		node.input_blue = input_blue
		node.setup_screenspace_canvas()
	elif node is CanvasItem and node.material is ShaderMaterial:
		var sm = node.material as ShaderMaterial
		if sm and sm.shader:
			sm.set_shader_parameter("color_distance_mode", color_distance_mode)
			sm.set_shader_parameter("input_lightness", input_lightness)
			sm.set_shader_parameter("input_saturation", input_saturation)
			sm.set_shader_parameter("input_contrast", input_contrast)
			sm.set_shader_parameter("input_red", input_red)
			sm.set_shader_parameter("input_green", input_green)
			sm.set_shader_parameter("input_blue", input_blue)
	for child in node.get_children():
		_refresh_screenspace_meshes(child, shader_file_path, material_file_path, canvas_shader_path, canvas_material_path)

func _on_add_mesh_to_scene_pressed() -> void:
	var edited_root: Node = null
	if Engine.is_editor_hint() and ClassDB.class_exists("EditorInterface"):
		var editor_iface = Engine.get_singleton("EditorInterface")
		if editor_iface and editor_iface.has_method("get_edited_scene_root"):
			edited_root = editor_iface.get_edited_scene_root()

	if not edited_root:
		_show_status("No active scene open in the editor. Open or create a scene first.", true)
		return

	var mesh_node = PalletteSwapScreenSpaceMesh.new()
	mesh_node.name = "PalletteSwapScreenSpaceMesh"
	var out_dir = _output_dir_edit.text.strip_edges()
	mesh_node.shader_path = out_dir.path_join("palette_swap.gdshader")
	mesh_node.material_path = out_dir.path_join("palette_swap.material")
	mesh_node.color_distance_mode = color_distance_mode
	mesh_node.input_lightness = input_lightness
	mesh_node.input_saturation = input_saturation
	mesh_node.input_contrast = input_contrast
	mesh_node.input_red = input_red
	mesh_node.input_green = input_green
	mesh_node.input_blue = input_blue

	edited_root.add_child(mesh_node)
	mesh_node.owner = edited_root
	mesh_node.setup_screenspace_mesh()

	_show_status("Added 'PalletteSwapScreenSpaceMesh' to scene '%s'!" % edited_root.name, false)

func _on_add_canvas_to_scene_pressed() -> void:
	var edited_root: Node = null
	if Engine.is_editor_hint() and ClassDB.class_exists("EditorInterface"):
		var editor_iface = Engine.get_singleton("EditorInterface")
		if editor_iface and editor_iface.has_method("get_edited_scene_root"):
			edited_root = editor_iface.get_edited_scene_root()

	if not edited_root:
		_show_status("No active scene open in the editor. Open or create a scene first.", true)
		return

	var canvas_node = PalletteSwapScreenSpaceCanvas.new()
	canvas_node.name = "PalletteSwapScreenSpaceCanvas"
	var out_dir = _output_dir_edit.text.strip_edges()
	canvas_node.shader_path = out_dir.path_join("palette_swap_canvas.gdshader")
	canvas_node.material_path = out_dir.path_join("palette_swap_canvas.material")
	canvas_node.color_distance_mode = color_distance_mode
	canvas_node.input_lightness = input_lightness
	canvas_node.input_saturation = input_saturation
	canvas_node.input_contrast = input_contrast
	canvas_node.input_red = input_red
	canvas_node.input_green = input_green
	canvas_node.input_blue = input_blue

	edited_root.add_child(canvas_node)
	canvas_node.owner = edited_root
	canvas_node.setup_screenspace_canvas()

	_show_status("Added 'PalletteSwapScreenSpaceCanvas' to scene '%s'!" % edited_root.name, false)

func _on_save_tres_pressed() -> void:
	if current_colors.is_empty():
		_show_status("Cannot save an empty palette!", true)
		return
	_save_dialog.current_dir = "res://palettes"
	_save_dialog.current_file = "my_palette.tres"
	_save_dialog.popup_centered(Vector2i(700, 500))

func _on_save_dialog_selected(path: String) -> void:
	var pal = PaletteResource.create(path.get_file().get_basename(), current_colors)
	var err = pal.save_to_file(path)
	if err == OK:
		PaletteGenerator.rescan_filesystem(PackedStringArray([path]))
		_refresh_preset_list()
		_show_status("Saved palette to '%s'." % path, false)
	else:
		_show_status("Failed to save palette to '%s' (Error %d)." % [path, err], true)

func _on_import_pressed() -> void:
	_is_exporting = false
	_file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	_file_dialog.title = "Import Palette"
	_file_dialog.popup_centered(Vector2i(700, 500))

func _on_export_pressed() -> void:
	_is_exporting = true
	_file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	_file_dialog.title = "Export Palette"
	_file_dialog.popup_centered(Vector2i(700, 500))

func _on_file_dialog_selected(path: String) -> void:
	if _is_exporting:
		var ok = false
		if path.ends_with(".tres"):
			var pal = PaletteResource.create(path.get_file().get_basename(), current_colors)
			ok = pal.save_to_file(path) == OK
			if ok:
				PaletteGenerator.rescan_filesystem(PackedStringArray([path]))
				_refresh_preset_list()
		elif path.ends_with(".json"):
			ok = PaletteGenerator.export_to_json(path, current_colors)
		else:
			ok = PaletteGenerator.export_to_hex(path, current_colors)
		if ok:
			_show_status("Exported palette to '%s'." % path, false)
		else:
			_show_status("Failed to export palette to '%s'." % path, true)
	else:
		var imported = PaletteImporter.import_file(path)
		if imported and not imported.is_empty():
			current_colors = imported.colors.duplicate()
			_refresh_palette_view()
			_show_status("Imported %d colors from '%s'." % [imported.size(), path], false)
		else:
			_show_status("Failed or no colors found in '%s'." % path, true)

func _open_importer_dialog() -> void:
	if _importer_dialog:
		_importer_dialog.popup_centered(Vector2i(720, 540))

func _preview_single_import() -> void:
	var path = _single_import_path_edit.text.strip_edges()
	if path.is_empty():
		_single_preview_lbl.text = "Please specify a file path."
		return

	var skip_trans = _single_skip_trans_cb.button_pressed
	var pal = PaletteImporter.import_file(path, skip_trans)
	_single_loaded_palette = pal

	for c in _single_preview_container.get_children():
		c.queue_free()

	if pal and not pal.is_empty():
		_single_preview_lbl.text = "Palette: '%s' | %d unique colors in '%s'" % [pal.palette_name, pal.size(), path.get_file()]
		for col in pal.colors:
			var cr = ColorRect.new()
			cr.color = col
			cr.custom_minimum_size = Vector2(24, 46)
			cr.tooltip_text = "#" + col.to_html(false).to_lower()
			_single_preview_container.add_child(cr)
	else:
		_single_preview_lbl.text = "Failed to extract colors from '%s'." % path

func _load_single_to_editor() -> void:
	if _single_loaded_palette == null:
		_preview_single_import()
	if _single_loaded_palette and not _single_loaded_palette.is_empty():
		current_colors = _single_loaded_palette.colors.duplicate()
		_refresh_palette_view()
		_show_status("Loaded %d colors from '%s' into editor." % [current_colors.size(), _single_loaded_palette.palette_name], false)
		_importer_dialog.hide()

func _save_single_as_tres() -> void:
	if _single_loaded_palette == null:
		_preview_single_import()
	if _single_loaded_palette and not _single_loaded_palette.is_empty():
		var dest_dir = "res://palettes"
		DirAccess.make_dir_recursive_absolute(dest_dir)
		var safe_name = _single_loaded_palette.palette_name.validate_filename()
		if safe_name.is_empty():
			safe_name = "palette"
		var out_path = dest_dir.path_join(safe_name + ".tres")
		var err = _single_loaded_palette.save_to_file(out_path)
		if err == OK:
			PaletteGenerator.rescan_filesystem(PackedStringArray([out_path]))
			_refresh_preset_list()
			_single_preview_lbl.text = "Successfully saved as '%s'!" % out_path
			_show_status("Saved palette to '%s'." % out_path, false)
		else:
			_single_preview_lbl.text = "Error saving to '%s' (code %d)" % [out_path, err]

func _run_batch_import() -> void:
	var src_dir = _batch_src_edit.text.strip_edges()
	var dest_dir = _batch_dest_edit.text.strip_edges()
	var recursive = _batch_recursive_cb.button_pressed
	var skip_trans = _batch_skip_trans_cb.button_pressed

	_batch_log_edit.text = "Starting batch conversion...\nSource: %s\nDestination: %s\n\n" % [src_dir, dest_dir]

	var res = PaletteImporter.batch_import_directory(src_dir, dest_dir, recursive, skip_trans)
	var log_lines: PackedStringArray = []
	for p in res.get("created_files", PackedStringArray()):
		log_lines.append("  [OK] Created %s" % p)
	for e in res.get("errors", []):
		log_lines.append("  [ERR] %s" % e)

	log_lines.append("\nSummary:")
	log_lines.append("  Total scanned files : %d" % res.get("total", 0))
	log_lines.append("  Successfully created: %d .tres palettes" % res.get("imported", 0))
	log_lines.append("  Failed              : %d" % res.get("failed", 0))

	_batch_log_edit.text += "\n".join(log_lines)
	_refresh_preset_list()
	_show_status("Batch import completed: %d palettes created in '%s'." % [res.get("imported", 0), dest_dir], false)

func _sync_from_material_file(mat_path: String = "") -> void:
	if mat_path.is_empty():
		var out_dir = _output_dir_edit.text.strip_edges() if _output_dir_edit else "res://shaders/palette_swap"
		mat_path = out_dir.path_join("palette_swap.material")

	var params = PaletteGenerator.read_material_parameters(mat_path)
	if params.is_empty():
		_show_status("No material file found at '%s' to sync from." % mat_path, true)
		return

	var l = float(params.get("input_lightness", input_lightness))
	var s = float(params.get("input_saturation", input_saturation))
	var c = float(params.get("input_contrast", input_contrast))
	var r = float(params.get("input_red", input_red))
	var g = float(params.get("input_green", input_green))
	var b = float(params.get("input_blue", input_blue))
	set_input_adjustments(l, s, c, r, g, b)
	if params.has("color_distance_mode"):
		color_distance_mode = int(params["color_distance_mode"])
	_show_status("Synced GUI adjustments from '%s'." % mat_path, false)

func _show_status(msg: String, is_error: bool) -> void:
	if _status_label:
		_status_label.text = msg
		_status_label.modulate = Color(1.0, 0.4, 0.4) if is_error else Color(0.4, 1.0, 0.5)

# --- Input Adjustments (Pre-Palette Processing) ---

func _build_input_adjustments_panel() -> Control:
	_adjustments_panel = PanelContainer.new()
	_adjustments_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var panel_margin = MarginContainer.new()
	panel_margin.add_theme_constant_override("margin_left", 12)
	panel_margin.add_theme_constant_override("margin_top", 8)
	panel_margin.add_theme_constant_override("margin_right", 12)
	panel_margin.add_theme_constant_override("margin_bottom", 8)
	_adjustments_panel.add_child(panel_margin)

	var panel_vbox = VBoxContainer.new()
	panel_vbox.add_theme_constant_override("separation", 8)
	panel_margin.add_child(panel_vbox)

	# Header bar with toggle and reset
	var header_flow = HFlowContainer.new()
	header_flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header_flow.add_theme_constant_override("h_separation", 10)
	header_flow.add_theme_constant_override("v_separation", 6)

	_adjustments_toggle_btn = Button.new()
	_adjustments_toggle_btn.text = "▼ Input Color Adjustments (Pre-Palette)"
	_adjustments_toggle_btn.flat = true
	_adjustments_toggle_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	_adjustments_toggle_btn.pressed.connect(_toggle_adjustments_panel)
	header_flow.add_child(_adjustments_toggle_btn)

	_adjustments_summary_lbl = Label.new()
	_adjustments_summary_lbl.modulate = Color(0.7, 0.7, 0.7)
	_adjustments_summary_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_adjustments_summary_lbl.text = "Tune scene colors before palette swap & dithering"
	header_flow.add_child(_adjustments_summary_lbl)

	var reset_btn = Button.new()
	reset_btn.text = "↺ Reset Adjustments"
	reset_btn.tooltip_text = "Reset lightness, saturation, contrast, and RGB channels to default values."
	reset_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	reset_btn.pressed.connect(reset_adjustments)
	header_flow.add_child(reset_btn)

	panel_vbox.add_child(header_flow)

	# Main controls content container
	_adjustments_content = VBoxContainer.new()
	_adjustments_content.add_theme_constant_override("separation", 8)
	panel_vbox.add_child(_adjustments_content)

	var columns_hbox = HBoxContainer.new()
	columns_hbox.add_theme_constant_override("separation", 24)
	columns_hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_adjustments_content.add_child(columns_hbox)

	# Left Column: Tone & Contrast
	var tone_vbox = VBoxContainer.new()
	tone_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tone_vbox.add_theme_constant_override("separation", 6)
	columns_hbox.add_child(tone_vbox)

	var tone_lbl = Label.new()
	tone_lbl.text = "Tonal Adjustments"
	tone_lbl.modulate = Color(0.85, 0.85, 0.85)
	tone_vbox.add_child(tone_lbl)

	# Lightness
	var light_ctrl = _create_adjustment_control("Lightness:", -1.0, 1.0, 0.01, input_lightness, "Adjust brightness/lightness offset before palette matching (-1.0 = Dark, +1.0 = Bright).")
	_lightness_slider = light_ctrl["slider"]
	_lightness_spin = light_ctrl["spin"]
	_lightness_slider.value_changed.connect(func(v: float):
		input_lightness = v
		_on_adjustment_changed()
	)
	tone_vbox.add_child(light_ctrl["container"])

	# Saturation
	var sat_ctrl = _create_adjustment_control("Saturation:", 0.0, 3.0, 0.01, input_saturation, "Adjust color saturation before palette matching (0.0 = Grayscale, 1.0 = Normal, 3.0 = High).")
	_saturation_slider = sat_ctrl["slider"]
	_saturation_spin = sat_ctrl["spin"]
	_saturation_slider.value_changed.connect(func(v: float):
		input_saturation = v
		_on_adjustment_changed()
	)
	tone_vbox.add_child(sat_ctrl["container"])

	# Contrast
	var con_ctrl = _create_adjustment_control("Contrast:", 0.0, 3.0, 0.01, input_contrast, "Adjust contrast centered at 0.5 (0.0 = Flat gray, 1.0 = Normal, 3.0 = High).")
	_contrast_slider = con_ctrl["slider"]
	_contrast_spin = con_ctrl["spin"]
	_contrast_slider.value_changed.connect(func(v: float):
		input_contrast = v
		_on_adjustment_changed()
	)
	tone_vbox.add_child(con_ctrl["container"])

	# Right Column: RGB Channels
	var rgb_vbox = VBoxContainer.new()
	rgb_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rgb_vbox.add_theme_constant_override("separation", 6)
	columns_hbox.add_child(rgb_vbox)

	var rgb_lbl = Label.new()
	rgb_lbl.text = "Color Channels (RGB Balance)"
	rgb_lbl.modulate = Color(0.85, 0.85, 0.85)
	rgb_vbox.add_child(rgb_lbl)

	# Red Channel
	var red_ctrl = _create_adjustment_control("Red (R):", 0.0, 2.0, 0.01, input_red, "Red channel multiplier (0.0 to 2.0).")
	_red_slider = red_ctrl["slider"]
	_red_spin = red_ctrl["spin"]
	_red_slider.value_changed.connect(func(v: float):
		input_red = v
		_on_adjustment_changed()
	)
	rgb_vbox.add_child(red_ctrl["container"])

	# Green Channel
	var green_ctrl = _create_adjustment_control("Green (G):", 0.0, 2.0, 0.01, input_green, "Green channel multiplier (0.0 to 2.0).")
	_green_slider = green_ctrl["slider"]
	_green_spin = green_ctrl["spin"]
	_green_slider.value_changed.connect(func(v: float):
		input_green = v
		_on_adjustment_changed()
	)
	rgb_vbox.add_child(green_ctrl["container"])

	# Blue Channel
	var blue_ctrl = _create_adjustment_control("Blue (B):", 0.0, 2.0, 0.01, input_blue, "Blue channel multiplier (0.0 to 2.0).")
	_blue_slider = blue_ctrl["slider"]
	_blue_spin = blue_ctrl["spin"]
	_blue_slider.value_changed.connect(func(v: float):
		input_blue = v
		_on_adjustment_changed()
	)
	rgb_vbox.add_child(blue_ctrl["container"])

	_update_adjustment_summary_label()
	return _adjustments_panel

func _create_adjustment_control(label_text: String, min_val: float, max_val: float, step_val: float, default_val: float, tooltip: String) -> Dictionary:
	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 8)
	hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var lbl = Label.new()
	lbl.text = label_text
	lbl.custom_minimum_size = Vector2(85, 0)
	lbl.tooltip_text = tooltip
	hbox.add_child(lbl)

	var slider = HSlider.new()
	slider.min_value = min_val
	slider.max_value = max_val
	slider.step = step_val
	slider.value = default_val
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	slider.tooltip_text = tooltip
	hbox.add_child(slider)

	var spin = SpinBox.new()
	spin.min_value = min_val
	spin.max_value = max_val
	spin.step = step_val
	spin.value = default_val
	spin.custom_minimum_size = Vector2(70, 0)
	spin.tooltip_text = tooltip
	hbox.add_child(spin)

	slider.value_changed.connect(func(v: float):
		spin.set_value_no_signal(v)
	)
	spin.value_changed.connect(func(v: float):
		slider.set_value_no_signal(v)
	)

	return {
		"container": hbox,
		"slider": slider,
		"spin": spin
	}

func _toggle_adjustments_panel() -> void:
	if _adjustments_content:
		_adjustments_content.visible = not _adjustments_content.visible
		_adjustments_toggle_btn.text = "▼ Input Color Adjustments (Pre-Palette)" if _adjustments_content.visible else "▶ Input Color Adjustments (Pre-Palette)"

func _update_adjustment_summary_label() -> void:
	if _adjustments_summary_lbl:
		_adjustments_summary_lbl.text = "Light: %+.2f | Sat: %.2f | Con: %.2f | RGB: (%.2f, %.2f, %.2f)" % [
			input_lightness, input_saturation, input_contrast, input_red, input_green, input_blue
		]

func _on_adjustment_changed() -> void:
	_update_adjustment_summary_label()
	_apply_input_adjustments_to_scene()

func set_input_adjustments(lightness: float, saturation: float, contrast: float, r: float, g: float, b: float) -> void:
	input_lightness = lightness
	input_saturation = saturation
	input_contrast = contrast
	input_red = r
	input_green = g
	input_blue = b

	if _lightness_slider:
		_lightness_slider.set_value_no_signal(lightness)
		_lightness_spin.set_value_no_signal(lightness)
		_saturation_slider.set_value_no_signal(saturation)
		_saturation_spin.set_value_no_signal(saturation)
		_contrast_slider.set_value_no_signal(contrast)
		_contrast_spin.set_value_no_signal(contrast)
		_red_slider.set_value_no_signal(r)
		_red_spin.set_value_no_signal(r)
		_green_slider.set_value_no_signal(g)
		_green_spin.set_value_no_signal(g)
		_blue_slider.set_value_no_signal(b)
		_blue_spin.set_value_no_signal(b)
		_update_adjustment_summary_label()

	_apply_input_adjustments_to_scene()

func reset_adjustments() -> void:
	set_input_adjustments(0.0, 1.0, 1.0, 1.0, 1.0, 1.0)
	_show_status("Reset input adjustments to defaults.", false)

func _apply_input_adjustments_to_scene() -> void:
	var edited_root: Node = null
	if Engine.is_editor_hint() and ClassDB.class_exists("EditorInterface"):
		var editor_iface = Engine.get_singleton("EditorInterface")
		if editor_iface and editor_iface.has_method("get_edited_scene_root"):
			edited_root = editor_iface.get_edited_scene_root()

	if not edited_root:
		var tree = Engine.get_main_loop() as SceneTree
		if tree and tree.root:
			edited_root = tree.root

	if edited_root:
		_update_mesh_adjustments_in_tree(edited_root)

func _update_mesh_adjustments_in_tree(node: Node) -> void:
	if node is PalletteSwapScreenSpaceMesh or node is PalletteSwapScreenSpaceCanvas:
		node.input_lightness = input_lightness
		node.input_saturation = input_saturation
		node.input_contrast = input_contrast
		node.input_red = input_red
		node.input_green = input_green
		node.input_blue = input_blue
	elif node is MeshInstance3D and node.material_override is ShaderMaterial:
		var sm = node.material_override as ShaderMaterial
		if sm and sm.shader:
			sm.set_shader_parameter("input_lightness", input_lightness)
			sm.set_shader_parameter("input_saturation", input_saturation)
			sm.set_shader_parameter("input_contrast", input_contrast)
			sm.set_shader_parameter("input_red", input_red)
			sm.set_shader_parameter("input_green", input_green)
			sm.set_shader_parameter("input_blue", input_blue)
	elif node is CanvasItem and node.material is ShaderMaterial:
		var sm = node.material as ShaderMaterial
		if sm and sm.shader:
			sm.set_shader_parameter("input_lightness", input_lightness)
			sm.set_shader_parameter("input_saturation", input_saturation)
			sm.set_shader_parameter("input_contrast", input_contrast)
			sm.set_shader_parameter("input_red", input_red)
			sm.set_shader_parameter("input_green", input_green)
			sm.set_shader_parameter("input_blue", input_blue)

	for child in node.get_children():
		_update_mesh_adjustments_in_tree(child)

func _sync_adjustments_from_scene() -> void:
	var edited_root: Node = null
	if Engine.is_editor_hint() and ClassDB.class_exists("EditorInterface"):
		var editor_iface = Engine.get_singleton("EditorInterface")
		if editor_iface and editor_iface.has_method("get_edited_scene_root"):
			edited_root = editor_iface.get_edited_scene_root()

	if not edited_root:
		var tree = Engine.get_main_loop() as SceneTree
		if tree and tree.root:
			edited_root = tree.root

	if edited_root:
		var target = _find_first_palette_node(edited_root)
		if target:
			set_input_adjustments(
				target.input_lightness,
				target.input_saturation,
				target.input_contrast,
				target.input_red,
				target.input_green,
				target.input_blue
			)
			return

	# Fallback: check if palette_swap.material exists in target dir
	var out_dir = _output_dir_edit.text.strip_edges() if _output_dir_edit else "res://shaders/palette_swap"
	var mat_path = out_dir.path_join("palette_swap.material")
	if FileAccess.file_exists(mat_path) or ResourceLoader.exists(mat_path):
		_sync_from_material_file(mat_path)

func _find_first_palette_node(node: Node) -> Node:
	if node is PalletteSwapScreenSpaceMesh or node is PalletteSwapScreenSpaceCanvas:
		return node
	for child in node.get_children():
		var found = _find_first_palette_node(child)
		if found:
			return found
	return null

func _find_first_mesh(node: Node) -> PalletteSwapScreenSpaceMesh:
	if node is PalletteSwapScreenSpaceMesh:
		return node
	for child in node.get_children():
		var found = _find_first_mesh(child)
		if found:
			return found
	return null

