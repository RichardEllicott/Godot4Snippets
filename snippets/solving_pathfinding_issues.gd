"""

it is difficult to stop Godot's pathfinding getting stuck with any settings

this solution works with these NavigationRegion3D settings:

Cells:
    size = 0.06
    height = 0.06
Agents:
    radius = 0.4 # fits through 1 meter gaps

the actual CharacterBody3D can have an actual collider with radius of 0.4 and height 1.5 and not get stuck
"""


# get_path_direction with jitter
# the pathfinding seems to get stuck, with this method if we do not move, return a random direction
# this random movement unsticks the unit
# call only once per a frame!
var _path_direction_last_pos: Vector3 = Vector3.ZERO
func get_path_direction(_target_position: Vector3) -> Vector3:
    
    if _path_direction_last_pos == global_position: # if position doesn't change, just return random direction
        print("⚡ unstick jitter on ", self.name) # printing here will show when this kicks in for testing
        return Vector3(randf() - 0.5, randf() - 0.5, randf() - 0.5).normalized() # random direction in 3D space
    _path_direction_last_pos = global_position
    
    navigation_agent.target_position = _target_position 
    return global_position.direction_to(navigation_agent.get_next_path_position())
