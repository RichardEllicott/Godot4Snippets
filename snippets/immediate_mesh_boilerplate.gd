"""

ImmediateMesh is designed for realtime animation with less verts

normals need to be calculated manually


"""


## this function is absent in ImmediateMesh, drawing a triangle fan is a quick way to draw ngons

static func add_triangle_fan(mesh: ImmediateMesh, vertices: PackedVector3Array, uvs: PackedVector2Array, normals: PackedVector3Array):
    
    var a = vertices[0] # one position always the same, cache it why not
    var a_uv = uvs[0]
    var a_normal = normals[0]
    
    for i in vertices.size() - 2:
        var i1 = i + 1
        var i2 = i + 2
        mesh.surface_set_normal(a_normal) # point a is the first point
        mesh.surface_set_uv(a_uv)
        mesh.surface_add_vertex(a)
        mesh.surface_set_normal(normals[i1]) # point b is +1 to i
        mesh.surface_set_uv(uvs[i1])
        mesh.surface_add_vertex(vertices[i1])
        mesh.surface_set_normal(normals[i2]) # point b with c forms one of the edges of the polygon
        mesh.surface_set_uv(uvs[i2])
        mesh.surface_add_vertex(vertices[i2])


## demo

var mesh: ImmediateMesh 
func make_quad():
    
    var verts = [
        Vector3(-1, 0, -1),
        Vector3(1, 0, -1),
        Vector3(1, 0, 1),
        Vector3(-1, 0, 1)
    ]
    
    var uvs = [
        Vector2(0, 0),
        Vector2(1, 0),
        Vector2(1, 1),
        Vector2(0, 1)
    ]
    var normals = [
        Vector3(0,1,0),
        Vector3(0,1,0),
        Vector3(0,1,0),
        Vector3(0,1,0)
    ]
    
    add_triangle_fan(mesh, verts, uvs, normals)

func macro_test():
    
    var mesh_instance3d = $MeshInstance3D
    mesh_instance3d.mesh = ImmediateMesh.new()
    mesh = mesh_instance3d.mesh
    
    mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
    make_quad()
    mesh.surface_end()


