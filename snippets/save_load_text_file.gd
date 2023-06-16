

# https://docs.godotengine.org/en/stable/classes/class_fileaccess.html
func save_text_file(filename: String, content: String) -> void:
    var file = FileAccess.open(filename, FileAccess.WRITE)
    file.store_string(content)

func load_text_file(filename: String) -> String:
    var file = FileAccess.open(filename, FileAccess.READ)
    var content = file.get_as_text()
    return content
