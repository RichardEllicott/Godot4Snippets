"""
connecting signals, showing Godot 4 code, works in tool mode

"""


## connect signal checking without throwing an already connected error
##
## example (with persist)
## connect_signal(Button.pressed, _on_button_pressed, CONNECT_PERSIST)
##
## example (with bind):
## connect_signal(Button.pressed, _on_button_pressed.bind(1234))
##
## flags:
## https://docs.godotengine.org/en/stable/classes/class_object.html#enum-object-connectflags
##
static func connect_signal(from: Signal, to: Callable, flags: int = 0) -> void:
    if not from.is_connected(to):
        from.connect(to, flags)
