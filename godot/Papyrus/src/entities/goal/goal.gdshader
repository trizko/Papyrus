shader_type canvas_item;

const float dis = 0.5;
const float width = 0.1;
const float blur = 0.1;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
	vec3 lineColor = vec3(1.0, 0.75, 0.79);

	float angle = atan(uv.y, uv.x);
    float l = length(uv);
    float offset = (log(l)/log(E*5.)+(angle/(2.*PI))*dis);
    float circles = mod(offset - TIME, dis);
    vec3 col = (smoothstep(circles - blur, circles, width) - smoothstep(circles, circles + blur, width)) * lineColor;

    if (l > 1.0) COLOR = vec4(0.0);
    else COLOR = vec4(col, 1.0);
}
