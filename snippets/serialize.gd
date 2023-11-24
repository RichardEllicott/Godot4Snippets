"""
easy saving and loading
"""


@export var save_path = "user://platform_land_terrain.dat"
#@export var save_path = "user://score.save"

var serialize_vars = [
    "grid_dimensions",
    "cliff_heights",
    "doodad_map"
]


func serialize() -> Dictionary:
    var data: Dictionary = {}
    for _var in serialize_vars:
        data[_var] = get(_var)
    return data
    
    
func deserialize(data: Dictionary):
    for _var in serialize_vars:
        set(_var, data[_var])


func save_data():
    var file = FileAccess.open(save_path, FileAccess.WRITE)
    file.store_var(serialize())
    
func load_data():
    if FileAccess.file_exists(save_path):
        var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
        deserialize(file.get_var())
        _build_terrain()
