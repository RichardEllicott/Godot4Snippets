

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
