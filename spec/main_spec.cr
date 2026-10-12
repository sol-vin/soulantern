require "spec"
require "../src/main"

describe Soulantern::PlayerController do
  it "registers with Godot ClassRegistry" do
    entry = Godot::ClassRegistry.find("PlayerController")
    entry.should_not be_nil
    entry.not_nil!.parent_name.should eq("CharacterBody3D")
  end

  it "declares exported movement properties" do
    entry = Godot::ClassRegistry.find("PlayerController")
    props = entry.not_nil!.properties.map(&.name)
    props.should contain("forward_speed")
    props.should contain("side_speed")
    props.should contain("max_speed")
    props.should contain("jump_height")
    props.should contain("gravity")
    props.should contain("friction")
    props.should contain("autohop")
    props.should contain("mouse_sensitivity")
  end

  it "declares custom signals" do
    entry = Godot::ClassRegistry.find("PlayerController")
    sigs = entry.not_nil!.signals.map(&.name)
    sigs.should contain("on_teleport")
  end
end

describe Soulantern::Lantern do
  it "registers with Godot ClassRegistry" do
    entry = Godot::ClassRegistry.find("Lantern")
    entry.should_not be_nil
    entry.not_nil!.parent_name.should eq("Node3D")
  end

  it "declares exported weapon properties" do
    entry = Godot::ClassRegistry.find("Lantern")
    props = entry.not_nil!.properties.map(&.name)
    props.should contain("rocket_jump_force")
    props.should contain("explosion_radius")
    props.should contain("max_dashes")
    props.should contain("dash_speed")
    props.should contain("dash_duration")
  end

  it "declares mobility signals" do
    entry = Godot::ClassRegistry.find("Lantern")
    sigs = entry.not_nil!.signals.map(&.name)
    sigs.should contain("rocket_jump_fired")
    sigs.should contain("dash_started")
    sigs.should contain("dash_ended")
  end
end
