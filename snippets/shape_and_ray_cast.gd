"""

query the world like for explosions

"""

## shapecast at a transform
func shapecast(_shape: Shape3D, _transform: Transform3D):
    var query = PhysicsShapeQueryParameters3D.new()
    query.transform = _transform
    query.collide_with_areas = true
    query.shape = _shape
    return get_world_3d().get_direct_space_state().intersect_shape(query)

## with a sphere
var sphere_shape
func spherecast(_transform, radius):
    if not sphere_shape:
        sphere_shape = SphereShape3D.new()
    sphere_shape.radius = _radius
    return shapecast(sphere_shape, _transform)
