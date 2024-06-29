

# deg_to_rad functions for vectors:
  
static func vec3_deg_to_rad(input: Vector3) -> Vector3:
    return Vector3(deg_to_rad(input.x),deg_to_rad(input.y),deg_to_rad(input.z))
    
static func vec3_rad_to_deg(input: Vector3) -> Vector3:
    return Vector3(rad_to_deg(input.x),rad_to_deg(input.y),rad_to_deg(input.z))
    
static func vec2_deg_to_rad(input: Vector2) -> Vector2:
    return Vector2(deg_to_rad(input.x),deg_to_rad(input.y))
    #
static func vec2_rad_to_deg(input: Vector2) -> Vector2:
    return Vector2(rad_to_deg(input.x),rad_to_deg(input.y))
