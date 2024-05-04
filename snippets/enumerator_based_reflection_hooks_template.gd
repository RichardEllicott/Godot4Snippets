"""

Boilerplate reflection, setting the "Type" will set various function hooks


this can be an easy way of organising a state machine, simply make functions here like:

_duck_process
_duck_physics_process
_duck_process_timer


"""
@tool
extends Node

enum Type {
    none,
    duck,
    chicken,
}

var _type: Type = Type.chicken
@export var type: Type:
    get:
        return _type
    set(value):
        var enum_string = Type.keys()[value]
        for prefix in ["_physics_process", "_process", "_ready", "_process_timer"]:
            var method_string = "_%s%s" % [enum_string, prefix]
            var hook_string = prefix + "_hook"            
            if has_method(method_string):
                var method = get(method_string)                
                var hook = get(hook_string) # maybe check this exists?
                set(hook_string, method)
            else:
                set(hook_string, null) # if no method, null the hook
                
        _type = value
        
        
var timer = 0.0
@export var delay = 1.0
@export var random_delay = 1.0
var counter = 0

## if these are labeled as "Callable" GDScript won't let me null them
var _ready_hook # : Callable
var _process_timer_hook # : Callable
var _process_hook # : Callable
var _physics_process_hook # : Callable

func _ready():
    type = type
    
func _physics_process(delta):
    if _physics_process_hook:
        _physics_process_hook.call(delta)

func _process(delta):
    timer += delta
    while timer >= delay:
        timer -= delay
        counter += 1
        if _process_timer_hook:
            _process_timer_hook.call() # why null? no idea
                
    if _process_hook:
        _process_hook.call(delta)
    



# functions correctly named will be auto detected
func _chicken_process_timer():    
    print("🐔 _chicken_process_timer...")

func _duck_process_timer():    
    print("🦆 _duck_process_timer...")

func _duck_process(delta):    
    print("🦆 _duck_process_timer...")



        
