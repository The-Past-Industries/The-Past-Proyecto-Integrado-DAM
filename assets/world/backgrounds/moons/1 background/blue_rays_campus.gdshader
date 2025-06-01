shader_type spatial;

render_mode blend_mix, unshaded, cull_disabled;

uniform vec4 base_color : source_color = vec4(0.2, 0.6, 1.0, 0.12); // Azul translúcido
uniform float noise_scale = 4.0;
uniform float noise_speed = 1.0;
uniform float emission_boost = 1.5;

float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    vec2 moving_uv = UV * noise_scale + vec2(0.0, TIME * noise_speed);
    float n = noise(moving_uv);
    float alpha = base_color.a * n;
    ALBEDO = base_color.rgb;
    EMISSION = base_color.rgb * (n * emission_boost);
    ALPHA = clamp(alpha, 0.0, 1.0);
}
