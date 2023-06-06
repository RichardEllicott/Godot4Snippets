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
    
    


## print all children, no recursion but lots of arrays
func print_all_children(_self: Node):
    var waiting := _self.get_children()
    while waiting.size() > 0:
        var node := waiting.pop_back() as Node
        waiting.append_array(node.get_children())
        
        print(node)
#       # do something with the node here (or use the lambda)
    
