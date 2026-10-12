require "lapis"

module Soulantern
  # Visual fire effect spawned on surfaces by the projectile explosion and during dashes.
  node FireTrail < Node3D do
    enum FireColor
      BLUE
      RED
      ORANGE
    end

    @[Export]

    property burn_duration : Float32 = 1.8_f32
    @[Export]
    property fade_duration : Float32 = 0.5_f32
    @[Export]
    property fire_color : FireColor = FireColor::BLUE
    @[Export]
    property transition_to_red : Bool = false

    node_ref? light_node, OmniLight3D, "Light"
    node_ref? omni_light_node, OmniLight3D, "OmniLight3D"

    def get_light : OmniLight3D?
      light_node || omni_light_node
    end

    @timer : Float32 = 0.0_f32
    @fading : Bool = false
    @orig_scale : Vector3 = Vector3.new(1, 1, 1)

    def _ready : Void
      @orig_scale = scale
      apply_fire_color(@fire_color)
    end

    def apply_fire_color(fc : FireColor) : Void
      color = case fc
              when FireColor::BLUE
                Color.new(0.2_f32, 0.6_f32, 1.0_f32, 1.0_f32)
              when FireColor::ORANGE
                Color.new(1.0_f32, 0.55_f32, 0.15_f32, 1.0_f32)
              else
                Color.new(1.0_f32, 0.25_f32, 0.1_f32, 1.0_f32)
              end
      if l = get_light
        l.light_color = color
      end
    end

    def _process(delta : Float64) : Void
      d = delta.to_f32
      @timer += d

      if !@fading && @timer >= @burn_duration
        @fading = true
        start_fade
      end
    end

    def start_fade : Void
      tw = create_tween
      return unless tw
      tw.tween_property(self, "scale", Vector3.new(0, 0, 0), @fade_duration)
        .set_trans(Tween::TransitionType::TransSine)
      tw.finished >> ->queue_free
    end
  end
end
