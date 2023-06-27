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




## super duck typed get_or_create_child
## _parent: target parent to add childs to
## _name: if this is set as a string, will try to grab and return existing child (so as not to duplicate)
##        if null, will just create a new child
## _type: accepts a built in node like Button, Node3D etc
##        or a string of a built in, like "Button", "Node3D"
##        or a PackedScene
static func get_or_create_child(_parent: Node, _name = null, _type = Node) -> Node:
    var child
    if _name is String:
        child = _parent.get_node_or_null(_name)
    if child == null:
        if _type is PackedScene: # packed scene just instance
            child = _type.instantiate()
        elif _type is String:            
            if ClassDB.class_exists(_type):
                child = ClassDB.instantiate(_type)
            else:
                child = Label.new()
                push_error("unrecognised type: \"%s\"" % _type)
        else:
            child = _type.new() # we assume just a plain type like Label, LineEdit or Button
        _parent.add_child(child)
    #    if Engine.is_editor_hint(): # i don't think this check is needed
        child.set_owner(_parent.get_tree().edited_scene_root)
        if _name != null:
            child.name = _name
    return child





