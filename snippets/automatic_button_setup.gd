


## get all the children recursivly
static func get_all_children(_self: Node, _children : Array[Node] = []) -> Array[Node]:
    _children.push_back(_self)
    for child in _self.get_children():
        _children = get_all_children(child, _children)
    return _children
    
## call this function with signal
func _on_button_pressed(button: Button):
    print("_on_button_pressed: ", button)
    
    var method_name = "macro_%s" % button.name # example try to call a method
    if has_method(method_name):        
        call(method_name)
        
## automaticly set up the button signals
func _ready():    
    for child in get_all_children(self):
        if child is Button:
            child.pressed.connect(_on_button_pressed.bind(child))
