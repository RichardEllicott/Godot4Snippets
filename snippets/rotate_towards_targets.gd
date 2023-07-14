"""

still trying to find decent functions to rotate towards an target over a period of time at a linear speed (not interpolate spring like speed)


i have worked out this can't really be possible with transforms since we have to specify a time based on diatance or rotation?



it seems best to use tweens for now.... but i still wouldn't mind a function for this for security cameras or turrets?



"""


static func rotate_towards_linear(from: Basis, to: Basis, delta: float, correction = true) -> Basis:
    
    var _return: Basis = from
    
    from = from.orthonormalized() # required?
    
    # this is the full rotation we need to make, like this it would work like a spring
    var rotation_basis: Basis = to * from.inverse()
    
    # as i don't know how to make it constant any other way, i scale with inverse of the angle
    var angle_to = from.get_rotation_quaternion().angle_to(to.get_rotation_quaternion())
    angle_to = rad_to_deg(angle_to) / 360.0 # in full rotations (will make the speed more predictable)
    
    if angle_to > 0.001: # stop jitter
        if correction:
            delta /= angle_to # correct makes constant speed, by dividing with angle distance
        _return *= lerp(Basis.IDENTITY, rotation_basis, delta) # the lerp is a conviniant way of scaling a Basis's magnitude




## was using this but using simply "rotation" and "rotation_degrees" may be better?

## convert a vector to a compass direction and pitch (or tilt, angle from hozizon)
## returns as x for rotations, y for tilt
## when using with a camera feed the cameras -transform.basis.z in
## with -z we will get rotation anticlockwise
## MIGHT BE OBSOLETE IF WE USE THE "rotation_degrees" property
static func vector_to_rotations(direction: Vector3) -> Vector2:
    var rotations = Vector2(atan2(direction.x, direction.z), 0.0) # add first compass angle in radians
    direction = direction.rotated(Vector3(0,1,0), -rotations.x) # rotate to eliminate the angle
    rotations.y = atan2(direction.y, direction.z) #the tilt
    return rotations
    
static func transform_to_rotations(_transform: Transform3D) -> Vector2:
    return vector_to_rotations(-_transform.basis.z)


    
    return _return 
