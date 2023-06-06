"""

easy way of getting all children of a node

for child in get_all_children(self):
    print(child.name)

"""

# https://godotengine.org/qa/74010/how-to-get-all-children-from-a-node
static func get_all_children(_self: Node, children:= []) -> Array:
    array.push_back(_self)
    for child in _self.get_children():
        array = get_all_children(child, array)
    return array
    
    

## get all children, no recursion
## https://godotengine.org/qa/74010/how-to-get-all-children-from-a-node
func get_all_children(_self: Node):
    var children = []
    var waiting := _self.get_children()
    while waiting.size() > 0:
        var node := waiting.pop_back() as Node
        waiting.append_array(node.get_children())
        children.append(node)
    return children




## find all childs with a predicate match, default here is Node3D
func match_children(_self: Node, predicate = func (child): return child is Node3D):
    var matches = []
    var waiting := _self.get_children()
    while waiting.size() > 0:
        var node := waiting.pop_back() as Node
        waiting.append_array(node.get_children())
        if predicate.call(node):
            matches.append(node)
    return matches
    
