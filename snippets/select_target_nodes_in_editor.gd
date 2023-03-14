"""

in godot 4 you can just use an export like:

export var terrain_gen: RSIT_Terrain



so far i can't get it to work in tool mode

"""


## my old method updated:

@export var _terrain_generator: NodePath # has a string to the target node
var terrain_generator # the node reference itself
func get_terrain_generator() -> RSIT_Terrain: # run this function first, will work in tool mode
    if not is_instance_valid(terrain_generator):
        terrain_generator = get_node_or_null(_terrain_generator) 
    return terrain_generator




## pattern works in tool mode to find a sibling of type, no export required
var terrain_generator: RSIT_Terrain
func get_terrain_generator() -> RSIT_Terrain:
    for sibling in get_parent().get_children():        
        if sibling is RSIT_Terrain:
            terrain_generator = sibling
            break
    return terrain_generator




## pattern works in tool mode to find a sibling of type, uses root so good for most singletons
var terrain_generator: RSIT_Terrain
func get_terrain_generator() -> RSIT_Terrain:
    for sibling in get_tree().get_root().get_children(): # in root
        if sibling is RSIT_Terrain:
            terrain_generator = sibling
            break
    return terrain_generator










## trying to quick search class based:

## does not find custom classes
static func find_by_class(node: Node, className : String, result : Array = []) -> Array:
    if node.is_class(className) :
        result.push_back(node)
    for child in node.get_children():
        find_by_class(child, className, result)
    return result

#static func find_by_class(node: Node, className : String) -> Array:
#    var ret = []
#    _find_by_class(node, className, ret)
#    print(ret)
#    return ret








## port this?
func find_node_no_recurse(root, _name, max_depth = 100, max_count = 1000):
    """
    this pattern built by me to use a stack, no recursion, it looks more complicated but should use less memory and be faster
    
    could be more effecient in some circumstances
    
    """
        
    var count = 0 # current count
    
    var walk_stack = [root] # this tracks the nodes to check, these act as stacks (faster)
    var walk_stack_depth = [0] # this tracks the depth (parrel arrays)
    
    while walk_stack.size() > 0:
        
        count += 1
        if count > max_count:
            break
        
        ## popping back is faster, but ends up search all tree top to bottom
        var node = walk_stack.pop_back()
        var node_depth = walk_stack_depth.pop_back()
        
#        ## if we used this alternate pattern, we would search in slices
#        ## this could be faster but pop_front is also slower
#        var node = walk_stack.pop_front()
#        var node_depth = walk_stack_depth.pop_front()
        
        print("walk (%s) %s depth=%s" % [count,node,node_depth])
        
        if node.name == _name: ## we have a match, exit the function
            return node
            
        if node_depth < max_depth: ## as long as we are less than max_depth
            
#            ## this method ends up backwards due to the stack pattern
#            for child in node.get_children(): ## we have no other result, push childs to stack
#                walk_stack.push_back(child)
#                walk_stack_depth.push_back(node_depth + 1)
            
            ## this pattern iterates the children backwards (ensures search is forwards)
            var i = node.get_child_count()
            while i > 0:
                i -= 1
                walk_stack.push_back(node.get_child(i))
                walk_stack_depth.push_back(node_depth + 1)