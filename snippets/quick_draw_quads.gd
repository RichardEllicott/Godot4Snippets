"""

fast boilerplate for SurfaceTool, which is probabally ones of the easiest way to draw meshes (it does the normals automaticly)

making the boilerplate functions like this allows fast typing for drawing the geometry with simple commands like "make_quad"

"""

## easy make quad function, by default makes a 2x2 quad plane on the floor
## set the first var as a 6 or 8 item array to represent the entire quad/triangle as an array of Vector3 and Vector2's
func make_quad(
    nw = Vector3(-1, 0, -1),
    ne = Vector3(1, 0, -1),
    se = Vector3(1, 0, 1),
    sw = Vector3(-1, 0, 1),
    
    nw_uv = Vector2(0, 0),
    ne_uv = Vector2(1, 0),
    se_uv = Vector2(1, 1),
    sw_uv = Vector2(0, 1),
    ):
    
    if nw is Array:
        var array: Array = nw
        if array.size() == 8: # must be a quad with UV
            
            nw = array[0]
            ne = array[1]
            se = array[2]
            sw = array[3]
            
            nw_uv = array[4]
            ne_uv = array[5]
            se_uv = array[6]
            sw_uv = array[7]
        
        elif array.size() == 6: # must be a triangle with UV
            
            nw = array[0]
            ne = array[1]
            se = array[2]
            sw = null
            
            nw_uv = array[3]
            ne_uv = array[4]
            se_uv = array[5]
            sw_uv = null
            
        else:
            assert(false)
  
    # tutorial here:
    # https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/surfacetool.html
    # i don't need to make normals, calling generate breaks the normals

    # docs says required? do not seem to be !?! and may break
    #    surface_tool.generate_normals()
    #    surface_tool.generate_tangents()

    if sw != null:
        add_vertex(se, se_uv)
        add_vertex(sw, sw_uv)
        add_vertex(nw, nw_uv)
    
    add_vertex(nw, nw_uv)
    add_vertex(ne, ne_uv)
    add_vertex(se, se_uv)
    
    
func add_vertex(pos, uv_pos):
    get_surface_tool()
    surface_tool.set_uv(uv_pos)
    surface_tool.add_vertex(pos)
    
## get_surface_tool().commit() will provide a mesh back... set a MeshInstance3D's mesh to this mesh to show your geometry
var surface_tool
func get_surface_tool() -> SurfaceTool:
    if not surface_tool:
        surface_tool = SurfaceTool.new()
        surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
    return surface_tool
