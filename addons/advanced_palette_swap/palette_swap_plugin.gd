@tool
extends EditorPlugin

## Plugin entry point for Advanced Palette Swap.
## Adds the 'Palette' main screen tab and registers PalletteSwapScreenSpaceMesh.

const PaletteEditorTab = preload("res://addons/advanced_palette_swap/ui/palette_editor_tab.gd")
const ScreenSpaceMesh = preload("res://addons/advanced_palette_swap/nodes/palette_swap_screen_space_mesh.gd")
const ScreenSpaceCanvas = preload("res://addons/advanced_palette_swap/nodes/palette_swap_screen_space_canvas.gd")

var _editor_tab_instance: Control

func _enter_tree() -> void:
	var icon = preload("res://addons/advanced_palette_swap/icons/palette_icon.svg")
	add_custom_type("PalletteSwapScreenSpaceMesh", "MeshInstance3D", ScreenSpaceMesh, icon)
	add_custom_type("PalletteSwapScreenSpaceCanvas", "CanvasLayer", ScreenSpaceCanvas, icon)

	_editor_tab_instance = PaletteEditorTab.new()
	_editor_tab_instance.set_editor_plugin(self)
	
	# Add to EditorInterface main screen
	EditorInterface.get_editor_main_screen().add_child(_editor_tab_instance)
	_make_visible(false)

func _exit_tree() -> void:
	remove_custom_type("PalletteSwapScreenSpaceMesh")
	remove_custom_type("PalletteSwapScreenSpaceCanvas")
	if _editor_tab_instance:
		_editor_tab_instance.queue_free()
		_editor_tab_instance = null

func _has_main_screen() -> bool:
	return true

func _make_visible(visible: bool) -> void:
	if _editor_tab_instance:
		_editor_tab_instance.visible = visible

func _get_plugin_name() -> String:
	return "Palette"

func _get_plugin_icon() -> Texture2D:
	return preload("res://addons/advanced_palette_swap/icons/palette_icon.svg")
