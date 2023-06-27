"""
paste in a tool script, allows triggering functions in tool mode

second sample shows enumerated macros



node.set_owner(get_tree().edited_scene_root)

"""

# makes a bool work like a button in the editor (requires a tool script)

@export var trigger_update: bool:
    set(value):
        if value and Engine.is_editor_hint():
            _ready()


# trigger some macros that run methods on the body with reflection

enum Macro{
    test1,
    test2,
    test3
}

@export var macro: Macro = Macro.test1: # this is my personal choice of new get/set property syntax
    get:
        return macro
    set(value):
        macro = value
        call(Macro.keys()[macro])

func test1():
    print("test1...")

func test2():
    print("test2...")
    
func test3():
    print("test3...")
    
    
