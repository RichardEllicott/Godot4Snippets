

// to get the world normal we multiply by matrix
vec3 WORLD_NORMAL = (INV_VIEW_MATRIX * vec4(NORMAL.xyz, 0.0)).xyz;
