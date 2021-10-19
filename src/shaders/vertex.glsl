uniform float uTime;
varying vec3 vPosition;
varying vec3 vModelPosition;
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
    vec2 uvv = uv + uTime * 0.1;
    vec3 pos = position;
    float c = SmoothNoise(uvv * 10.0);
    c += SmoothNoise(uvv * 8.0) * 0.5;
    pos.z = c / 1.5;
    vec4 modelPosition = modelMatrix * vec4(pos, 1.0);
    gl_Position = projectionMatrix * viewMatrix * modelPosition;

    vPosition = position.xyz;
    vModelPosition = modelPosition.xyz;
    vUv = uv;
}