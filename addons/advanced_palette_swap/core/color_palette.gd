@tool
class_name PaletteResource
extends Resource

## Custom resource representing a discrete color palette for retro/limited color rendering.
## Can be saved and loaded as a native Godot .tres resource file.

@export var palette_name: String = "Untitled"
@export var colors: Array[Color] = []
@export var author: String = ""
@export var comment: String = ""

func _init(p_name: String = "Untitled", p_colors: Array[Color] = [], p_author: String = "", p_comment: String = "") -> void:
	palette_name = p_name
	colors = p_colors.duplicate()
	author = p_author
	comment = p_comment

func get_colors() -> Array[Color]:
	return colors

func set_colors(new_colors: Array[Color]) -> void:
	colors = new_colors.duplicate()

func size() -> int:
	return colors.size()

func is_empty() -> bool:
	return colors.is_empty()

func to_hex_array() -> PackedStringArray:
	var arr = PackedStringArray()
	for c in colors:
		arr.append(c.to_html(false).to_lower())
	return arr

func save_to_file(path: String) -> Error:
	var clean_path = path.strip_edges()
	var dir = clean_path.get_base_dir()
	if not dir.is_empty() and not DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)
	return ResourceSaver.save(self, clean_path)

static func load_from_file(path: String) -> PaletteResource:
	if not FileAccess.file_exists(path) and not ResourceLoader.exists(path):
		return null
	var res = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_REPLACE)
	if res is PaletteResource:
		return res
	return null

static func create(p_name: String, p_colors: Array[Color], p_author: String = "", p_comment: String = "") -> PaletteResource:
	return PaletteResource.new(p_name, p_colors, p_author, p_comment)
