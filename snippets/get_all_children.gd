"""

easy way of getting all children of a node

for child in get_all_children(self):
    print(child.name)
    
    
using recursion is adequete for most tasks it seems

"""


## easy method using recursion, in most cases this would be fine
## https://godotengine.org/qa/74010/how-to-get-all-children-from-a-node

static func get_all_children(_self: Node, children : Array[Node] = []) -> Array[Node]:
    children.push_back(_self)
    for child in _self.get_children():
        children = get_all_children(child, children)
    return children
    
    
## get all children with a predicate match (use a lambda or callable that returns a boolean)
static func get_all_children(_self: Node, predicate: Callable = func (child): return child is Node) -> Array:
    var matches: Array = []
    var waiting: Array = _self.get_children()
    while waiting.size() > 0:
        var node := waiting.pop_back() as Node
        waiting.append_array(node.get_children())
        if predicate.call(node):
            matches.append(node)
    return matches
    
    
    
    
    
## get all children, no recursion, no advantage but this snippet is useful
static func get_all_children(_self: Node) -> Array:
    var children: Array = []
    var waiting := _self.get_children()
    while waiting.size() > 0:
        var node := waiting.pop_back() as Node
        waiting.append_array(node.get_children())
        children.append(node)
    return children





    
    
    
# using recursion to print a tree of the nodes
static func print_all_children_as_tree(_self: Node, array:= [], depth = 0, max_depth = 10) -> Array:
    
    if depth <= max_depth:
        
        array.push_back(_self)
        var pad = ""
        for i in depth:
            pad += "    "
        print("%s %s" % [pad, _self])
        
        for child in _self.get_children():
            array = print_all_children_as_tree(child, array, depth + 1, max_depth)
    return array
    
