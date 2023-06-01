"""

shortcut type function for one liners

grab a node child by name, but if it doesn't exist create it and also ensure it is shown in editor (works in tool scripts)


"""

## get existing or create new child node, works in tool mode to show in editor
func get_or_create_child(_parent, _name, type = Node3D) -> Node:
    var node = _parent.get_node_or_null(_name)
    if not node:
        node = type.new()
        node.name = _name
        _parent.add_child(node)
        if Engine.is_editor_hint(): # if in editor we need to do this to show in editor
            node.set_owner(get_tree().edited_scene_root)
    return node





