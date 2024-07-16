


float get_height(vec2 pos){
    float sample1 = texture(noise1, pos + move1 * TIME).r;
    float sample2 = texture(noise2, pos + move2 * TIME).r;
    return sample1 * sample2;
}

// get a normal from the height functions, based on this code (modified from vertex)
// https://docs.godotengine.org/en/3.0/tutorials/3d/vertex_displacement_with_shaders.html
vec3 get_normal(vec2 _position, float _scale){
    vec2 _e = vec2(0.01, 0.0);
    vec3 _normal = normalize(vec3(
        get_height(_position - _e) * _scale - 
        get_height(_position + _e) * _scale, 2.0 * _e.x, 
        get_height(_position - _e.yx) * _scale - 
        get_height(_position + _e.yx) * _scale));
    return _normal;
}
