"""

converting degress to radians etc for vectors (deg_to_rad fucntion doesn't work for these)

either paste function of cut out the code for one liners
"""
  
static func vec3_deg_to_rad(input: Vector3) -> Vector3:
    return Vector3(deg_to_rad(input.x),deg_to_rad(input.y),deg_to_rad(input.z))
    
static func vec3_rad_to_deg(input: Vector3) -> Vector3:
    return Vector3(rad_to_deg(input.x),rad_to_deg(input.y),rad_to_deg(input.z))
    
static func vec2_deg_to_rad(input: Vector2) -> Vector2:
    return Vector2(deg_to_rad(input.x),deg_to_rad(input.y))
    #
static func vec2_rad_to_deg(input: Vector2) -> Vector2:
    return Vector2(rad_to_deg(input.x),rad_to_deg(input.y))



## example property, showing setting in degrees but the code will use the radians (simplfies the underlying code to not convert values)

@export var rotation_speed: Vector3 = Vector3(0.0, 0.5, 0.0)

@export var rotation_speed_degreees: Vector3:
    get:
        return Vector3(
            rad_to_deg(rotation_speed.x),
            rad_to_deg(rotation_speed.y),
            rad_to_deg(rotation_speed.z)
            )
    set(value):
        rotation_speed.x = deg_to_rad(value.x)
        rotation_speed.y = deg_to_rad(value.y)
        rotation_speed.z = deg_to_rad(value.z)
