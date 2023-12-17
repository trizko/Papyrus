shader_type canvas_item;

uniform bool useYellow = false;

float sdStar(vec2 p, float r, float n, float m)
{
    float an = 3.141593/n;
    float en = 3.141593/m;
    vec2  acs = vec2(cos(an),sin(an));
    vec2  ecs = vec2(cos(en),sin(en));

    // symmetry (optional)
    p.x = abs(p.x);
    
    // reduce to first sector
    float bn = mod(atan(p.x,p.y),2.0*an) - an;
    p = length(p)*vec2(cos(bn),abs(sin(bn)));

    // line sdf
    p -= r*acs;
    p += ecs*clamp( -dot(p,ecs), 0.0, r*acs.y/ecs.y);
    return length(p)*sign(p.x);
}

void fragment() {
    vec2 uv = vec2(UV.x * 2.0 - 1.0, 1.0 - UV.y * 2.0);

    // values to produce a 5-sided star
    float t = 8.0/3.0;
    float n = 3.0 + mod(floor(t),9.0);
    float a = fract(t);
    float w = 2.0 + a*a*(n-2.0);
    
    // sdf
    float d = sdStar(uv, 0.8, n, w);
    
    // colorize
    vec3 col = (d > 0.0) ? vec3(0.0) : vec3(1.0);
	col = (useYellow) ? vec3(1.0, 1.0, 0.0) : vec3(1.0);
	float alpha = (d > 0.0) ? 0.0 : 1.0;
    
    COLOR = vec4(col, alpha);
}
