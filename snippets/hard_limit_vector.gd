"""

hard limit a vector, used to control the maxiumum speed generally

the ignore functions are useful if we limit say the x,z velocity but ignore the y (of gravity)

"""



## hard limit a vector, means it's length cannot exceed a certain length
## the ignore will ignore that axis, ie ignore y to ignore the gravity velocity
static func hard_limit_vector(
    vector: Vector3,
    limit: float,
    ignore_x: bool = false,
    ignore_y: bool = false,
    ignore_z: bool = false
    ) -> Vector3:
        
    # create return vector
    var new_vector: Vector3 = vector
    
    # 0 the ignored axis
    if ignore_x: new_vector.x = 0.0 
    if ignore_y: new_vector.y = 0.0
    if ignore_z: new_vector.z = 0.0
    
    # if longer than limit set to limit
    if new_vector.length() > limit: new_vector = new_vector.normalized() * limit 
    
    # put back ignored axis
    if ignore_x: new_vector.x = vector.x 
    if ignore_y: new_vector.y = vector.y
    if ignore_z: new_vector.z = vector.z
        
    return new_vector
