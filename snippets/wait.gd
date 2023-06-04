"""

the wait syntax that works best

"""



func wait(time: float = 1.0):
    return get_tree().create_timer(time).timeout
    
    
 
func example():
    await wait(1.0)
