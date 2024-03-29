"""

shortcut type function for one liners

grab a node child by name, but if it doesn't exist create it and also ensure it is shown in editor (works in tool scripts)


this make for really easy "autosetup" of nodes with script:

var node1 = get_or_create_child(self, "node1", Node3D)
var node2 = get_or_create_child(node1, "node2", Node3D)
var node3 = get_or_create_child(node1, "node2", Node3D)
var node4 = get_or_create_child(node3, "node2", Node3D)

-node1
    -node2
    -node3
        -node4


i have found by experience it is good to have a setup macro on a script, sometimes scenes break and it's hard to remeber what nodes a script requires


"""

## get existing or create new child node, works in tool mode to show in editor
static func get_or_create_child(_parent, _name, type = Node3D) -> Node:
    var child = _parent.get_node_or_null(_name)
    if not child:
        child = type.new()
        child.name = _name
        _parent.add_child(child)
        if Engine.is_editor_hint(): # if in editor we need to do this to show in editor
            child.owner = _parent.get_tree().edited_scene_root # "set_owner" not required, this code is unreliable sometimes, can't seem to be helped
    return child


## useful when using this pattern to clear old children
static func clear_children(_self: Node):
    for child in _self.get_children():
        _self.remove_child(child)
#        child.queue_free() # this would ensure it is definatly deleted even if referenced elsewhere






## the following function is used to simplify instantiating controls

## super duck typed version of my standard get_or_create_child function
##
## either returns the existing node, or spawns a new one (including in tool mode)
##
## _parent: target parent to add childs to
## _name: if this is set as a string, will try to grab and return existing child (so as not to duplicate)
##        if null, will just create a new child
## _type: accepts a built in node like Button, Node3D etc
##        or a string of a built in, like "Button", "Node3D"
##        or a PackedScene
##        or a node we will duplicate
static func get_or_create_child(_parent: Node, _name: String, _type = Node) -> Node:
    var child = _parent.get_node_or_null(_name) # attempt to get the node by name
    if child == null: # if no node, we need to create one
        
        if _type is PackedScene: # if a PackedScene, instantiate it
            child = _type.instantiate()
            
        elif _type is String: # if a string, try to match it in the ClassDB
            if ClassDB.class_exists(_type):
                child = ClassDB.instantiate(_type)
            else: # unrecognised type string
                child = Label.new() 
                push_error("unrecognised type string: \"%s\"" % _type)
        
        elif _type is Node: # if a Node, duplicate it
            child = _type.duplicate() # warning using duplicate may be less effecient
        
        else: # last assumption is a plain type and try to call "new"
            child = _type.new()
        child.name = _name
        
        _parent.add_child(child)
        # we always set the owner after adding the node to a tree if using tool mode
        child.owner = _parent.get_tree().edited_scene_root 

    return child
