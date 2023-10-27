"""

get the angle in degrees of the compass, 0 degrees is N, 90 is E, 180 is S etc...

"""

func basis_to_compass_angle(basis: Basis):
    
    
    return -rad_to_deg(atan2(basis.z.x, basis.z.z) )
