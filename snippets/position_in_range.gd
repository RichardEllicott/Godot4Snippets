## Vector3i inside the range Vector3i
static func position_in_range(_position: Vector3i, range: Vector3i):    
    return (
        _position.x >= 0 and _position.y >= 0 and _position.z >= 0
        and _position.x < range.x and _position.y < range.y and _position.z < range.z)
        

## same with Vector3
static func position_in_range2(_position: Vector3, range: Vector3):    
    return (
        _position.x >= 0 and _position.y >= 0 and _position.z >= 0
        and _position.x < range.x and _position.y < range.y and _position.z < range.z)
