"""

shortcut type function for one liners

grab a node child by name, but if it doesn't exist create it and also ensure it is shown in editor (works in tool scripts)


this make for really easy "autosetup" of nodes with script:

var node1 = get_or_create_node(self, "node1", Node3D)
var node2 = get_or_create_node(node1, "node2", Node3D)
var node3 = get_or_create_node(node1, "node2", Node3D)
var node4 = get_or_create_node(node3, "node2", Node3D)

-node1
    -node2
    -node3
        -node4


"""
## get existing or create new child node, works in tool mode to show in editor
func get_or_create_node(_parent, _name, type = Node3D) -> Node:
    var node = _parent.get_node_or_null(_name)
    if not node:
        node = type.new()
        node.name = _name
        _parent.add_child(node)
        if Engine.is_editor_hint(): # if in editor we need to do this to show in editor
            node.set_owner(get_tree().edited_scene_root)
    return node





