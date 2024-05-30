"""

the wait syntax that works best is:

await get_tree().create_timer(1.0).timeout ## waits for the signal to fire

"""


## dress up
func wait(time: float = 1.0) -> Signal:
    return get_tree().create_timer(time).timeout
    
    
 
func example():
    await wait(1.0)
