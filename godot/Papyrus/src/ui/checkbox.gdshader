shader_type canvas_item;

uniform bool isChecked = false;
const float outlineWidth = 0.15;

void fragment() {
	vec2 uv = UV;
	bool edge = uv.x < outlineWidth || uv.y < outlineWidth || uv.x > 1.0 - outlineWidth || uv.y > 1.0 - outlineWidth;
	bool check = abs(uv.x - uv.y) < 0.1 || abs(uv.x + uv.y - 1.0) < 0.1;

    if ((check && isChecked) || edge) {
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    } else {
		COLOR = vec4(0.0);
	}
}