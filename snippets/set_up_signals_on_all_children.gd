


static func get_all_children(_self: Node, _children : Array[Node] = []) -> Array[Node]:
    _children.push_back(_self)
    for child in _self.get_children():
        _children = get_all_children(child, _children)
    return _children
    
# any child button pressed
func _on_button_pressed(button: Button) -> void:    
    var method_name = "macro_%s" % button.name # example try to call a method
    if has_method(method_name):        
        call(method_name)

## find all children, set a automatic signal
func set_up_button_signals() -> void:
    
    var debug_buttons = get_node_or_null(debug_buttons_path)
    
    if debug_buttons:
        for child in get_all_children(debug_buttons):
            if child is Button:
                if not child.pressed.is_connected(_on_button_pressed):
                    child.pressed.connect(_on_button_pressed.bind(child))
