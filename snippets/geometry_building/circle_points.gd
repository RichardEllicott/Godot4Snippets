"""

method for getting circle points in 3D space
  
"""


## get circle points in 3d space, circle facing z
## build the transform with an origin and basis
## for radius scale the basis:
## transform3d.basis = transform3d.basis.scaled(Vector3(1,1,1) * 2)
static func circle_points(transform3d: Transform3D, div: int) -> Array[Vector3]:
    var points: Array[Vector3] = []
    for i in div:
        var theta = deg_to_rad(float(i) / float(div) * 360.0)
        var pos = transform3d.basis.x * cos(theta) # get circle equation offsets
        pos += transform3d.basis.y * sin(theta)
        pos *= transform3d.basis.get_scale() # scale circle using the basis
        pos += transform3d.origin # offset the position to the transform.origin
        points.append(pos)
    return points
