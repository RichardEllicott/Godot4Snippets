

// calculating normals, useful for creating liquid illusions, we can always generate a normal if we have a "height" function
// we do this by sampling our surrounding height (4 times it seems, i would have thought it could be 3!)

// if the height function here, returns a height (use any example, noise, texture etc)

float get_height(vec2 pos){
    float sample1 = texture(noise1, pos + move1 * TIME).r;
    float sample2 = texture(noise2, pos + move2 * TIME).r;
    return sample1 * sample2;
}

// then this will get the normal (but it does need to sample height 4 times, this is why normal maps exist!)

// i included scale for testing, it can lessen the normal strength

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





// confused by the above getting 4 samples, surely it should be 3?


// get a normal from the height functions, based on this code (modified from vertex)
// https://docs.godotengine.org/en/3.0/tutorials/3d/vertex_displacement_with_shaders.html
vec3 get_normal(vec2 _position, float _scale){
    //vec2 _e = vec2(0.01, 0.0);
    //vec3 _normal = normalize(vec3(
        //get_height(_position - _e) * _scale - 
        //get_height(_position + _e) * _scale, 2.0 * _e.x, 
        //get_height(_position - _e.yx) * _scale - 
        //get_height(_position + _e.yx) * _scale));
    //return _normal;
    
    // this from
    // https://docs.godotengine.org/en/stable/tutorials/shaders/your_first_shader/your_second_3d_shader.html
    // not sure why 1 works for k?
    float k = 1.0; // WEIRD THIS SEEMS SMOOTH CAN@T BE RIGHT!!
    k = get_height(_position); // gives the same error?!?! shouldn't
    
    
    return normalize(vec3(
        k - get_height(_position + vec2(0.1, 0.0)),
        0.1,
        k - get_height(_position + vec2(0.0, 0.1))));
    
}

