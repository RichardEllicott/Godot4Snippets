
## https://docs.godotengine.org/en/stable/tutorials/plugins/running_code_in_the_editor.html
func _ready():
    var node = Node3D.new()
    add_child(node) # Parent could be any node in the scene

    # The line below is required to make the node visible in the Scene tree dock
    # and persist changes made by the tool script to the saved scene file.
    node.set_owner(get_tree().edited_scene_root)

    # or
    node.owner = get_tree().edited_scene_root
