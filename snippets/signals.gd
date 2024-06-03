"""
"""

## normal syntax
child.pressed.connect(_on_button_pressed.bind(child))
child.pressed.connect(_on_button_pressed.bind(1234)) # binds a par here


## connect signal checking the signal is not already connected (as it throws an error)
##
## example (with bind):
## connect_signal(Button.pressed, _on_button_pressed.bind(1234))
##
static func connect_signal(from: Signal, to: Callable) -> void:
    if not from.is_connected(to):
        from.connect(to)
