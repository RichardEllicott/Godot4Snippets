
// get a parralax offset on a texture, allowing us to pretend it's closer or further away
// useful to create shell shaders, clouds, internal transparency shaders etc

// can make the illusion of multiple layers of say clouds, all in one pass (using internal transparency)

void fragment() {
    vec2 uv = UV;
    //uv *= uv_scale.xy + uv_offset.xy;

    vec3 view_direction = -VERTEX * mat3(TANGENT, -BINORMAL, NORMAL);

    vec2 parallax_offset; // calculate the uv offset to give the depth illusion
    parallax_offset = view_direction.xy; // base off the view offset (not normalized)
    parallax_offset /= view_direction.z; // divided by the distance our camera is from the plane to prevent scaling distortion
    parallax_offset /= 32.0; // didvided by this to make it easier to set the pars
    parallax_offset *= layer_height;

    // we can now read the texture like:
    // texture(albdeo1, uv + parallax_offset * height)
    

    
}
