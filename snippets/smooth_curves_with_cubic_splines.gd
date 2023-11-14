"""

functions to smooth out Path3Ds, allowing easy drawing of roads and railways etc

when drawing a Path3D in the editor, it will turn out with straight angles until you set the point in and out

this code does that automaticly, it makes roughly a "cubic spline" which is a sort of curve through points


LIMITATIONS: A Godot Curve3D also has an "up" or rotation, i'm not sure how to deal with that

"""


## take an array of 3d points, return a Curve3D 
static func spline_positions_to_curve(marker_positions: Array, curve_strength: float) -> Curve3D:
    
    var curve3D: Curve3D = Curve3D.new()

    for i in marker_positions.size():
        
        var pos = marker_positions[i] # curve pos
        var _in: Vector3 = Vector3() # the in and out directions (opposite for unbroken curve)
        var _out: Vector3 = Vector3()

        if i > 0 and i < marker_positions.size() - 1:
            
            var posA1: Vector3 = marker_positions[i-1]
            var posA2: Vector3 = marker_positions[i+1]
            
            var offset1: Vector3 = posA1 - pos
            var offset2: Vector3 = posA2 - pos
            
            offset1 = offset1.normalized()
            offset2 = offset2.normalized()
            
            var offset3: Vector3 = offset1
            
            offset3 -= offset2 # we add minus as it's opposite direction
            offset3 = offset3.normalized()
            
            offset3 *= curve_strength

            _in = offset3
            _out = -offset3
            
        curve3D.add_point(pos, _in, _out)

    return curve3D

## take a curve that just has points, set the beizer so it represents a "cubic spline"
## a cubic spline can be drawn by just moving points (not setting all the beizer bits manually)
static func smooth_curve(curve: Curve3D, curve_strength: float) -> Curve3D:
    var positions = []
    for i in curve.point_count:
        positions.append(curve.get_point_position(i))
    return spline_positions_to_curve(positions, curve_strength)





## new version works direct to curve, trys to work for a closed loop
## now doesn't work right with non loop (needs solution)
static func cubic_smooth_curve(curve3d: Curve3D, strength: float = 1.0) -> void:
    
    ## note currently only works properly for closed loop
    var closed_loop = true
    
    for i in curve3d.point_count:
        var i2 = (i+1) % curve3d.point_count
        var i3 = (i+2) % curve3d.point_count
        
        var prev_pos = curve3d.get_point_position(i) # prev
        var pos = curve3d.get_point_position(i2) # this
        var next_pos = curve3d.get_point_position(i3) # next
        
        var offset_prev: Vector3 = prev_pos - pos
        var offset_next: Vector3 = next_pos - pos

        offset_prev = offset_prev.normalized()
        offset_next = offset_next.normalized()
        
        # our stratergy was to add both offsets together and normalize them
        # as they are opposite we need to minus
        var in_vector: Vector3 = offset_prev - offset_next
        in_vector = in_vector.normalized()
        in_vector *= strength # then to multiply by curve strength
    
        curve3d.set_point_in(i2, in_vector)
        curve3d.set_point_out(i2, -in_vector)
    
    if closed_loop:
        # set last point in as opposite to first point out
        curve3d.set_point_in(curve3d.point_count - 1, -curve3d.get_point_out(0))




