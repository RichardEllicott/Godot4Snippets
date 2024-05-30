"""

the most simple looking reflection hook


we can use this for a simple, all on one script, state machine (why it says state)

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
        var method_name = State.keys()[state] # enumator int to name string
        if has_method(method_name): # if we find a method matching enumerator name
            method = get(method_name) # set the method
                        
        method.call() # in this example we just call the method here, we could also for example add it to process with no lookup overhead (using Callable)

func DEFAULT():
    pass
    
var method: Callable = DEFAULT
