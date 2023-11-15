"""

not there is already a function on Vector3: "snapped"

https://docs.godotengine.org/en/stable/classes/class_vector3.html#class-vector3-method-snapped

so i prob don't need this

"""


static func snap_to_grid(pos: Vector3, snap = 16.0) -> Vector3:
    pos /= snap
    pos.x = floor(pos.x)
    pos.y = floor(pos.y)
    pos.z = floor(pos.z)
    pos *= snap
    return pos
