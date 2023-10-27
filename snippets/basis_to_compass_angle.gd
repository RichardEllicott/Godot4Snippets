

func basis_to_compass_angle(basis: Basis):
    
    
    return -rad_to_deg(atan2(basis.z.x, basis.z.z) )
