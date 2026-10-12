// Template palette include file for Advanced Palette Swap
// Overwritten by the code generator when palettes are updated.

#define PALETTE_SIZE 4

// sRGB Palette Colors
const vec3 PALETTE[PALETTE_SIZE] = vec3[](
	vec3(0.058824, 0.219608, 0.058824),
	vec3(0.188235, 0.384314, 0.188235),
	vec3(0.545098, 0.745098, 0.439216),
	vec3(0.878431, 0.968627, 0.815686)
);

// Precomputed OKLab values for optimal perceptual color approximation
const vec3 PALETTE_OKLAB[PALETTE_SIZE] = vec3[](
	vec3(0.245842, -0.067823, 0.052145),
	vec3(0.408215, -0.089412, 0.068214),
	vec3(0.718451, -0.112458, 0.124581),
	vec3(0.938452, -0.054128, 0.068214)
);
