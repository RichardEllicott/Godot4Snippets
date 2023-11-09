"""

patterns that now work with latest (4.1.3) where did not work so well with 4.0


"""

# cache style get a node (will save a cache, only use if node doesn't change)
var laser_mesh: MeshInstance3D:
    get:
        if not laser_mesh:
            laser_mesh = $LaserMesh
        return laser_mesh

# setting a color of say a laser, property works in editor
@export var color: Color:
    get:
        return color
    set(val):
        color = val
        laser_mesh.mesh.material.emission = color
