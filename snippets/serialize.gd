"""
example of easy saving and loading, no json problems just using Godot's systems
"""

## save filename
@export var save_path = "user://platform_land_terrain.dat"

## test vars
var a = "hello"
var b = "world"
var c = "again"

## list of vars to serialize
var serialize_vars = [
    "a",
    "b",
    "c"
]

## serialize the vars to a dictionary
func serialize() -> Dictionary:
    var data: Dictionary = {}
    for _var in serialize_vars:
        data[_var] = get(_var)
    return data
    
## deserialize the vars from a dictionary
func deserialize(data: Dictionary) -> void:
    for _var in serialize_vars:
        set(_var, data[_var])

## save the vars to a file
func save_data() -> void:
    var file = FileAccess.open(save_path, FileAccess.WRITE)
    file.store_var(serialize())

## restore the vars from a file
func load_data() -> int:
    if FileAccess.file_exists(save_path):
        var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
        deserialize(file.get_var())
        return 0
    return 1
