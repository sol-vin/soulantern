@tool
class_name PaletteImporter
extends RefCounted

## Utility class for importing various palette formats (GPL, PAL, PNG, HEX, JSON, TRES)
## and batch-converting them into native Godot PaletteResource (.tres) resources.

const PaletteResource = preload("res://addons/advanced_palette_swap/core/color_palette.gd")

## Imports a palette from any supported file format.
static func import_file(file_path: String, skip_transparent: bool = true) -> PaletteResource:
	var ext = file_path.get_extension().to_lower()
	match ext:
		"gpl":
			return import_from_gpl(file_path)
		"pal":
			return import_from_pal(file_path)
		"png":
			return import_from_png(file_path, skip_transparent)
		"hex":
			return import_from_hex(file_path)
		"json":
			return import_from_json(file_path)
		"tres":
			return PaletteResource.load_from_file(file_path)
		_:
			# Attempt generic text detection
			return import_from_pal(file_path)

## Parses a GIMP Palette (.gpl) file.
static func import_from_gpl(file_path: String) -> PaletteResource:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return null

	var content = file.get_as_text()
	file.close()

	return parse_gpl_string(content, file_path.get_file().get_basename())

## Parses GIMP Palette content from a string.
static func parse_gpl_string(content: String, default_name: String = "Untitled") -> PaletteResource:
	var lines = content.split("\n")
	var palette_name = default_name
	var comments: PackedStringArray = []
	var colors: Array[Color] = []

	var reading_data = false
	for line in lines:
		var trimmed = line.strip_edges()
		if trimmed.is_empty():
			continue

		if trimmed.begins_with("#"):
			comments.append(trimmed.substr(1).strip_edges())
			continue

		if trimmed.begins_with("GIMP Palette"):
			reading_data = true
			continue

		if trimmed.begins_with("Name:"):
			palette_name = trimmed.substr(5).strip_edges()
			continue

		if trimmed.begins_with("Columns:"):
			continue

		# Data line: R G B [optional Name]
		# Split tokens by whitespace
		var tokens = _tokenize_whitespace(trimmed)
		if tokens.size() >= 3 and tokens[0].is_valid_int() and tokens[1].is_valid_int() and tokens[2].is_valid_int():
			var r = clampi(tokens[0].to_int(), 0, 255)
			var g = clampi(tokens[1].to_int(), 0, 255)
			var b = clampi(tokens[2].to_int(), 0, 255)
			colors.append(Color8(r, g, b, 255))

	var comment_str = "\n".join(comments)
	return PaletteResource.create(palette_name, colors, "", comment_str)

## Parses a .pal file (handles JASC-PAL, RIFF PAL, or plain RGB text).
static func import_from_pal(file_path: String) -> PaletteResource:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return null

	var length = file.get_length()
	if length < 4:
		file.close()
		return null

	# Check for binary RIFF PAL signature
	var header_bytes = file.get_buffer(4)
	file.seek(0)

	if header_bytes.size() == 4 and header_bytes.get_string_from_ascii() == "RIFF":
		var riff_res = _parse_riff_pal(file, file_path.get_file().get_basename())
		file.close()
		return riff_res

	# Otherwise, parse as text (JASC-PAL or plain RGB)
	var text_content = file.get_as_text()
	file.close()
	return parse_pal_string(text_content, file_path.get_file().get_basename())

## Parses RIFF PAL binary format.
static func _parse_riff_pal(file: FileAccess, default_name: String) -> PaletteResource:
	# RIFF chunk (4 bytes "RIFF", 4 bytes size, 4 bytes "PAL ")
	file.seek(0)
	var riff_id = file.get_buffer(4).get_string_from_ascii()
	var _file_size = file.get_32()
	var pal_id = file.get_buffer(4).get_string_from_ascii()

	if riff_id != "RIFF" or pal_id != "PAL ":
		return null

	# Look for "data" chunk
	while file.get_position() < file.get_length() - 8:
		var chunk_id = file.get_buffer(4).get_string_from_ascii()
		var chunk_size = file.get_32()
		if chunk_id == "data":
			# Version (2 bytes, usually 0x0300)
			var _version = file.get_16()
			# Number of colors (2 bytes)
			var num_colors = file.get_16()
			var colors: Array[Color] = []

			for i in range(num_colors):
				if file.get_position() + 4 > file.get_length():
					break
				var r = file.get_8()
				var g = file.get_8()
				var b = file.get_8()
				var _flags = file.get_8()
				colors.append(Color8(r, g, b, 255))

			return PaletteResource.create(default_name, colors)
		else:
			# Skip unknown chunk
			file.seek(file.get_position() + chunk_size)

	return null

