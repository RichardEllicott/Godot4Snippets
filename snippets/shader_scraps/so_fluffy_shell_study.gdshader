

// BORROW FROM so_fluffy.gdshader
// https://github.com/maxmuermann/sofluffy
//
// Gold Noise ©2015 dcerisano@standard3d.com
// - based on the Golden Ratio
// - uniform normalized distribution
// - fastest static noise generator function (also runs at low precision)
// - use with indicated fractional seeding method. 
// @see https://www.shadertoy.com/view/ltB3zD

//uniform int seed = 0;

float gold_noise(vec2 p) {
    
    float seed = fract(TIME);  
    
	p = p + vec2(float(seed), float(seed));
	vec3 p3  = fract(vec3(p.xyx) * .1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}
