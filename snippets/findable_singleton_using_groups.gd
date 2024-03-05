"""

this pattern allows finding a single node in the scene (using groups), like singleton

i'm often using groups to find singletons as the pattern is decoupled

"""

func _ready():
    add_to_group("SHMUP_GridMap", true) # put this on the findable node (or set group in editor)


# crash if no result
var shmup_gridmap: SHMUP_GridMap:
    get:
        return get_tree().get_nodes_in_group("SHMUP_GridMap")[0]



var shmup_gridmap: SHMUP_GridMap:
    get:
        var ret
        var nodes = get_tree().get_nodes_in_group("SHMUP_GridMap")
        if nodes.size() > 0:
            ret = nodes[0]
        return ret
#    get:
#        return get_tree().get_nodes_in_group("SHMUP_GridMap")[0]



## cache (should be faster, do not change singleton)
var grid_map: GridMap:
    get:
        if not grid_map:
            var nodes = get_tree().get_nodes_in_group("GRIDMAP")
            if nodes.size() > 0:
                grid_map = nodes[0]
        return grid_map
