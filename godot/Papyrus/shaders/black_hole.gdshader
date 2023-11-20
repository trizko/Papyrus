shader_type canvas_item;

float sdCircle(vec2 p, float r) {
    return length(p) - r;
}

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    vec3 col = vec3(0.1, 0.1, 0.1);

    float d = sdCircle(uv, 0.0);

    float timeFactor = TIME * 100.0;
    float distortion = pow(length(uv), 1.5 + timeFactor);

    uv = mix(uv, vec2(0.0, 0.0), distortion);

    d = sdCircle(uv, 0.0);

    float alpha = length(UV * 2.0 - 1.0);
    alpha = alpha > 0.9 ? 0.0 : 1.0;

    COLOR = vec4(col * d, 1.0);
}
