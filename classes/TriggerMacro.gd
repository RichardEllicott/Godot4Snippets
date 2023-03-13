"""
paste in a tool script, allows triggering functions

"""

enum Macro {
    main
   }

@export var trigger_macro = false : set = set_trigger_macro
func set_trigger_macro(input):
    if input:
        trigger_macro = false
        if Engine.is_editor_hint():
            _ready() # ensure vars are available
        call(Macro.keys()[macro])
@export var macro: Macro = 0

func _ready():
    pass

func main():
    pass