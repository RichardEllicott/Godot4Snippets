"""

boilerplate showing SurfaceTool to make quads, and a smooth shaded tube

"""


var _surface_tool
func get_surface_tool() -> SurfaceTool:
    if not _surface_tool:
        _surface_tool = SurfaceTool.new()
        _surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
#        _surface_tool.set_smooth_group(-1) # this would make flat shading
    return _surface_tool
    
func add_vert(pos,uv_pos):
    get_surface_tool().set_uv(uv_pos)
    get_surface_tool().add_vertex(pos)

## get the final mesh, generates normals and tangents
func get_mesh() -> Mesh:
    get_surface_tool().generate_normals()
    get_surface_tool().generate_tangents()
    return get_surface_tool().commit()

## make a simple quad
func make_quad(
    nw: Vector3 = Vector3(-1, 0, -1),
    ne: Vector3 = Vector3(1, 0, -1),
    se: Vector3 = Vector3(1, 0, 1),
    sw: Vector3 = Vector3(-1, 0, 1),
    
    nw_uv: Vector2 = Vector2(0, 0),
    ne_uv: Vector2 = Vector2(1, 0),
    se_uv: Vector2 = Vector2(1, 1),
    sw_uv: Vector2 = Vector2(0, 1)
    ):
          
    # tutorial here:
    # https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/surfacetool.html
    # i don't need to make normals, calling generate breaks the normals

    # docs says required? do not seem to be !?! and may break
    #    surface_tool.generate_normals()
    #    surface_tool.generate_tangents()
    
    add_vert(se,se_uv)
    add_vert(sw,sw_uv)
    add_vert(nw,nw_uv)
    
    add_vert(nw,nw_uv)
    add_vert(ne,ne_uv)
    add_vert(se,se_uv)

## make a simple quad
func macro_test_quad():
    
#    get_surface_tool().clear()
    _surface_tool = null # need to clear surface tool for some reason

    make_quad()
#    make_cube()
    
    var mesh_instance: MeshInstance3D = get_or_create_child(self, "MeshInstance3D", MeshInstance3D)
    
    mesh_instance.mesh = get_mesh()



## make a tube of quads
func make_tube(from_points: Array, to_points: Array):
    
    var mod = from_points.size()
    
    for i in mod:
        
        var i1 = (i + 1) % mod
        
        var a = from_points[i]
        var b = from_points[i1]
        var c = to_points[i1]
        var d = to_points[i]
        
        if not flip_faces:
            make_quad(a,b,c,d)
        else:
            make_quad(d,c,b,a)

## make a smooth shaded tube
func macro_test_tube():
    
    _surface_tool = null
    
    var from_points = []
    var to_points = []
    
    for i in div:
        var theta = deg_to_rad(float(i) / float(div) * 360.0)
        
        var pos = Vector3(cos(theta), 0.0, sin(theta)) * radius
        pos *= radius
        from_points.append(pos)
        pos += Vector3(0,length,0)
        to_points.append(pos)
    
    print(from_points)
    print(to_points)
    make_tube(from_points, to_points)
    
    var mesh_instance: MeshInstance3D = get_or_create_child(self, "MeshInstance3D", MeshInstance3D)
    
    mesh_instance.mesh = get_mesh()

