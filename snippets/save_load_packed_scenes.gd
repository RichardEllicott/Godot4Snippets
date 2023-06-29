"""

saving nodes at runtime to packed scenes can be a powerful way of saving the gamestate and sending it down the network also

"""

var save_state_path = "res://save_state.tscn"


var sync_nodepath: NodePath # point to the node we want to load and replace

## pack a node to a PackedScene
func node_to_packed_scene(nodepath: NodePath) -> PackedScene:
    
    var sync = get_node(nodepath)
    
    # if the owners are not set the nodes may not be saved
    for child in sync.get_children(): 
        child.owner = sync
    
    var packed_scene = PackedScene.new()
    packed_scene.pack(sync)
    
    return packed_scene
    
    
func save_state():
    ResourceSaver.save(node_to_packed_scene(sync_nodepath), save_state_path)

## remove the node and replace it with our packed scene depacked

func packed_scene_to_node(nodepath: NodePath, packed_scene: PackedScene) -> void:
    var node = get_node(nodepath)
    var orginal_name = node.name
    var parent = node.get_parent()
    parent.remove_child(node)
    var instance = packed_scene.instantiate()
    parent.add_child(instance)
    instance.name = orginal_name
    
func load_state():
    packed_scene_to_node(sync_nodepath, load(save_state_path))
