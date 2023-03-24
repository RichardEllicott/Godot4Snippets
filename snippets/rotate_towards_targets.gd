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
    
    return _return 