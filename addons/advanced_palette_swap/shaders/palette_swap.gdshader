shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never, depth_test_disabled;

#include "palette.gdshaderinc"

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float dither_strength : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform int color_distance_mode : hint_enum("Perceptual OKLab:0", "Perceptual Redmean:1", "Euclidean sRGB:2", "Chromaticity (Ignore Lightness):3", "Hue Angle Only:4", "Hue Priority (Chroma-Weighted):5", "Luminance Only (Value Ramp):6", "Chroma Only:7", "Color Warmth (Cool vs Warm):8", "HSV Cylindrical:9", "HSV Hue Only:10") = 0;

// Pre-processing input adjustments before palette swap
uniform float input_lightness : hint_range(-1.0, 1.0, 0.01) = 0.0;
uniform float input_saturation : hint_range(0.0, 3.0, 0.01) = 1.0;
uniform float input_contrast : hint_range(0.0, 3.0, 0.01) = 1.0;
uniform float input_red : hint_range(0.0, 2.0, 0.01) = 1.0;
uniform float input_green : hint_range(0.0, 2.0, 0.01) = 1.0;
uniform float input_blue : hint_range(0.0, 2.0, 0.01) = 1.0;

// 4x4 Bayer matrix normalized to [-0.5, 0.5]
const float BAYER_4X4[16] = float[](
	-0.5000,  0.0000, -0.3750,  0.1250,
	 0.2500, -0.2500,  0.3750, -0.1250,
	-0.3125,  0.1875, -0.4375,  0.0625,
	 0.4375, -0.0625,  0.3125, -0.1875
);

// Converts linear RGB from screen_texture to perceptual sRGB
vec3 linear_to_srgb(vec3 c) {
	c = clamp(c, 0.0, 1.0);
	return mix(
		c * 12.92,
		1.055 * pow(c, vec3(1.0 / 2.4)) - 0.055,
		greaterThan(c, vec3(0.0031308))
	);
}

// Converts sRGB palette color to linear RGB for unshaded ALBEDO output
vec3 srgb_to_linear(vec3 c) {
	c = clamp(c, 0.0, 1.0);
	return mix(
		c / 12.92,
		pow((c + 0.055) / 1.055, vec3(2.4)),
		greaterThan(c, vec3(0.04045))
	);
}

// Converts sRGB to OKLab space for perceptually uniform color comparison
vec3 srgb_to_oklab(vec3 c) {
	vec3 lrgb = srgb_to_linear(c);
	float l = 0.4122214708 * lrgb.r + 0.5363325363 * lrgb.g + 0.0514459929 * lrgb.b;
	float m = 0.2119034982 * lrgb.r + 0.6806995451 * lrgb.g + 0.1073969566 * lrgb.b;
	float s = 0.0883024619 * lrgb.r + 0.2817188376 * lrgb.g + 0.6299787005 * lrgb.b;

	float l_ = pow(max(l, 0.0), 1.0 / 3.0);
	float m_ = pow(max(m, 0.0), 1.0 / 3.0);
	float s_ = pow(max(s, 0.0), 1.0 / 3.0);

	return vec3(
		0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
		1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
		0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_
	);
}

// Weighted Redmean distance in sRGB
float redmean_distance_sq(vec3 c1, vec3 c2) {
	vec3 diff = c1 - c2;
	float r_mean = 0.5 * (c1.r + c2.r);
	float r_weight = 2.0 + r_mean;
	float g_weight = 4.0;
	float b_weight = 2.0 + (1.0 - r_mean);
	return r_weight * diff.r * diff.r + g_weight * diff.g * diff.g + b_weight * diff.b * diff.b;
}

// Converts sRGB [0, 1] to HSV [0, 1]
vec3 srgb_to_hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

