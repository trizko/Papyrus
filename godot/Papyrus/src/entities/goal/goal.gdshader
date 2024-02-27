shader_type canvas_item;

const vec4 pink = vec4(1.0, 0.75, 0.79, 1.0);
const vec4 transparent = vec4(0.0);

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
	float r = length(uv);
    float theta = atan(uv.y, uv.x);  
    if (r > 1.0) {
        COLOR = transparent;
    } else {
        COLOR = fract(2.5 * theta / PI + 7.0 * pow(r, 0.4) - 1.8 * TIME) < 0.5 ? pink : transparent;
    }
}
