"""

this pattern allows finding a single node in the scene (using groups), like singleton

i'm often using groups to find singletons as the pattern is decoupled

"""

func _ready():
    add_to_group("SHMUP_GridMap", true) # put this on the findable node (or set group in editor)

# minimal, crash if no result!
var doom_ed2_manager: DoomEd2Manager:
    get:
        if not doom_ed2_manager:
            doom_ed2_manager = get_tree().get_nodes_in_group("DoomEd2Manager")[0]
        return doom_ed2_manager


# with error
var doom_ed2_manager: DoomEd2Manager:
    get:
        if not doom_ed2_manager:
            var nodes = get_tree().get_nodes_in_group("DoomEd2Manager")
            if nodes.size() != 1:
                push_error("DoomEd2Manager singleton not founf!")
            doom_ed2_manager = nodes[0]
        return doom_ed2_manager



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
