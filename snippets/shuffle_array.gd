"""

shuffle an array like shuffling cards, provide an optional seed to make the shuffle procedural

leaves orginal array alone, returns a shuffled one

"""

static func shuffle_array(array: Array) -> Array:
    array = array.duplicate()
    var shuffledList = []
    var indexList = range(array.size())
    for i in range(array.size()):
        var x = randi() % indexList.size()
        shuffledList.append(array[x])
        indexList.remove_at(x)
        array.remove_at(x)
    return shuffledList
    
    
