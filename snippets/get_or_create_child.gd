"""

shortcut type function for one liners

grab a node child by name, but if it doesn't exist create it and also ensure it is shown in editor (works in tool scripts)


"""

## Godot 4 get_or_create_child
static func get_or_create_child(parent: Node, node_name: String, node_type = Node) -> Node:        
    var child = parent.get_node_or_null(node_name) # get the node if present
    if not is_instance_valid(child): # if no node found make one
        child = node_type.new()
        child.name = node_name
        parent.add_child(child)
        if Engine.is_editor_hint():
            child.owner = parent.owner # required to spawn in editor tool mode    
    return child