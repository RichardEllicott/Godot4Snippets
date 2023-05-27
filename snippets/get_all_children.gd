"""
get ALL children

"""


# https://godotengine.org/qa/74010/how-to-get-all-children-from-a-node
static func get_all_children(_self: Node, array:= []) -> Array:
    array.push_back(_self)
    for child in _self.get_children():
        array = get_all_children(child, array)
    return array
    
    
