shader_type canvas_item;

uniform bool isChecked = false;
const float outlineWidth = 0.15;

void fragment() {
    vec2 uv = UV;
    bool isEdge = uv.x < outlineWidth || uv.y < outlineWidth || uv.x > 1.0 - outlineWidth || uv.y > 1.0 - outlineWidth;

    if (isChecked) {
        if (abs(uv.x - uv.y) < 0.1 || abs(uv.x + uv.y - 1.0) < 0.1) {
            COLOR = vec4(0.0, 0.0, 0.0, 1.0);
        }
    }
    if (isEdge) {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    }
}