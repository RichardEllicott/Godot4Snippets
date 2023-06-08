


func make_quad_with_offset(offset: Vector3):
    

    var coors = [
        Vector3(0, 0, 0),
        Vector3(1, 0, 0),
        Vector3(1, 0, 1),
        Vector3(0, 0, 1),
    ]
    
    for i in coors.size():
        
        coors[i] = coors[i] + offset
        


    make_quad(
        coors[0],
        coors[1],
        coors[2],
        coors[3]
    )
    
    

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
    get_surface_tool().set_uv(uv_pos)
    get_surface_tool().add_vertex(pos)
    
    
    

var material: int = 0
## get_surface_tool().commit()
var _surface_tools = []
func get_surface_tool() -> SurfaceTool:
    
    while  material >= _surface_tools.size():
        var new = SurfaceTool.new()
        new.begin(Mesh.PRIMITIVE_TRIANGLES)
        _surface_tools.append(new)
 
    return _surface_tools[material]


@export var materials: Array[Material] = []


func get_or_create_node(_parent, _name, type = Node3D) -> Node:
    var node = _parent.get_node_or_null(_name)
    if not node:
        node = type.new()
        node.name = _name
        _parent.add_child(node)
        if Engine.is_editor_hint(): # if in editor we need to do this to show in editor
            node.set_owner(get_tree().edited_scene_root)
    return node
