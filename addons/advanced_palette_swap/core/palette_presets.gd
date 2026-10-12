@tool
class_name PalettePresets
extends RefCounted

## Curated collection of classic and retro limited palettes.

const PRESETS: Dictionary = {
	"Game Boy (DMG)": [
		"#0f380f", "#306230", "#8bac0f", "#9bbc0f"
	],
	"Game Boy Pocket": [
		"#2b2b26", "#706b66", "#a89f91", "#c7c4b8"
	],
	"CGA Palette 1 (High)": [
		"#000000", "#55ffff", "#ff55ff", "#ffffff"
	],
	"CGA Palette 0 (High)": [
		"#000000", "#55ff55", "#ff5555", "#ffff55"
	],
	"Pico-8": [
		"#000000", "#1D2B53", "#7E2553", "#008751",
		"#AB5236", "#5F574F", "#C2C3C7", "#FFF1E8",
		"#FF004D", "#FFA300", "#FFEC27", "#00E436",
		"#29ADFF", "#83769C", "#FF77A8", "#FFCCAA"
	],
	"Commodore 64": [
		"#000000", "#FFFFFF", "#880000", "#AAFFEE",
		"#CC44CC", "#00CC55", "#0000AA", "#EEEE77",
		"#DD8855", "#664400", "#FF7777", "#333333",
		"#777777", "#AAFF66", "#0088FF", "#BBBBBB"
	],
	"Sweetie 16": [
		"#1a1c2c", "#5d275d", "#b13e53", "#ef7d57",
		"#ffcd75", "#a7f070", "#38b764", "#257179",
		"#29366f", "#3b5dc9", "#41a6f6", "#73eff7",
		"#f4f4f4", "#94b0c2", "#566c86", "#333c57"
	],
	"Endesga 32": [
		"#be4a2f", "#d77643", "#ead4aa", "#e4a672",
		"#b86f50", "#733e39", "#3e2731", "#a22633",
		"#e43b44", "#f77622", "#feae34", "#fee761",
		"#63c74d", "#3e8948", "#265c42", "#193c3e",
		"#124e89", "#0099db", "#2ce8f5", "#ffffff",
		"#c0cbdc", "#8b9bb4", "#5a6988", "#3a4466",
		"#262b44", "#181425", "#ff0044", "#68386c",
		"#b55088", "#f6757a", "#e8b796", "#c28569"
	],
	"NES Curated": [
		"#000000", "#fcfcfc", "#f83800", "#e40058",
		"#980088", "#400098", "#0000a8", "#002888",
		"#0058f8", "#0078f8", "#008888", "#00a800",
		"#4cb000", "#8c9c00", "#ac7c00", "#e45c10"
	],
	"Solarized": [
		"#002b36", "#073642", "#586e75", "#657b83",
		"#839496", "#93a1a1", "#eee8d5", "#fdf6e3",
		"#b58900", "#cb4b16", "#dc322f", "#d33682",
		"#6c71c4", "#268bd2", "#2aa198", "#859900"
	],
	"Cyberpunk Neon": [
		"#0d0221", "#0f084b", "#26408b", "#a6cfd5",
		"#c2e7d9", "#f2545b", "#ff007f", "#00f0ff"
	],
	"1-Bit Monochrome": [
		"#000000", "#ffffff"
	],
	"Amber CRT": [
		"#120900", "#3d2000", "#995200", "#ffaa00"
	],
	"Paper & Ink": [
		"#211e1f", "#554d48", "#b8a892", "#efe7d3"
	]
}

## Returns the names of all available presets
static func get_preset_names() -> PackedStringArray:
	var names = PackedStringArray()
	for k in PRESETS.keys():
		names.append(k)
	return names

## Returns array of Color objects for a given preset name
static func get_preset_colors(preset_name: String) -> Array[Color]:
	var result: Array[Color] = []
	if not PRESETS.has(preset_name):
		return result
	
	var hex_list: Array = PRESETS[preset_name]
	for h in hex_list:
		result.append(Color.from_string(h, Color.BLACK))
	return result

const DEFAULT_PALETTES_DIR: String = "res://addons/advanced_palette_swap/default_palettes"

## Returns all .tres file paths located in the default_palettes directory
static func get_default_palette_files() -> PackedStringArray:
	var files = PackedStringArray()
	if DirAccess.dir_exists_absolute(DEFAULT_PALETTES_DIR):
		var dir = DirAccess.open(DEFAULT_PALETTES_DIR)
		if dir:
			dir.list_dir_begin()
			var fn = dir.get_next()
			while fn != "":
				if fn.ends_with(".tres"):
					files.append(DEFAULT_PALETTES_DIR.path_join(fn))
				fn = dir.get_next()
			dir.list_dir_end()
	files.sort()
	return files

