"""

shortcut type function for one liners

grab a node child by name, but if it doesn't exist create it and also ensure it is shown in editor (works in tool scripts)


"""

static func get_or_create_child(parent: Node, node_name: String, node_type = Node) -> Node:        
    var node = parent.get_node_or_null(node_name) # get the node if present
    if not is_instance_valid(node): # if no node found make one
        node = node_type.new()
        node.name = node_name
        parent.add_child(node)
        if Engine.is_editor_hint(): # if we are in tool mode
            node.set_owner(parent.get_tree().edited_scene_root) # update the actual editor scene
#    assert(node is node_type) # best to check the type matches # does not work in Godot 4
    return node