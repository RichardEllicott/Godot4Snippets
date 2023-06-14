"""

easy way of getting all children of a node

for child in get_all_children(self):
    print(child.name)
    
    
using recursion is adequete for most tasks it seems

"""


## easy method using recursion, in most cases this would be fine
## https://godotengine.org/qa/74010/how-to-get-all-children-from-a-node

static func get_all_children(_self: Node, _children : Array[Node] = []) -> Array[Node]:
    _children.push_back(_self)
    for child in _self.get_children():
        _children = get_all_children(child, _children)
    return _children
    

# get all children with a max depth (can help to prevent finding too many nodes)
static func get_all_children(_self: Node, max_depth: int = 4, children: Array[Node] = [], depth: int = 0) -> Array[Node]:
    if depth <= max_depth:
        children.push_back(_self)
        for child in _self.get_children():
            children = get_all_children(child, max_depth, children, depth + 1)
    return children
    
    
    
## get all children with a predicate match (use a lambda or callable that returns a boolean).. note no recursion, makes depth harder to track

static func get_all_children(_self: Node, predicate: Callable = func (child): return child is Node) -> Array[Node]:
    var matches: Array[Node] = []
    var waiting: Array[Node] = _self.get_children()
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
static func print_all_children_as_tree(_self: Node, max_depth = 4, depth = 0) -> void:
    if depth <= max_depth:
        var pad = ""
        for i in depth:
            pad += "    "
        print("%s%s" % [pad, _self])
        for child in _self.get_children():
            print_all_children_as_tree(child, max_depth, depth + 1)
    