## Parses JASC-PAL or general RGB / hex text lines.
static func parse_pal_string(content: String, default_name: String = "Untitled") -> PaletteResource:
	var lines = content.split("\n")
	var colors: Array[Color] = []
	var palette_name = default_name

	var is_jasc = false
	var jasc_stage = 0 # 0: expecting JASC-PAL, 1: expecting 0100, 2: expecting count, 3: colors

	for line in lines:
		var trimmed = line.strip_edges()
		if trimmed.is_empty():
			continue

		if jasc_stage == 0 and trimmed == "JASC-PAL":
			is_jasc = true
			jasc_stage = 1
			continue
		elif jasc_stage == 1 and is_jasc:
			jasc_stage = 2
			continue
		elif jasc_stage == 2 and is_jasc:
			jasc_stage = 3
			continue

		# Try reading 3 integers (R G B)
		var tokens = _tokenize_whitespace(trimmed)
		if tokens.size() >= 3 and tokens[0].is_valid_int() and tokens[1].is_valid_int() and tokens[2].is_valid_int():
			var r = clampi(tokens[0].to_int(), 0, 255)
			var g = clampi(tokens[1].to_int(), 0, 255)
			var b = clampi(tokens[2].to_int(), 0, 255)
			colors.append(Color8(r, g, b, 255))
		elif trimmed.begins_with("#") or (trimmed.length() == 6 and _is_hex_string(trimmed)):
			var col = Color.from_string(trimmed, Color.BLACK)
			colors.append(col)

	return PaletteResource.create(palette_name, colors)

## Extracts all unique colors from a PNG image file in order of appearance.
static func import_from_png(file_path: String, skip_transparent: bool = true) -> PaletteResource:
	var img = Image.load_from_file(file_path)
	if not img:
		img = Image.new()
		var err = img.load(file_path)
		if err != OK or img.is_empty():
			return null

	return extract_colors_from_image(img, file_path.get_file().get_basename(), skip_transparent)

## Extracts unique colors from an Image object in order of appearance.
static func extract_colors_from_image(image: Image, palette_name: String = "Untitled", skip_transparent: bool = true) -> PaletteResource:
	if not image or image.is_empty():
		return null

	var colors: Array[Color] = []
	var seen: Dictionary = {}

	var width = image.get_width()
	var height = image.get_height()

	for y in range(height):
		for x in range(width):
			var pixel = image.get_pixel(x, y)
			if skip_transparent and pixel.a <= 0.001:
				continue

			# Round color slightly to avoid float precision duplicates
			var r = roundi(pixel.r * 255.0)
			var g = roundi(pixel.g * 255.0)
			var b = roundi(pixel.b * 255.0)
			var key = "%d,%d,%d" % [r, g, b]

			if not seen.has(key):
				seen[key] = true
				colors.append(Color8(r, g, b, 255))

	return PaletteResource.create(palette_name, colors)

## Imports a .hex palette file.
static func import_from_hex(file_path: String) -> PaletteResource:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return null

	var text = file.get_as_text()
	file.close()

	var colors: Array[Color] = []
	var lines = text.split("\n")
	for line in lines:
		var trimmed = line.strip_edges()
		if trimmed.is_empty():
			continue
		if trimmed.begins_with("#") or (trimmed.length() == 6 and _is_hex_string(trimmed)):
			var col = Color.from_string(trimmed, Color.BLACK)
			colors.append(col)

	return PaletteResource.create(file_path.get_file().get_basename(), colors)

## Imports a .json palette file.
static func import_from_json(file_path: String) -> PaletteResource:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return null

	var text = file.get_as_text()
	file.close()

	var json = JSON.new()
	if json.parse(text) != OK:
		return null

	var colors: Array[Color] = []
	var data = json.get_data()
	var pal_name = file_path.get_file().get_basename()

	if data is Dictionary:
		if data.has("name"):
			pal_name = str(data["name"])
		if data.has("colors") and data["colors"] is Array:
			for hex_val in data["colors"]:
				colors.append(Color.from_string(str(hex_val), Color.BLACK))
	elif data is Array:
		for hex_val in data:
			colors.append(Color.from_string(str(hex_val), Color.BLACK))

	return PaletteResource.create(pal_name, colors)

