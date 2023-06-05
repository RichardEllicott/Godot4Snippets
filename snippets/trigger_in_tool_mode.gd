"""
paste in a tool script, allows triggering functions in tool mode

second sample shows enumerated macros

"""

@export var trigger_update: bool:
    set(value):
        if value and Engine.is_editor_hint():
            _ready()
            # run commands here



# hack a bool into a trigger button that works in tool mode
@export var trigger_update = false : set = set_trigger_update
func set_trigger_update(input):
    if input:
        trigger_update = false
        if Engine.is_editor_hint():
            _ready() # ensure vars are available
            # run commands here




enum Macro {
    macro01,
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

func macro01():
    pass
    
