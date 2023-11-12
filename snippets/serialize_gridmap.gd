"""
save a gridmap as an array of ints in the form

[x1, y1, z1, item_1, orientation_1, x2, y2, z2, item_2, orientation_2 ...

"""


static func serialize_gridmap(gridmap: GridMap) -> Array:
    var data = []
    for cell in gridmap.get_used_cells():
        data.append(cell.x)
        data.append(cell.y)
        data.append(cell.z)
        data.append(gridmap.get_cell_item(cell))
        data.append(gridmap.get_cell_item_orientation(cell))
    return data
    
static func deserialize_gridmap(gridmap: GridMap, serial_data: Array) -> void:
    var serial_size = 5 # the array is of 5 chunks
    for i in serial_data.size() / serial_size:
        var i2 = i * serial_size
        var cell = Vector3(
            serial_data[i2 + 0],
            serial_data[i2 + 1],
            serial_data[i2 + 2],
            )
        var item = serial_data[i2 + 3]
        var orientation = serial_data[i2 + 4]
        gridmap.set_cell_item(cell, item, orientation)

static func save_to_json_file(path : String, content : Dictionary, pretty: bool = true):
    var json_string = JSON.stringify(content, "  ")
    var file = FileAccess.open(path,FileAccess.WRITE)
    file.store_string(json_string)
        

static func load_from_json_file(path : String) -> Dictionary:
    var file = FileAccess.open(path,FileAccess.READ)
    var content = file.get_as_text()    
    content = JSON.parse_string(content)
    return content

var filename = "user://save_data.dat"
func macro_save_data():
    var dict = {"serial_data": serialize_gridmap(self)}
    save_to_json_file(filename, dict)

func macro_load_data():
    var data = load_from_json_file(filename)
    var serial_data = data['serial_data']
    deserialize_gridmap(self, serial_data)

func macro_clear_data():
    clear()
