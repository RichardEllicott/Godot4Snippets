"""
simple save/load data

user://
res://


"""

## standard text file
static func save_text_file(path: String, content: String) -> void:
    var file = FileAccess.open(path, FileAccess.WRITE)
    file.store_string(content)

static func load_text_file(path: String) -> String:
    var text: String = ""
    if FileAccess.file_exists(path):
        var file = FileAccess.open(path, FileAccess.READ)
        text = file.get_as_text()
    return text

## json example
static func save_json_file(path : String, content : Dictionary, pretty: bool = true) -> void:
    save_text_file(path, JSON.stringify(content, "\t"))
    
static func load_json_file(path : String) -> Dictionary:
    return JSON.parse_string(load_text_file(path))
    
## godot's built in serialize (more flexible and easy)
static func save_var_file(path: String, content) -> void:
    var file = FileAccess.open(path, FileAccess.WRITE)
    file.store_var(content)

static func load_var_file(path: String, content):
    if FileAccess.file_exists(path):
        var file = FileAccess.open(path, FileAccess.READ)
        return file.get_var()
