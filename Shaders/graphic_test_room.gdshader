shader_type fog;

uniform sampler2D noise_tex:repeat_enable;
uniform float noise_scale = 1.0;
uniform float flatness = 1.0;
uniform float density = 1.0;

void fog() {
	vec2 move_uv = vec2(.2, .0)*TIME;
	float detail_noise = texture(noise_tex, WORLD_POSITION.xz * noise_scale + move_uv*.5).r*.2;
	float noise = texture(noise_tex, WORLD_POSITION.xz * noise_scale + move_uv + detail_noise).r;
	DENSITY = mix(1.0, noise, UVW.y * flatness);
	DENSITY *= step(0.0, -SDF) * density;
	ALBEDO = vec3(1.0);
}