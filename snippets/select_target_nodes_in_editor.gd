"""

in godot 4 you can just use an export like:

export var terrain_gen: RSIT_Terrain



so far i can't get it to work in tool mode

"""


# target node as property that works in tool script (i believe the enhanced way does not)
@export var _target: NodePath = "."
var target:
    get:
        return get_node_or_null(_target)





## method for only searching childs below:

var animation_tree: AnimationTree # the node reference itself
func get_animation_tree() -> AnimationTree: # run this function first, will work in tool mode
    if not is_instance_valid(animation_tree):
        animation_tree = find_child("AnimationTree")
    return animation_tree




## my old method updated:

@export var _terrain_generator: NodePath # has a string to the target node
var terrain_generator # the node reference itself
func get_terrain_generator() -> RSIT_Terrain: # run this function first, will work in tool mode
    if not is_instance_valid(terrain_generator):
        terrain_generator = get_node_or_null(_terrain_generator) 
    return terrain_generator




## pattern works in tool mode to find a sibling of type, no export required
var terrain_generator: RSIT_Terrain
func get_terrain_generator() -> RSIT_Terrain:
    for sibling in get_parent().get_children():        
        if sibling is RSIT_Terrain:
            terrain_generator = sibling
            break
    return terrain_generator



## same with root
var terrain_generator: RSIT_Terrain
func get_terrain_generator() -> RSIT_Terrain:
    for sibling in get_tree().get_root().get_children(): # in root
        if sibling is RSIT_Terrain:
            terrain_generator = sibling
            break
    return terrain_generator





## group version is the easiest
## on target script put in _ready to ensure this is set up automaticly:
## add_to_group("RSIT_Terrain", true)
var terrain_generator: RSIT_Terrain
func get_terrain_generator() -> RSIT_Terrain:
    return get_tree().get_nodes_in_group("RSIT_Terrain")[0]


## group version with cache
## on target script put in _ready to ensure this is set up automaticly:
## add_to_group("RSIT_Terrain", true)
var terrain_generator: RSIT_Terrain
func get_terrain_generator() -> RSIT_Terrain:
    if terrain_generator == null:
        terrain_generator = get_tree().get_nodes_in_group("RSIT_Terrain")[0]
    return terrain_generator







## another idea say we want to just go up the parents... this pattern could be useful like find first parent, maybe like what unit?
static func get_keyed_parent(root: Node, key = 'is_manager389'):
    var ret
    for i in 8:
        if root.get(key):
            ret = root
            break
        root = root.get_parent()
    return ret
