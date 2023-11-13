"""

functions to smooth out Path3Ds, allowing easy drawing of roads and railways etc

when drawing a Path3D in the editor, it will turn out with straight angles until you set the point in and out

this code does that automaticly, it makes roughly a "cubic spline" which is a sort of curve through points

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
