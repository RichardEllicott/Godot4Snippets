"""

achieving similar behaviour to Unity's enable/disable

this makes it easy for example to have an FPS controller and a RTS controller in the same scene, calling enable/disable will also set their camera


a few ways make sense, option 1 is manual
option 2 is using pause mode


"""

## enable/disable all scripts on a node, affects all child scripts (be careful not to call on root scenes)
## similar to unity, easier than having special bools in the script, maybe has errors? not sure yet
static func enable_node(target_node: Node, enabled: bool = true):
    
    # OPTION 1: try and stop the scripts:
#    target_node.set_process(enabled) # normal loop
#    target_node.set_physics_process(enabled) # physics loop
#    target_node.set_process_input(enabled) # disable responding to input events
#    target_node.set_process_unhandled_input(enabled)
    
    # OPTION 2: use the built in pause functions to pause the controllers
    if enabled:
        target_node.process_mode = Node.PROCESS_MODE_INHERIT
    else:
        target_node.process_mode = Node.PROCESS_MODE_DISABLED
    
    if target_node is Camera3D: # enable/disable any cameras found (for selecting controllers)
        target_node.current = enabled
        
    if target_node is Node2D: # enable/disable any 2D UI elements included on node
        target_node.visible = enabled
    if target_node is Control:
        target_node.visible = enabled

    for child in target_node.get_children(): # repeat for all children
        enable_node(child, enabled) # recurse
    
static func disable_node(target_node: Node, enabled: bool = false):
    enable_node(target_node, enabled)