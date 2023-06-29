"""
"""


static func snap_to_grid(pos: Vector3, snap = 16.0) -> Vector3:
    pos /= snap
    pos.x = floor(pos.x)
    pos.y = floor(pos.y)
    pos.z = floor(pos.z)
    pos *= snap
    return pos
