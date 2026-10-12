require "spec"
require "lapis"

include Lapis::Test

# =============================================================================
# In-Editor Test Suite (spec/editor/editor_spec.cr)
# =============================================================================
# These tests are registered into Lapis::Test::Registry and executed live
# inside the Godot Editor through the Crystal Hub dock (Unit Test Runner tab)
# without opening or switching scenes.

test_suite "Nodes" do
  test "PlayerController is registered in ClassRegistry with on_teleport signal" do
    entry = Godot::ClassRegistry.find("PlayerController")
    assert_not_nil entry, "Expected PlayerController to be registered in ClassRegistry"
    assert_eq entry.not_nil!.parent_name, "CharacterBody3D"
    sig_names = entry.not_nil!.signals.map(&.name)
    assert_includes sig_names, "on_teleport"
  end

  test "PlayerController signal reflection in CrystalScript" do
    script = Godot.create(Godot::CrystalScript)
    assert_not_nil script, "CrystalScript instance should be created"
    if sc = script
      sc.script_class_name = "PlayerController"
      sc.sync_class_metadata

      assert_true sc.has_script_signal("on_teleport"), "Script should have 'on_teleport' signal"
      assert_true sc.signal_defs.any? { |s| s.name == "on_teleport" }, "Signal 'on_teleport' must exist in signal_defs"

      # Verify virtual call return buffer does not crash
      sc.get_script_signal_list
      sc.get_script_property_list
    end
  end

  test "PlayerController exports movement properties" do
    entry = Godot::ClassRegistry.find("PlayerController")
    assert_not_nil entry, "Expected PlayerController to be registered in ClassRegistry"
    props = entry.not_nil!.properties.map(&.name)
    assert_includes props, "forward_speed"
    assert_includes props, "max_speed"
    assert_includes props, "jump_height"
    assert_includes props, "mouse_sensitivity"
  end
end

test_case "Editor", "Godot editor environment verification" do
  assert_true Godot.editor_hint?, "Expected Godot.editor_hint? to be true when executing in-editor"
end

describe "In-Editor Test Suite" do
  it "registers in-editor test suites with Lapis::Test" do
    Registry.for_category("Nodes").should_not be_empty
    Registry.for_category("Editor").should_not be_empty
  end
end
