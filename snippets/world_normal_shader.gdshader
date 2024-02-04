

// to get the world normal we multiply by matrix (in fragment)
vec3 WORLD_NORMAL = (INV_VIEW_MATRIX * vec4(NORMAL.xyz, 0.0)).xyz;


// convert UV  pos to world pos (in fragment)
vec3 _VERTEX = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz; 
