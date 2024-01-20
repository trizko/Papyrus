shader_type canvas_item;

float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    vec3 col = vec3(0.1, 0.1, 0.1);
	
	float d = sdCircle(uv, 0.0);

    // constrain alpha based on length of uv
    float alpha = length(uv);
    alpha = alpha > 0.9 ? 0.0 : 1.0;
    
    COLOR = vec4(col*d, alpha);
}
