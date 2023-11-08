"""

this pattern allows finding a single node in the scene (using groups), like singleton

"""


func _ready():
    add_to_group("SHMUP_GridMap", true)


var shmup_gridmap: SHMUP_GridMap:
#    get:
#        var nodes = get_tree().get_nodes_in_group("SHMUP_GridMap")
#        if nodes.size() > 0:
#            return [0]
    get:
        return get_tree().get_nodes_in_group("SHMUP_GridMap")[0]