## Batch-imports an array of files and writes each as a .tres PaletteResource to destination_dir.
static func batch_import_files(file_paths: PackedStringArray, destination_dir: String, skip_transparent: bool = true) -> Dictionary:
	var clean_dest = destination_dir.strip_edges()
	if clean_dest.ends_with("/"):
		clean_dest = clean_dest.substr(0, clean_dest.length() - 1)
	if clean_dest.is_empty():
		clean_dest = "res://palettes"

	DirAccess.make_dir_recursive_absolute(clean_dest)

	var imported_palettes: Array[PaletteResource] = []
	var created_files: PackedStringArray = []
	var errors: Array[String] = []

	for fp in file_paths:
		var palette = import_file(fp, skip_transparent)
		if palette and not palette.is_empty():
			var base_name = _sanitize_filename(palette.palette_name)
			if base_name.is_empty():
				base_name = _sanitize_filename(fp.get_file().get_basename())
			if base_name.is_empty():
				base_name = "palette_%d" % (imported_palettes.size() + 1)

			var out_path = clean_dest.path_join(base_name + ".tres")
			# Handle duplicate names by incrementing suffix
			var counter = 1
			while FileAccess.file_exists(out_path):
				out_path = clean_dest.path_join("%s_%d.tres" % [base_name, counter])
				counter += 1

			var err = palette.save_to_file(out_path)
			if err == OK:
				imported_palettes.append(palette)
				created_files.append(out_path)
			else:
				errors.append("Failed to save .tres for '%s' (Error %d)" % [fp, err])
		else:
			errors.append("Failed to extract colors from '%s'" % fp)

	_rescan_filesystem(created_files)

	return {
		"success": imported_palettes.size() > 0,
		"total": file_paths.size(),
		"imported": imported_palettes.size(),
		"failed": file_paths.size() - imported_palettes.size(),
		"palettes": imported_palettes,
		"created_files": created_files,
		"errors": errors
	}

## Batch-imports all supported palette files in a source directory.
static func batch_import_directory(source_dir: String, destination_dir: String, recursive: bool = false, skip_transparent: bool = true) -> Dictionary:
	var files: PackedStringArray = []
	var dir = DirAccess.open(source_dir)
	if not dir:
		return {
			"success": false,
			"error": "Could not open directory '%s'" % source_dir,
			"total": 0,
			"imported": 0,
			"failed": 0,
			"created_files": PackedStringArray(),
			"errors": ["Could not open directory '%s'" % source_dir]
		}

	dir.list_dir_begin()
	var file_name = dir.get_next()
	var supported_extensions = ["gpl", "pal", "png", "hex", "json", "tres"]

	while file_name != "":
		if not file_name.begins_with("."):
			var full_path = source_dir.path_join(file_name)
			if dir.current_is_dir() and recursive:
				var sub_res = batch_import_directory(full_path, destination_dir, true, skip_transparent)
				files.append_array(sub_res.get("created_files", PackedStringArray()))
			elif not dir.current_is_dir():
				var ext = file_name.get_extension().to_lower()
				if ext in supported_extensions:
					files.append(full_path)
		file_name = dir.get_next()
	dir.list_dir_end()

	return batch_import_files(files, destination_dir, skip_transparent)

## Helper: Splits a string by any whitespace (tabs or spaces).
static func _tokenize_whitespace(text: String) -> PackedStringArray:
	var tokens: PackedStringArray = []
	var cur = ""
	for i in range(text.length()):
		var c = text[i]
		if c == " " or c == "\t" or c == "\r":
			if not cur.is_empty():
				tokens.append(cur)
				cur = ""
		else:
			cur += c
	if not cur.is_empty():
		tokens.append(cur)
	return tokens

## Helper: Checks if a string contains only valid hex characters.
static func _is_hex_string(s: String) -> bool:
	for i in range(s.length()):
		var c = s[i].to_lower()
		if not (c >= "0" and c <= "9") and not (c >= "a" and c <= "f"):
			return false
	return true

## Helper: Sanitizes a string for use as a filename.
static func _sanitize_filename(name: String) -> String:
	var valid_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-"
	var result = ""
	for i in range(name.length()):
		var c = name[i]
		if c in valid_chars:
			result += c
		elif c == " ":
			result += "_"
	return result.strip_edges()

## Helper: Rescans editor filesystem for created files.
static func _rescan_filesystem(paths: PackedStringArray = PackedStringArray()) -> void:
	if Engine.is_editor_hint() and ClassDB.class_exists("EditorInterface"):
		var fs = EditorInterface.get_resource_filesystem()
		if fs:
			for p in paths:
				if FileAccess.file_exists(p):
					fs.update_file(p)
			if paths.size() > 0:
				fs.reimport_files(paths)
			fs.scan()
