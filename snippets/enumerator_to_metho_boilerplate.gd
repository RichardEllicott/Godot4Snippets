"""
"""



enum State{
    DEFAULT,
    IDLE,
    SEARCHING,
}

## using reflection, setting the state enumerator will set funcion hooks
@export var state: State:
    get:
        return state
    set(_state):
        state = _state
        method = DEFAULT # default callable (fallback)
        
        var method_name = State.keys()[state]
        if has_method(method_name): # if we find a method matching enumerator name
            method = get(method_name)
                        
        method.call()

func DEFAULT():
    pass
    
var method: Callable = DEFAULT
