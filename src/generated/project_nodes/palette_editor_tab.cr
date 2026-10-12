# Generated strongly typed wrapper for GDScript node `PaletteEditorTab`
# Script Path: res://addons/advanced_palette_swap/ui/palette_editor_tab.gd
module Godot
  class PaletteEditorTab < Godot::Control
    def initialize(pointer : Void* = Pointer(Void).null)
      super(pointer)
    end

    def self.from(node : Godot::Object) : self
      new(node.pointer)
    end

    # Property `current_colors` (Void)
    def current_colors : String
      call_str("get", "current_colors")
    end

    def current_colors=(val) : Void
      call("set", "current_colors", val)
    end

    # Property `_plugin` (Godot::EditorPlugin?)
    def _plugin : Godot::EditorPlugin?
      call_obj_as(Godot::EditorPlugin, "get", "_plugin")
    end

    def _plugin=(val) : Void
      call("set", "_plugin", val)
    end

    # Property `_main_scroll` (Godot::ScrollContainer?)
    def _main_scroll : Godot::ScrollContainer?
      call_obj_as(Godot::ScrollContainer, "get", "_main_scroll")
    end

    def _main_scroll=(val) : Void
      call("set", "_main_scroll", val)
    end

    # Property `_color_filter_option` (Godot::OptionButton?)
    def _color_filter_option : Godot::OptionButton?
      call_obj_as(Godot::OptionButton, "get", "_color_filter_option")
    end

    def _color_filter_option=(val) : Void
      call("set", "_color_filter_option", val)
    end

    # Property `_selected_color_count_filter` (Int64)
    def _selected_color_count_filter : Int64
      call_i64("get", "_selected_color_count_filter")
    end

    def _selected_color_count_filter=(val) : Void
      call("set", "_selected_color_count_filter", val)
    end

    # Property `_all_palettes` (Void)
    def _all_palettes : String
      call_str("get", "_all_palettes")
    end

    def _all_palettes=(val) : Void
      call("set", "_all_palettes", val)
    end

    # Property `_preset_option` (Godot::OptionButton?)
    def _preset_option : Godot::OptionButton?
      call_obj_as(Godot::OptionButton, "get", "_preset_option")
    end

    def _preset_option=(val) : Void
      call("set", "_preset_option", val)
    end

    # Property `_preset_items` (Void)
    def _preset_items : String
      call_str("get", "_preset_items")
    end

    def _preset_items=(val) : Void
      call("set", "_preset_items", val)
    end

    # Property `_output_dir_edit` (Godot::LineEdit?)
    def _output_dir_edit : Godot::LineEdit?
      call_obj_as(Godot::LineEdit, "get", "_output_dir_edit")
    end

    def _output_dir_edit=(val) : Void
      call("set", "_output_dir_edit", val)
    end

    # Property `_status_label` (Godot::Label?)
    def _status_label : Godot::Label?
      call_obj_as(Godot::Label, "get", "_status_label")
    end

    def _status_label=(val) : Void
      call("set", "_status_label", val)
    end

    # Property `_count_label` (Godot::Label?)
    def _count_label : Godot::Label?
      call_obj_as(Godot::Label, "get", "_count_label")
    end

    def _count_label=(val) : Void
      call("set", "_count_label", val)
    end

    # Property `_spectrum_container` (Godot::HBoxContainer?)
    def _spectrum_container : Godot::HBoxContainer?
      call_obj_as(Godot::HBoxContainer, "get", "_spectrum_container")
    end

    def _spectrum_container=(val) : Void
      call("set", "_spectrum_container", val)
    end

    # Property `_spectrum_scroll` (Godot::ScrollContainer?)
    def _spectrum_scroll : Godot::ScrollContainer?
      call_obj_as(Godot::ScrollContainer, "get", "_spectrum_scroll")
    end

    def _spectrum_scroll=(val) : Void
      call("set", "_spectrum_scroll", val)
    end

    # Property `input_lightness` (Float64)
    def input_lightness : Float64
      call_f64("get", "input_lightness")
    end

    def input_lightness=(val) : Void
      call("set", "input_lightness", val)
    end

    # Property `input_saturation` (Float64)
    def input_saturation : Float64
      call_f64("get", "input_saturation")
    end

    def input_saturation=(val) : Void
      call("set", "input_saturation", val)
    end

    # Property `input_contrast` (Float64)
    def input_contrast : Float64
      call_f64("get", "input_contrast")
    end

    def input_contrast=(val) : Void
      call("set", "input_contrast", val)
    end

    # Property `input_red` (Float64)
    def input_red : Float64
      call_f64("get", "input_red")
    end

    def input_red=(val) : Void
      call("set", "input_red", val)
    end

    # Property `input_green` (Float64)
    def input_green : Float64
      call_f64("get", "input_green")
    end

    def input_green=(val) : Void
      call("set", "input_green", val)
    end

    # Property `input_blue` (Float64)
    def input_blue : Float64
      call_f64("get", "input_blue")
    end

    def input_blue=(val) : Void
      call("set", "input_blue", val)
    end

    # Property `color_distance_mode` (Int64)
    def color_distance_mode : Int64
      call_i64("get", "color_distance_mode")
    end

    def color_distance_mode=(val) : Void
      call("set", "color_distance_mode", val)
    end

    # Property `_distance_mode_option` (Godot::OptionButton?)
    def _distance_mode_option : Godot::OptionButton?
      call_obj_as(Godot::OptionButton, "get", "_distance_mode_option")
    end

    def _distance_mode_option=(val) : Void
      call("set", "_distance_mode_option", val)
    end

    # Property `_adjustments_panel` (Godot::PanelContainer?)
    def _adjustments_panel : Godot::PanelContainer?
      call_obj_as(Godot::PanelContainer, "get", "_adjustments_panel")
    end

    def _adjustments_panel=(val) : Void
      call("set", "_adjustments_panel", val)
    end

    # Property `_adjustments_content` (Godot::VBoxContainer?)
    def _adjustments_content : Godot::VBoxContainer?
      call_obj_as(Godot::VBoxContainer, "get", "_adjustments_content")
    end

    def _adjustments_content=(val) : Void
      call("set", "_adjustments_content", val)
    end

    # Property `_adjustments_toggle_btn` (Godot::Button?)
    def _adjustments_toggle_btn : Godot::Button?
      call_obj_as(Godot::Button, "get", "_adjustments_toggle_btn")
    end

    def _adjustments_toggle_btn=(val) : Void
      call("set", "_adjustments_toggle_btn", val)
    end

    # Property `_adjustments_summary_lbl` (Godot::Label?)
    def _adjustments_summary_lbl : Godot::Label?
      call_obj_as(Godot::Label, "get", "_adjustments_summary_lbl")
    end

    def _adjustments_summary_lbl=(val) : Void
      call("set", "_adjustments_summary_lbl", val)
    end

    # Property `_lightness_slider` (Godot::HSlider?)
    def _lightness_slider : Godot::HSlider?
      call_obj_as(Godot::HSlider, "get", "_lightness_slider")
    end

    def _lightness_slider=(val) : Void
      call("set", "_lightness_slider", val)
    end

    # Property `_lightness_spin` (Godot::SpinBox?)
    def _lightness_spin : Godot::SpinBox?
      call_obj_as(Godot::SpinBox, "get", "_lightness_spin")
    end

    def _lightness_spin=(val) : Void
      call("set", "_lightness_spin", val)
    end

    # Property `_saturation_slider` (Godot::HSlider?)
    def _saturation_slider : Godot::HSlider?
      call_obj_as(Godot::HSlider, "get", "_saturation_slider")
    end

    def _saturation_slider=(val) : Void
      call("set", "_saturation_slider", val)
    end

    # Property `_saturation_spin` (Godot::SpinBox?)
    def _saturation_spin : Godot::SpinBox?
      call_obj_as(Godot::SpinBox, "get", "_saturation_spin")
    end

    def _saturation_spin=(val) : Void
      call("set", "_saturation_spin", val)
    end

    # Property `_contrast_slider` (Godot::HSlider?)
    def _contrast_slider : Godot::HSlider?
      call_obj_as(Godot::HSlider, "get", "_contrast_slider")
    end

    def _contrast_slider=(val) : Void
      call("set", "_contrast_slider", val)
    end

    # Property `_contrast_spin` (Godot::SpinBox?)
    def _contrast_spin : Godot::SpinBox?
      call_obj_as(Godot::SpinBox, "get", "_contrast_spin")
    end

    def _contrast_spin=(val) : Void
      call("set", "_contrast_spin", val)
    end

    # Property `_red_slider` (Godot::HSlider?)
    def _red_slider : Godot::HSlider?
      call_obj_as(Godot::HSlider, "get", "_red_slider")
    end

    def _red_slider=(val) : Void
      call("set", "_red_slider", val)
    end

    # Property `_red_spin` (Godot::SpinBox?)
    def _red_spin : Godot::SpinBox?
      call_obj_as(Godot::SpinBox, "get", "_red_spin")
    end

    def _red_spin=(val) : Void
      call("set", "_red_spin", val)
    end

    # Property `_green_slider` (Godot::HSlider?)
    def _green_slider : Godot::HSlider?
      call_obj_as(Godot::HSlider, "get", "_green_slider")
    end

    def _green_slider=(val) : Void
      call("set", "_green_slider", val)
    end

    # Property `_green_spin` (Godot::SpinBox?)
    def _green_spin : Godot::SpinBox?
      call_obj_as(Godot::SpinBox, "get", "_green_spin")
    end

    def _green_spin=(val) : Void
      call("set", "_green_spin", val)
    end

    # Property `_blue_slider` (Godot::HSlider?)
    def _blue_slider : Godot::HSlider?
      call_obj_as(Godot::HSlider, "get", "_blue_slider")
    end

    def _blue_slider=(val) : Void
      call("set", "_blue_slider", val)
    end

    # Property `_blue_spin` (Godot::SpinBox?)
    def _blue_spin : Godot::SpinBox?
      call_obj_as(Godot::SpinBox, "get", "_blue_spin")
    end

    def _blue_spin=(val) : Void
      call("set", "_blue_spin", val)
    end

    # Property `_context_menu` (Godot::PopupMenu?)
    def _context_menu : Godot::PopupMenu?
      call_obj_as(Godot::PopupMenu, "get", "_context_menu")
    end

    def _context_menu=(val) : Void
      call("set", "_context_menu", val)
    end

    # Property `_context_menu_index` (Int64)
    def _context_menu_index : Int64
      call_i64("get", "_context_menu_index")
    end

    def _context_menu_index=(val) : Void
      call("set", "_context_menu_index", val)
    end

    # Property `_last_click_pos` (Void)
    def _last_click_pos : String
      call_str("get", "_last_click_pos")
    end

    def _last_click_pos=(val) : Void
      call("set", "_last_click_pos", val)
    end

    # Property `_picker_popup` (Godot::PopupPanel?)
    def _picker_popup : Godot::PopupPanel?
      call_obj_as(Godot::PopupPanel, "get", "_picker_popup")
    end

    def _picker_popup=(val) : Void
      call("set", "_picker_popup", val)
    end

    # Property `_popup_color_picker` (Godot::ColorPicker?)
    def _popup_color_picker : Godot::ColorPicker?
      call_obj_as(Godot::ColorPicker, "get", "_popup_color_picker")
    end

    def _popup_color_picker=(val) : Void
      call("set", "_popup_color_picker", val)
    end

    # Property `_picker_title_lbl` (Godot::Label?)
    def _picker_title_lbl : Godot::Label?
      call_obj_as(Godot::Label, "get", "_picker_title_lbl")
    end

    def _picker_title_lbl=(val) : Void
      call("set", "_picker_title_lbl", val)
    end

    # Property `_active_color_index` (Int64)
    def _active_color_index : Int64
      call_i64("get", "_active_color_index")
    end

    def _active_color_index=(val) : Void
      call("set", "_active_color_index", val)
    end

    # Property `_file_dialog` (Godot::FileDialog?)
    def _file_dialog : Godot::FileDialog?
      call_obj_as(Godot::FileDialog, "get", "_file_dialog")
    end

    def _file_dialog=(val) : Void
      call("set", "_file_dialog", val)
    end

    # Property `_save_dialog` (Godot::FileDialog?)
    def _save_dialog : Godot::FileDialog?
      call_obj_as(Godot::FileDialog, "get", "_save_dialog")
    end

    def _save_dialog=(val) : Void
      call("set", "_save_dialog", val)
    end

    # Property `_is_exporting` (Bool)
    def _is_exporting : Bool
      call_bool("get", "_is_exporting")
    end

    def _is_exporting=(val) : Void
      call("set", "_is_exporting", val)
    end

    # Property `_importer_dialog` (Godot::AcceptDialog?)
    def _importer_dialog : Godot::AcceptDialog?
      call_obj_as(Godot::AcceptDialog, "get", "_importer_dialog")
    end

    def _importer_dialog=(val) : Void
      call("set", "_importer_dialog", val)
    end

    # Property `_single_import_path_edit` (Godot::LineEdit?)
    def _single_import_path_edit : Godot::LineEdit?
      call_obj_as(Godot::LineEdit, "get", "_single_import_path_edit")
    end

    def _single_import_path_edit=(val) : Void
      call("set", "_single_import_path_edit", val)
    end

    # Property `_single_file_picker` (Godot::FileDialog?)
    def _single_file_picker : Godot::FileDialog?
      call_obj_as(Godot::FileDialog, "get", "_single_file_picker")
    end

    def _single_file_picker=(val) : Void
      call("set", "_single_file_picker", val)
    end

    # Property `_single_skip_trans_cb` (Godot::CheckBox?)
    def _single_skip_trans_cb : Godot::CheckBox?
      call_obj_as(Godot::CheckBox, "get", "_single_skip_trans_cb")
    end

    def _single_skip_trans_cb=(val) : Void
      call("set", "_single_skip_trans_cb", val)
    end

    # Property `_single_preview_lbl` (Godot::Label?)
    def _single_preview_lbl : Godot::Label?
      call_obj_as(Godot::Label, "get", "_single_preview_lbl")
    end

    def _single_preview_lbl=(val) : Void
      call("set", "_single_preview_lbl", val)
    end

    # Property `_single_preview_container` (Godot::HBoxContainer?)
    def _single_preview_container : Godot::HBoxContainer?
      call_obj_as(Godot::HBoxContainer, "get", "_single_preview_container")
    end

    def _single_preview_container=(val) : Void
      call("set", "_single_preview_container", val)
    end

    # Property `_single_loaded_palette` (Godot::PaletteResource?)
    def _single_loaded_palette : Godot::PaletteResource?
      call_obj_as(Godot::PaletteResource, "get", "_single_loaded_palette")
    end

    def _single_loaded_palette=(val) : Void
      call("set", "_single_loaded_palette", val)
    end

    # Property `_batch_src_edit` (Godot::LineEdit?)
    def _batch_src_edit : Godot::LineEdit?
      call_obj_as(Godot::LineEdit, "get", "_batch_src_edit")
    end

    def _batch_src_edit=(val) : Void
      call("set", "_batch_src_edit", val)
    end

    # Property `_batch_dest_edit` (Godot::LineEdit?)
    def _batch_dest_edit : Godot::LineEdit?
      call_obj_as(Godot::LineEdit, "get", "_batch_dest_edit")
    end

    def _batch_dest_edit=(val) : Void
      call("set", "_batch_dest_edit", val)
    end

    # Property `_batch_dir_picker` (Godot::FileDialog?)
    def _batch_dir_picker : Godot::FileDialog?
      call_obj_as(Godot::FileDialog, "get", "_batch_dir_picker")
    end

    def _batch_dir_picker=(val) : Void
      call("set", "_batch_dir_picker", val)
    end

    # Property `_batch_dest_picker` (Godot::FileDialog?)
    def _batch_dest_picker : Godot::FileDialog?
      call_obj_as(Godot::FileDialog, "get", "_batch_dest_picker")
    end

    def _batch_dest_picker=(val) : Void
      call("set", "_batch_dest_picker", val)
    end

    # Property `_batch_recursive_cb` (Godot::CheckBox?)
    def _batch_recursive_cb : Godot::CheckBox?
      call_obj_as(Godot::CheckBox, "get", "_batch_recursive_cb")
    end

    def _batch_recursive_cb=(val) : Void
      call("set", "_batch_recursive_cb", val)
    end

    # Property `_batch_skip_trans_cb` (Godot::CheckBox?)
    def _batch_skip_trans_cb : Godot::CheckBox?
      call_obj_as(Godot::CheckBox, "get", "_batch_skip_trans_cb")
    end

    def _batch_skip_trans_cb=(val) : Void
      call("set", "_batch_skip_trans_cb", val)
    end

    # Property `_batch_log_edit` (Godot::TextEdit?)
    def _batch_log_edit : Godot::TextEdit?
      call_obj_as(Godot::TextEdit, "get", "_batch_log_edit")
    end

    def _batch_log_edit=(val) : Void
      call("set", "_batch_log_edit", val)
    end

    # Property `_swatch_nodes` (Void)
    def _swatch_nodes : String
      call_str("get", "_swatch_nodes")
    end

    def _swatch_nodes=(val) : Void
      call("set", "_swatch_nodes", val)
    end

    # Method `_init` -> Void
    def _init : Void
      call("_init")
      nil
    end

    # Method `_ready` -> Void
    def _ready : Void
      call("_ready")
      nil
    end

    # Method `set_editor_plugin` -> Void
    def set_editor_plugin(plugin : Godot::EditorPlugin) : Void
      call("set_editor_plugin", plugin)
      nil
    end

    # Method `_build_ui` -> Void
    def _build_ui : Void
      call("_build_ui")
      nil
    end

    # Method `_setup_popups` -> Void
    def _setup_popups : Void
      call("_setup_popups")
      nil
    end

    # Method `_setup_importer_dialog` -> Void
    def _setup_importer_dialog : Void
      call("_setup_importer_dialog")
      nil
    end

    # Method `_refresh_palette_view` -> Void
    def _refresh_palette_view : Void
      call("_refresh_palette_view")
      nil
    end

    # Method `_update_single_swatch` -> Void
    def _update_single_swatch(idx : Int64, col : Godot::Color) : Void
      call("_update_single_swatch", idx, col)
      nil
    end

    # Method `move_color` -> Void
    def move_color(from_idx : Int64, to_idx : Int64, insert_after : Bool) : Void
      call("move_color", from_idx, to_idx, insert_after)
      nil
    end

    # Method `open_context_menu` -> Void
    def open_context_menu(index : Int64, pos : Godot::Vector2) : Void
      call("open_context_menu", index, pos)
      nil
    end

    # Method `_on_context_menu_item_pressed` -> Void
    def _on_context_menu_item_pressed(id : Int64) : Void
      call("_on_context_menu_item_pressed", id)
      nil
    end

    # Method `open_color_picker_popup` -> Void
    def open_color_picker_popup(index : Int64, pos : Godot::Vector2) : Void
      call("open_color_picker_popup", index, pos)
      nil
    end

    # Method `_on_picker_color_changed` -> Void
    def _on_picker_color_changed(new_color : Godot::Color) : Void
      call("_on_picker_color_changed", new_color)
      nil
    end

    # Method `_refresh_preset_list` -> Void
    def _refresh_preset_list : Void
      call("_refresh_preset_list")
      nil
    end

    # Method `_update_color_filter_dropdown` -> Void
    def _update_color_filter_dropdown : Void
      call("_update_color_filter_dropdown")
      nil
    end

    # Method `_on_color_filter_selected` -> Void
    def _on_color_filter_selected(index : Int64) : Void
      call("_on_color_filter_selected", index)
      nil
    end

    # Method `_update_preset_dropdown` -> Void
    def _update_preset_dropdown : Void
      call("_update_preset_dropdown")
      nil
    end

    # Method `_load_current_selected_preset` -> Void
    def _load_current_selected_preset : Void
      call("_load_current_selected_preset")
      nil
    end

    # Method `_on_preset_selected` -> Void
    def _on_preset_selected(index : Int64) : Void
      call("_on_preset_selected", index)
      nil
    end

    # Method `_load_palette_item` -> Void
    def _load_palette_item(item : Godot::Dictionary) : Void
      call("_load_palette_item", item)
      nil
    end

    # Method `_load_preset` -> Void
    def _load_preset(preset_name : String) : Void
      call("_load_preset", preset_name)
      nil
    end

    # Method `_load_tres_palette` -> Void
    def _load_tres_palette(path : String) : Void
      call("_load_tres_palette", path)
      nil
    end

    # Method `_on_add_color_pressed` -> Void
    def _on_add_color_pressed : Void
      call("_on_add_color_pressed")
      nil
    end

    # Method `_on_sort_luminance_pressed` -> Void
    def _on_sort_luminance_pressed : Void
      call("_on_sort_luminance_pressed")
      nil
    end

    # Method `_on_reverse_pressed` -> Void
    def _on_reverse_pressed : Void
      call("_on_reverse_pressed")
      nil
    end

    # Method `_on_clear_pressed` -> Void
    def _on_clear_pressed : Void
      call("_on_clear_pressed")
      nil
    end

    # Method `_on_generate_pressed` -> Void
    def _on_generate_pressed : Void
      call("_on_generate_pressed")
      nil
    end

    # Method `_refresh_screenspace_meshes` -> Void
    def _refresh_screenspace_meshes(node : Godot::Node, shader_file_path : String, material_file_path : String, canvas_shader_path : String, canvas_material_path : String) : Void
      call("_refresh_screenspace_meshes", node, shader_file_path, material_file_path, canvas_shader_path, canvas_material_path)
      nil
    end

    # Method `_on_add_mesh_to_scene_pressed` -> Void
    def _on_add_mesh_to_scene_pressed : Void
      call("_on_add_mesh_to_scene_pressed")
      nil
    end

    # Method `_on_add_canvas_to_scene_pressed` -> Void
    def _on_add_canvas_to_scene_pressed : Void
      call("_on_add_canvas_to_scene_pressed")
      nil
    end

    # Method `_on_save_tres_pressed` -> Void
    def _on_save_tres_pressed : Void
      call("_on_save_tres_pressed")
      nil
    end

    # Method `_on_save_dialog_selected` -> Void
    def _on_save_dialog_selected(path : String) : Void
      call("_on_save_dialog_selected", path)
      nil
    end

    # Method `_on_import_pressed` -> Void
    def _on_import_pressed : Void
      call("_on_import_pressed")
      nil
    end

    # Method `_on_export_pressed` -> Void
    def _on_export_pressed : Void
      call("_on_export_pressed")
      nil
    end

    # Method `_on_file_dialog_selected` -> Void
    def _on_file_dialog_selected(path : String) : Void
      call("_on_file_dialog_selected", path)
      nil
    end

    # Method `_open_importer_dialog` -> Void
    def _open_importer_dialog : Void
      call("_open_importer_dialog")
      nil
    end

    # Method `_preview_single_import` -> Void
    def _preview_single_import : Void
      call("_preview_single_import")
      nil
    end

    # Method `_load_single_to_editor` -> Void
    def _load_single_to_editor : Void
      call("_load_single_to_editor")
      nil
    end

    # Method `_save_single_as_tres` -> Void
    def _save_single_as_tres : Void
      call("_save_single_as_tres")
      nil
    end

    # Method `_run_batch_import` -> Void
    def _run_batch_import : Void
      call("_run_batch_import")
      nil
    end

    # Method `_sync_from_material_file` -> Void
    def _sync_from_material_file(mat_path : String) : Void
      call("_sync_from_material_file", mat_path)
      nil
    end

    # Method `_show_status` -> Void
    def _show_status(msg : String, is_error : Bool) : Void
      call("_show_status", msg, is_error)
      nil
    end

    # Method `_build_input_adjustments_panel` -> Godot::Control?
    def _build_input_adjustments_panel : Godot::Control?
      call_obj_as(Godot::Control, "_build_input_adjustments_panel")
    end

    # Method `_create_adjustment_control` -> Void
    def _create_adjustment_control(label_text : String, min_val : Float64, max_val : Float64, step_val : Float64, default_val : Float64, tooltip : String) : Void
      call("_create_adjustment_control", label_text, min_val, max_val, step_val, default_val, tooltip)
      nil
    end

    # Method `_toggle_adjustments_panel` -> Void
    def _toggle_adjustments_panel : Void
      call("_toggle_adjustments_panel")
      nil
    end

    # Method `_update_adjustment_summary_label` -> Void
    def _update_adjustment_summary_label : Void
      call("_update_adjustment_summary_label")
      nil
    end

    # Method `_on_adjustment_changed` -> Void
    def _on_adjustment_changed : Void
      call("_on_adjustment_changed")
      nil
    end

    # Method `set_input_adjustments` -> Void
    def set_input_adjustments(lightness : Float64, saturation : Float64, contrast : Float64, r : Float64, g : Float64, b : Float64) : Void
      call("set_input_adjustments", lightness, saturation, contrast, r, g, b)
      nil
    end

    # Method `reset_adjustments` -> Void
    def reset_adjustments : Void
      call("reset_adjustments")
      nil
    end

    # Method `_apply_input_adjustments_to_scene` -> Void
    def _apply_input_adjustments_to_scene : Void
      call("_apply_input_adjustments_to_scene")
      nil
    end

    # Method `_update_mesh_adjustments_in_tree` -> Void
    def _update_mesh_adjustments_in_tree(node : Godot::Node) : Void
      call("_update_mesh_adjustments_in_tree", node)
      nil
    end

    # Method `_sync_adjustments_from_scene` -> Void
    def _sync_adjustments_from_scene : Void
      call("_sync_adjustments_from_scene")
      nil
    end

    # Method `_find_first_palette_node` -> Godot::Node?
    def _find_first_palette_node(node : Godot::Node) : Godot::Node?
      call_obj_as(Godot::Node, "_find_first_palette_node", node)
    end

    # Method `_find_first_mesh` -> Godot::PalletteSwapScreenSpaceMesh?
    def _find_first_mesh(node : Godot::Node) : Godot::PalletteSwapScreenSpaceMesh?
      call_obj_as(Godot::PalletteSwapScreenSpaceMesh, "_find_first_mesh", node)
    end
  end
end

alias PaletteEditorTab = Godot::PaletteEditorTab
