"""

hard limit a vector, used to control the maxiumum speed generally

the ignore functions are useful if we limit say the x,z velocity but ignore the y (of gravity)

"""


## hard limit a vector, means it's length cannot exceed a certain length
## the ignore will ignore that axis, ie ignore y to ignore the gravity velocity
static func hard_limit_vector(
    input: Vector3,
    limit: float,
    ignore_x: bool = false,
    ignore_y: bool = false,
    ignore_z: bool = false
    ):
    
    var ret: Vector3 = input
    
    if ignore_x: ret.x = 0.0
    if ignore_y: ret.y = 0.0
    if ignore_z: ret.z = 0.0
    
    if ret.length() > limit:
        ret = ret.normalized() * limit
    
    if ignore_x: ret.x = input.x
    if ignore_y: ret.y = input.y
    if ignore_z: ret.z = input.z
        
    return ret
