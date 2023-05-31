"""

tweens are a far easier way to animate things

"""

"""

tweens are better for animating things in script


"""

# tween cache, when we grab a tween it will kill the old one if it exists (one per target)
var _tween_cache = {}

func _kill_and_get_tween(target) -> Tween:
    
    if target in _tween_cache:
        var tween = _tween_cache[target]
        tween.kill()
    
    var tween: Tween = get_tree().create_tween()
    _tween_cache[target] = tween
    return tween




## quick shortcut create a tween to move transform on a target
var _tweens = {}
func _create_tween(target: Node3D, _transform: Transform3D, time = 1.0, transition_type = Tween.TRANS_LINEAR):
    
    # stop existing tweens
    if _tweens == null:
        _tweens = {}
    if target in _tweens:
        _tweens[target].kill()
        _tweens.erase(target)
        
    var tween: Tween = get_tree().create_tween()
    tween.set_trans(transition_type)
    tween.set_ease(Tween.EASE_OUT)
    tween.tween_property(target, "transform", _transform, time)
    _tweens[target] = tween

## the target to a position by tween
func move_target_to(target: Node3D, move_to: Vector3, time: float, transition_type = Tween.TRANS_LINEAR):
    var _transform: Transform3D = target.transform
    _transform.origin = move_to
    _create_tween(target, _transform, time, transition_type)
    
## rotate the target by tween in degrees (keep the origin the same)
func rotate_target_to(target: Node3D, rotate_to: Vector3, time: float = 1.0, transition_type = Tween.TRANS_LINEAR):
        
    rotate_to.x = deg_to_rad(rotate_to.x) # degrees in are converted to radians
    rotate_to.y = deg_to_rad(rotate_to.y)
    rotate_to.z = deg_to_rad(rotate_to.z)
    var _transform: Transform3D = target.transform # start with the existing transform
    _transform.basis = Basis.from_euler(rotate_to)
    
    _create_tween(target, _transform, time, transition_type)
    
    
