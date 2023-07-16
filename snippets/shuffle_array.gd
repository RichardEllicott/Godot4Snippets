"""

shuffle an array like shuffling cards, provide an optional seed to make the shuffle procedural

leaves orginal array alone, returns a shuffled one

"""


static func shuffle_array(array: Array) -> Array:
    var shuffled_array = [] # return this
    array = array.duplicate() # stop affecting the orginal
    while array.size() > 0:
        var randi = randi() % array.size()
        shuffled_array.append(array[randi])
        array.remove_at(randi)
    return shuffled_array
    
    
