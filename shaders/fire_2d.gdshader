shader_type canvas_item;

render_mode unshaded;

// fire uniforms
uniform float detail_strength = 3.0;
uniform float scroll_speed = 1.2;
uniform float fire_height = 1.0;
uniform float fire_shape = 1.5;
uniform float fire_thickness = 0.55;
uniform float fire_sharpness = 1.0;
uniform float intensity = 1.0;

// color uniforms
uniform vec4 color_core : source_color = vec4(1.0, 1.0, 0.7, 1.0);
uniform vec4 color_mid : source_color = vec4(1.0, 0.35, 0.0, 1.0);
uniform vec4 color_edge : source_color = vec4(0.5, 0.05, 0.0, 1.0);
uniform float color_intensity = 1.5;
uniform float color_mid_point : hint_range(0.01, 0.99, 0.01) = 0.5;
uniform bool use_color_ramp = false;
uniform sampler2D color_ramp : source_color, hint_default_black;

// emissive uniforms
uniform bool use_emissive_texture = false;
uniform sampler2D emissive_texture : source_color, hint_default_black;
uniform float emission_energy = 1.0;

// noise uniforms
uniform int noise_octaves = 6;
uniform float noise_lacunarity = 3.0;
uniform float noise_gain = 0.5;
uniform float noise_amplitude = 1.0;
uniform float noise_frequency = 1.5;

// position offset uniforms
uniform bool use_node_position = false;
uniform float node_position_scale = 0.05;

// alpha / transparency uniforms
uniform float alpha_scissor_threshold : hint_range(0.0, 1.0, 0.01) = 0.1;
uniform bool use_dither_alpha = false;

// 4x4 Bayer matrix normalized to [0.0, 1.0] for optional dithered transparency
const float BAYER_4X4[16] = float[](
	 0.0 / 16.0,  8.0 / 16.0,  2.0 / 16.0, 10.0 / 16.0,
	12.0 / 16.0,  4.0 / 16.0, 14.0 / 16.0,  6.0 / 16.0,
	 3.0 / 16.0, 11.0 / 16.0,  1.0 / 16.0,  9.0 / 16.0,
	15.0 / 16.0,  7.0 / 16.0, 13.0 / 16.0,  5.0 / 16.0
);

varying vec2 node_pos;

void vertex() {
	node_pos = MODEL_MATRIX[3].xy;
}

// 2D Value noise function
float hash(vec2 p) {
	p = fract(p * 0.3183099 + vec2(0.1, 0.1));
	p *= 17.0;
	return fract(p.x * p.y * (p.x + p.y));
}

// 2D Value noise function (smooth)
float noise(vec2 x) {
	vec2 p = floor(x);
	vec2 f = fract(x);

	float n = 
		hash(p)       * (1.0 - f.x) * (1.0 - f.y) +
		hash(p + vec2(1.0, 0.0)) * f.x * (1.0 - f.y) +
		hash(p + vec2(0.0, 1.0)) * (1.0 - f.x) * f.y +
		hash(p + vec2(1.0, 1.0)) * f.x * f.y;

	return n;
}

// Fractional Brownian Motion function (2D)
float fbm(vec2 p) {
	int octaves = noise_octaves;
 	float lacunarity = noise_lacunarity;
 	float gain = noise_gain;
 	float amplitude = noise_amplitude;
 	float frequency = noise_frequency;
	float total = 0.0;
	
	for (int i = 0; i < octaves; i++) {
		total += noise(p * frequency) * amplitude;
		frequency *= lacunarity;
		amplitude *= gain;
	}

	return total * 0.5;
}

void fragment() {
	vec2 uv = UV;

	// modified_uv for offset and animating UVs for fire    
	vec2 modified_uv = -uv;
	modified_uv.x = mod(modified_uv.x, 1.0) - 0.5;
	modified_uv.y += 0.84; // size vertical
	
	// fire noise scroll effect
	float scroll = scroll_speed * detail_strength * TIME;
	
	vec2 noise_uv = detail_strength * modified_uv - vec2(0.0, scroll);
	if (use_node_position) {
		noise_uv += node_pos * node_position_scale;
	}

	// sample noise for fire
	float noise = fbm(noise_uv);
	
	// controls the intensity of noise
	// at different points in uvs. it thus
	// controls the shape of fire
	float fire_intensity = intensity - 16.0 * fire_sharpness * pow(
		max(
			0.0,
			length(
				modified_uv * vec2((1.0 / fire_thickness) + modified_uv.y * fire_shape, 1.0 / fire_height)
			) - noise * max(0.0, modified_uv.y + 0.25)
		),
		1.2
	);
	float fire_intensity1 = noise * fire_intensity * (1.5 - pow(1.0 * uv.y, 14.0));
	fire_intensity1 = clamp(fire_intensity1, 0.0, 1.0);

	// compute fire color from uniforms or ramp
	vec3 fire_color;
	float color_alpha = 1.0;
	if (use_color_ramp) {
		vec4 ramp_sample = texture(color_ramp, vec2(fire_intensity1, 0.0));
		fire_color = ramp_sample.rgb;
		color_alpha = ramp_sample.a;
	} else {
		float mid_p = clamp(color_mid_point, 0.01, 0.99);
		if (fire_intensity1 < mid_p) {
			float t = smoothstep(0.0, mid_p, fire_intensity1);
			fire_color = mix(color_edge.rgb, color_mid.rgb, t);
			color_alpha = mix(color_edge.a, color_mid.a, t);
		} else {
			float t = smoothstep(mid_p, 1.0, fire_intensity1);
			fire_color = mix(color_mid.rgb, color_core.rgb, t);
			color_alpha = mix(color_mid.a, color_core.a, t);
		}
	}
	if (use_emissive_texture) {
		vec4 emissive_sample = texture(emissive_texture, uv);
		fire_color += emissive_sample.rgb * emission_energy;
	}
	fire_color *= color_intensity;

	// compute fire alpha test value
	float alpha = clamp(fire_intensity * (1.0 - pow(uv.y, 3.0)), 0.0, 1.0) * color_alpha;
	
	if (use_dither_alpha) {
		ivec2 pixel_coord = ivec2(FRAGCOORD.xy);
		int bayer_index = (pixel_coord.x % 4) + (pixel_coord.y % 4) * 4;
		float dither_val = BAYER_4X4[bayer_index];
		if (alpha < dither_val) {
			discard;
		}
	} else if (alpha < alpha_scissor_threshold) {
		discard;
	}

	// Fire bits are fully opaque
	vec4 final_color = vec4(
		mix(vec3(0.0), fire_color, alpha),
		1.0
	);

	COLOR = final_color;
}
