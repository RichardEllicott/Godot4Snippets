"""
allows setting multi mesh before knowing how many instances


"""

class MultiMeshCache:
    # small cache to set the transforms out of order
    
    var multimesh: MultiMesh
    
    var _transforms: Array = []
    var _colors: Array = [] # OPTIONAL
    
    func _init(_multimesh: MultiMesh):
        multimesh = _multimesh
    
    func clear():
        _transforms = []
        _colors = []
        
    func add(Transform_or_Vector3, color: Color = Color.WHITE): # accepts Vector3 or Transform3D
        if Transform_or_Vector3 is Vector3:
            var t = Transform3D()
            t.origin = Transform_or_Vector3
            Transform_or_Vector3 = t
        assert(Transform_or_Vector3 is Transform3D)
        _transforms.append(Transform_or_Vector3)
        _colors.append(color) # OPTIONAL
                
    func update():
        multimesh.instance_count = 0
        multimesh.transform_format = MultiMesh.TRANSFORM_3D
        multimesh.instance_count = _transforms.size()
        for i in _transforms.size():
            multimesh.set_instance_transform(i, _transforms[i])
            multimesh.set_instance_color(i, _colors[i]) # OPTIONAL
        clear()