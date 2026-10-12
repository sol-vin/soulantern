shader_type canvas_item;
render_mode blend_mix;

// Outline Appearance
uniform vec4 outline_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float width : hint_range(0.0, 10.0, 0.1) = 1.0;
uniform int pattern : hint_enum("Diamond / Cross (4-dir):0", "Box (8-dir):1") = 1;
uniform bool inside = false;

// Scaling & Resolution Adaptivity
uniform int pixel_scale_mode : hint_enum("Adaptive (Downscale-Safe):0", "Viewport Pixels:1", "Texture Pixels:2") = 0;
uniform bool snap_to_texel_grid = true;
uniform bool sample_raw_mip_zero = false;
uniform float alpha_threshold : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform bool modulate_outline = true;

// Calculated in vertex shader from the actual viewport transform:
// Represents the UV offset corresponding to exactly 1 viewport pixel on this canvas item.
varying vec2 v_viewport_pixel_in_uv;

void vertex() {
	// Calculate the actual transform from local 2D node coordinates to viewport pixels.
	// MODEL_MATRIX transforms local space -> canvas space.
	// CANVAS_MATRIX transforms canvas space -> viewport screen pixels.
	mat4 model_to_viewport = CANVAS_MATRIX * MODEL_MATRIX;
	vec2 scale_to_viewport = vec2(
		length(model_to_viewport[0].xy),
		length(model_to_viewport[1].xy)
	);
	scale_to_viewport = max(scale_to_viewport, vec2(0.0001));

	// 1 viewport pixel in UV space:
	v_viewport_pixel_in_uv = TEXTURE_PIXEL_SIZE / scale_to_viewport;
}

bool is_inside_uv(vec2 uv) {
	return uv.x >= 0.0 && uv.x <= 1.0 && uv.y >= 0.0 && uv.y <= 1.0;
}

float get_alpha(sampler2D tex, vec2 uv) {
	if (!is_inside_uv(uv)) {
		return 0.0;
	}
	return texture(tex, uv).a;
}

// Multi-tap sample to ensure thin features are not skipped when downscaled
float sample_alpha_max(sampler2D tex, vec2 uv, vec2 offset, bool is_downscaled) {
	float a1 = get_alpha(tex, uv + offset);
	if (is_downscaled) {
		float a2 = get_alpha(tex, uv + offset * 0.5);
		return max(a1, a2);
	}
	return a1;
}

float sample_alpha_min(sampler2D tex, vec2 uv, vec2 offset, bool is_downscaled) {
	float a1 = get_alpha(tex, uv + offset);
	if (is_downscaled) {
		float a2 = get_alpha(tex, uv + offset * 0.5);
		return min(a1, a2);
	}
	return a1;
}

const vec2 OFFSETS[8] = vec2[](
	vec2(0.0, -1.0),  // Up
	vec2(0.0, 1.0),   // Down
	vec2(-1.0, 0.0),  // Left
	vec2(1.0, 0.0),   // Right
	vec2(-1.0, -1.0), // Up-Left
	vec2(1.0, -1.0),  // Up-Right
	vec2(-1.0, 1.0),  // Down-Left
	vec2(1.0, 1.0)    // Down-Right
);

void fragment() {
	// 1. Determine viewport pixel step size in UV space taking actual viewport size into account
	vec2 viewport_pixel = v_viewport_pixel_in_uv;

	// Robust fallback: if varying was not computed or zero, try fwidth, then TEXTURE_PIXEL_SIZE
	if (viewport_pixel.x <= 0.000001 || viewport_pixel.y <= 0.000001) {
		vec2 fw = fwidth(UV);
		if (fw.x > 0.000001 && fw.y > 0.000001) {
			viewport_pixel = fw;
		} else {
			viewport_pixel = TEXTURE_PIXEL_SIZE;
		}
	}

	// 2. Determine offset step size based on mode
	vec2 step_size;
	if (pixel_scale_mode == 0) {
		// Adaptive: ensures outline is at least 1 texel AND at least 1 viewport pixel
		step_size = max(TEXTURE_PIXEL_SIZE, viewport_pixel);
	} else if (pixel_scale_mode == 1) {
		// Viewport pixels: strictly 1px in viewport regardless of item scale
		step_size = viewport_pixel;
	} else {
		// Texture pixels: strictly locked to texels (sprite art pixels)
		step_size = TEXTURE_PIXEL_SIZE;
	}
	step_size *= width;

	// Check if this item is currently downscaled on screen
	bool is_downscaled = (step_size.x > TEXTURE_PIXEL_SIZE.x * 1.25 || step_size.y > TEXTURE_PIXEL_SIZE.y * 1.25);

	// 3. Snap UV to texel center for stability at low native resolutions
	vec2 sample_uv = UV;
	if (snap_to_texel_grid && !is_downscaled) {
		sample_uv = (floor(UV / TEXTURE_PIXEL_SIZE) + 0.5) * TEXTURE_PIXEL_SIZE;
	}

	vec4 base_color = texture(TEXTURE, sample_uv);
	float current_alpha = get_alpha(TEXTURE, sample_uv);

	// Compute modulated outline color
	vec4 final_outline_color = modulate_outline ? (outline_color * COLOR) : vec4(outline_color.rgb, outline_color.a * COLOR.a);

	int num_dirs = (pattern == 1) ? 8 : 4;

	if (inside) {
		// Inside outline: draws outline along the inner perimeter of opaque pixels
		if (current_alpha > alpha_threshold) {
			float min_alpha = current_alpha;
			for (int i = 0; i < num_dirs; i++) {
				min_alpha = min(min_alpha, sample_alpha_min(TEXTURE, sample_uv, OFFSETS[i] * step_size, is_downscaled));
			}

			if (min_alpha <= alpha_threshold) {
				COLOR = final_outline_color;
			} else {
				COLOR = base_color * COLOR;
			}
		} else {
			COLOR = base_color * COLOR;
		}
	} else {
		// Outside outline: draws outline in the transparent pixels surrounding the item
		if (current_alpha <= alpha_threshold) {
			float max_alpha = 0.0;
			for (int i = 0; i < num_dirs; i++) {
				max_alpha = max(max_alpha, sample_alpha_max(TEXTURE, sample_uv, OFFSETS[i] * step_size, is_downscaled));
			}

			if (max_alpha > alpha_threshold) {
				COLOR = final_outline_color;
			} else {
				COLOR = base_color * COLOR;
			}
		} else {
			COLOR = base_color * COLOR;
		}
	}
}
