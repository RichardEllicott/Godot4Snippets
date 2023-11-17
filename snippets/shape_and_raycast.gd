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

## raycast
func raycast(from: Vector3, to: Vector3, exclude: Array = []):
    var query = PhysicsRayQueryParameters3D.new()
    query.from = from
    query.to = to
    query.exclude = exclude
#    query.collide_with_areas = false
#    query.collide_with_bodies = true
    return get_world_3d().get_direct_space_state().intersect_ray(query)


func raycast_mouse_position(cam: Camera3D):
    
    var space_state = get_world_3d().direct_space_state

    var mousepos = get_viewport().get_mouse_position()

    var origin = cam.project_ray_origin(mousepos)
    var end = origin + cam.project_ray_normal(mousepos) * RAY_LENGTH
    var query = PhysicsRayQueryParameters3D.create(origin, end)
    query.collide_with_areas = true
    var result = space_state.intersect_ray(query)
    return result
