"""

this pattern allows finding a single node in the scene (using groups), like singleton

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



## with cache?
var shmup_gridmap: SHMUP_GridMap:
    get:
        if not shmup_gridmap:
            var nodes = get_tree().get_nodes_in_group("SHMUP_GridMap")
            if nodes.size() > 0:
                shmup_gridmap = nodes[0]
        return shmup_gridmap
#    get:
#        return get_tree().get_nodes_in_group("SHMUP_GridMap")[0]
