"""
"""
child.pressed.connect(_on_button_pressed.bind(child))

static func connect_signal(from: Signal, to: Callable) -> void:
    if not from.is_connected(to):
        from.connect(to)
        


## shows binding a parameter, in this case 1234 to the be called on the method
child.pressed.connect(_on_button_pressed.bind(1234))
