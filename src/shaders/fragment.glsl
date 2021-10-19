uniform float uTime;
varying vec3 vPosition;
varying vec2 vUv;


float N21(vec2 p){
    return fract(sin(p.x * 100. + p.y * 6574.) * 5647.);
}

float SmoothNoise(vec2 uv){
    float c = N21(uv);
    vec2 localUv = fract(uv);
    localUv = localUv * localUv * (3.0 - 2.0 * localUv);
    vec2 cellId = floor(uv );
    vec3 color = vec3(c);
    float bl = N21(cellId);
    float br = N21(cellId + vec2(1.0,0.0));
    float b = mix(bl, br, localUv.x);
    float tl = N21(cellId + vec2(0.0,1.0));
    float tr = N21(cellId + vec2(1.0,1.0));
    float t = mix(tl, tr, localUv.x);

    float cc = mix(b, t, localUv.y);
    return cc;
}


void main()
{
    vec2 uvv = vUv + uTime * 0.1;

    float c = SmoothNoise(uvv * 4.0);
    c += SmoothNoise(uvv * 8.0) * 0.5;

    c /= 1.5;
    
    vec3 color = vec3(c);

    // color.rg = localUv;
    // color.rg = cellId * 0.1;

    gl_FragColor = vec4(color, 1);
}