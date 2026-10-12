require "lapis"
require "./**"

include Godot

# In non-release builds, load in-editor test suites so they register with Lapis::Test
# and appear in the Crystal Editor Hub (Unit Test Runner tab)
{% unless flag?(:release) %}
  require "../spec/editor/**"
{% end %}


# Entry point for Soulantern game library

