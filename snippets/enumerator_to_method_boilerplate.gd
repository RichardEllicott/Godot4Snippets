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




## this is just an example of how a state machine could work, in this case we are using threads which sort of occurs after we call (await wait(delay))
## now the loop is basicly a lost thread (as there is a while loop)
## as we are unable to find this thread (very lazy), we will just break out of the loop if our state changed
##
## i like this syntax as it's very easy to write
##
func SEARCHING():
    
    print("start SEARCHING...")

    var i = 0    
    while true: # loop
        if not method == SEARCHING: # if no longer function pointed method
            break # break out of this thread!
        i += 1
        
        print("searching ", i)
        
        var delay = get_new_delay()
        print("wait for %.2f seconds" % delay)
        
        await wait(delay)
        
        parent.input_direction = get_random_direction()
        
