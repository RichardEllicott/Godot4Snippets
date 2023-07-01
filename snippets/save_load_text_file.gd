"""
"""


static func save_text_file(filename: String, content: String) -> void:
    var file = FileAccess.open(filename, FileAccess.WRITE)
    file.store_string(content)

static func load_text_file(filename: String) -> String:
    var file = FileAccess.open(filename, FileAccess.READ)
    var content = file.get_as_text()
    return content
    
static func save_json_file(path : String, content : Dictionary, pretty: bool = true):
    save_text_file(path, JSON.stringify(content, "\t"))
    
static func load_json_file(path : String) -> Dictionary:
    return JSON.parse_string(load_text_file(path))