void vertex() {
	// Full-screen clip-space quad:
	// In OpenGL (Compatibility), clip-space Z is [-1, 1], so z=0.0 is center of the frustum.
	// In Vulkan (Forward+/Mobile), clip-space Z is [0, 1], so z=1.0 is the far plane.
#if defined(RENDERER_COMPATIBILITY) && CURRENT_RENDERER == RENDERER_COMPATIBILITY
	POSITION = vec4(VERTEX.xy, 0.0, 1.0);
#else
	POSITION = vec4(VERTEX.xy, OUTPUT_IS_SRGB ? 0.0 : 1.0, 1.0);
#endif
}

void fragment() {
	vec3 raw_screen = textureLod(screen_texture, SCREEN_UV, 0.0).rgb;

	// Color space handling:
	// In Compatibility mode (OpenGL), the 3D pass tonemaps and outputs directly to an sRGB buffer.
	// Therefore screen_texture is already in sRGB space and does NOT need linear_to_srgb conversion.
	// In Forward+ / Mobile (Vulkan), the buffer is linear HDR and must be converted to sRGB for color matching.
	vec3 screen_srgb;
#if defined(RENDERER_COMPATIBILITY) && CURRENT_RENDERER == RENDERER_COMPATIBILITY
	screen_srgb = raw_screen;
#else
	screen_srgb = OUTPUT_IS_SRGB ? raw_screen : linear_to_srgb(raw_screen);
#endif

	// Pre-palette input adjustments:
	// 1. Color channels (R, G, B balance)
	screen_srgb *= vec3(input_red, input_green, input_blue);

	// 2. Contrast adjustment around midpoint 0.5
	screen_srgb = (screen_srgb - vec3(0.5)) * input_contrast + vec3(0.5);

	// 3. Lightness adjustment
	screen_srgb += vec3(input_lightness);

	// 4. Saturation adjustment (mix with perceptual luminance)
	float lum = dot(screen_srgb, vec3(0.2126, 0.7152, 0.0722));
	screen_srgb = mix(vec3(lum), screen_srgb, input_saturation);

	// Clamp to [0, 1] range before dithering & palette matching
	screen_srgb = clamp(screen_srgb, 0.0, 1.0);

	// Apply Bayer dithering in perceptual sRGB space
	if (dither_strength > 0.0001) {
		ivec2 pixel_coord = ivec2(FRAGCOORD.xy);
		int bayer_index = (pixel_coord.x % 4) + (pixel_coord.y % 4) * 4;
		float dither_val = BAYER_4X4[bayer_index] * (dither_strength * (1.0 / float(max(PALETTE_SIZE, 1))));
		screen_srgb = clamp(screen_srgb + vec3(dither_val), 0.0, 1.0);
	}

	vec3 screen_oklab = srgb_to_oklab(screen_srgb);
	vec3 screen_hsv = vec3(0.0);
	if (color_distance_mode >= 9) {
		screen_hsv = srgb_to_hsv(screen_srgb);
	}

	// Find the closest palette color
	vec3 closest_srgb = PALETTE[0];
	float min_dist = 1e10;

	for (int i = 0; i < PALETTE_SIZE; i++) {
		float dist;
		if (color_distance_mode == 0) {
			// Perceptual OKLab distance
			vec3 diff = screen_oklab - PALETTE_OKLAB[i];
			dist = dot(diff, diff);
		} else if (color_distance_mode == 1) {
			// Perceptual Redmean distance
			dist = redmean_distance_sq(screen_srgb, PALETTE[i]);
		} else if (color_distance_mode == 2) {
			// Euclidean distance in sRGB
			vec3 diff = screen_srgb - PALETTE[i];
			dist = dot(diff, diff);
		} else if (color_distance_mode == 3) {
			// Chromaticity Only (Ignore Lightness): OKLab (a, b) plane
			vec2 diff_ab = screen_oklab.yz - PALETTE_OKLAB[i].yz;
			float dL = screen_oklab.x - PALETTE_OKLAB[i].x;
			dist = dot(diff_ab, diff_ab) + 0.001 * (dL * dL);
		} else if (color_distance_mode == 4) {
			// Hue Angle Only: Shortest circular distance on OKLab color wheel
			vec2 v_screen = screen_oklab.yz;
			vec2 v_pal = PALETTE_OKLAB[i].yz;
			float c_screen = length(v_screen);
			float c_pal = length(v_pal);
			float dL = screen_oklab.x - PALETTE_OKLAB[i].x;
			if (c_screen < 0.01 && c_pal < 0.01) {
				// Both are neutral / achromatic
				dist = 0.001 * (dL * dL);
			} else if (c_screen < 0.01 || c_pal < 0.01) {
				// One is neutral, the other is chromatic
				dist = 2.0 + abs(c_screen - c_pal);
			} else {
				// Angular cosine distance between unit hue vectors (ranges [0, 2])
				vec2 u_screen = v_screen / c_screen;
				vec2 u_pal = v_pal / c_pal;
				dist = 1.0 - dot(u_screen, u_pal) + 0.001 * (dL * dL);
			}
		} else if (color_distance_mode == 5) {
			// Hue Priority (Chroma-Weighted): Hue/Chroma dominates, 10% lightness weight
			float dL = screen_oklab.x - PALETTE_OKLAB[i].x;
			vec2 diff_ab = screen_oklab.yz - PALETTE_OKLAB[i].yz;
			dist = 0.1 * (dL * dL) + dot(diff_ab, diff_ab);
		} else if (color_distance_mode == 6) {
			// Luminance Only (Value Ramp): Matches strictly on perceived lightness
			float dL = screen_oklab.x - PALETTE_OKLAB[i].x;
			dist = dL * dL;
		} else if (color_distance_mode == 7) {
			// Chroma / Saturation Only: Matches strictly on color vividness vs neutral
			float c_screen = length(screen_oklab.yz);
			float c_pal = length(PALETTE_OKLAB[i].yz);
			float dC = c_screen - c_pal;
			float dL = screen_oklab.x - PALETTE_OKLAB[i].x;
			dist = dC * dC + 0.001 * (dL * dL);
		} else if (color_distance_mode == 8) {
			// Color Warmth (Cool vs Warm): Projection along warm/cool axis (0.6a + 0.8b)
			float w_screen = screen_oklab.y * 0.6 + screen_oklab.z * 0.8;
			float w_pal = PALETTE_OKLAB[i].y * 0.6 + PALETTE_OKLAB[i].z * 0.8;
			float dW = w_screen - w_pal;
			float dL = screen_oklab.x - PALETTE_OKLAB[i].x;
			dist = dW * dW + 0.01 * (dL * dL);
		} else if (color_distance_mode == 9) {
			// HSV Cylindrical distance
			vec3 pal_hsv = srgb_to_hsv(PALETTE[i]);
			float dH = min(abs(screen_hsv.x - pal_hsv.x), 1.0 - abs(screen_hsv.x - pal_hsv.x)) * 6.28318530718;
			float s1 = screen_hsv.y;
			float s2 = pal_hsv.y;
			float dV = screen_hsv.z - pal_hsv.z;
			dist = s1 * s1 + s2 * s2 - 2.0 * s1 * s2 * cos(dH) + dV * dV;
		} else {
			// Mode 10: HSV Hue Only (Circular hue distance)
			vec3 pal_hsv = srgb_to_hsv(PALETTE[i]);
			float dH = min(abs(screen_hsv.x - pal_hsv.x), 1.0 - abs(screen_hsv.x - pal_hsv.x));
			float dV = screen_hsv.z - pal_hsv.z;
			dist = dH * dH + 0.001 * (dV * dV);
		}

		if (dist < min_dist) {
			min_dist = dist;
			closest_srgb = PALETTE[i];
		}
	}

	// Output handling:
	// In Compatibility mode (OpenGL), unshaded ALBEDO is written directly to the sRGB framebuffer.
	// In Forward+ / Mobile (Vulkan), ALBEDO must be linear RGB so Godot's display pipeline produces the exact target sRGB color.
#if defined(RENDERER_COMPATIBILITY) && CURRENT_RENDERER == RENDERER_COMPATIBILITY
	ALBEDO = closest_srgb;
#else
	ALBEDO = OUTPUT_IS_SRGB ? closest_srgb : srgb_to_linear(closest_srgb);
#endif
}
