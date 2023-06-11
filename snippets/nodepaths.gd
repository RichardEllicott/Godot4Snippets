

 ## in godot 4 we can just export a node and set in editor:
 
 @export var node: Node
 
 ## but it returns null in tool mode!
 
 ## replace with:
 
 @export var _node: NodePath
 var node: Node:
    get:
        return get_node_or_null(_node)
 
 
## or sticky version, has a cache for speed but can cause bugs if we change the nodepath

@export var _node: NodePath
var node: Node:
    get:
        if not node: node = get_node_or_null(_node)
        return node
