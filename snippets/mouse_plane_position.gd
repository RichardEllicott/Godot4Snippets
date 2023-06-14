"""
get the world position of the mouse projected to a plane, good for like an RTS where the floor is always the same height

"""


## convert the mouse position (which is on the screen) to a world position on a plane
## default plane normal faces up (+y)
func get_mouse_plane_position(camera: Camera3D, mouse_position: Vector2, plane = Plane(Vector3(0,1,0))):
    # https://godotengine.org/qa/25922/how-to-get-3d-position-of-the-mouse-cursor
    var from = camera.project_ray_origin(mouse_position)
    var to = camera.project_ray_normal(mouse_position)
    return plane.intersects_ray(from, to)
