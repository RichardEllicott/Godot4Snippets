"""

MultiMeshInstance3D_Cache object (13/03/2023 Richard Ellicott)

allows setting a multimesh  with a cache (so you don't need to know the instance count in advance)

the code is inside the object MultiMeshCache, which can be used seperatly
also includes line drawing functions and will set up a mesh automaticly for debug purposes

"""
@tool
extends MultiMeshInstance3D
class_name MultiMeshInstance3D_Cache

## Editor Controls

enum Macro {
    example01,
   }

@export var trigger_macro = false : set = set_trigger_macro
func set_trigger_macro(input):
    if input:
        trigger_macro = false
        if Engine.is_editor_hint():
            _ready() # ensure vars are available
        call(Macro.keys()[macro])
@export var macro: Macro = 0

func _ready():
    pass

func example01():
    
    var width = 1.0
    var multimesh_cache = MultiMeshCache.new(multimesh)
    
    multimesh_cache.add_line(Vector3(),Vector3(0,4,0), width, Color.RED)
    multimesh_cache.add_line(Vector3(0,4,0),Vector3(4,4,0), width, Color.GREEN)
    multimesh_cache.update()


## cache wrapper to allow setting the multimesh easier
## optional line 
class MultiMeshCache:
    
    var multimesh: MultiMesh
    
    var _transforms: Array = []
    var _colors: Array = []
    
    func _init(_multimesh: MultiMesh) -> void:
        multimesh = _multimesh
        assert(multimesh != null, "cannot be null!") # null must be coming through
        setup()
    
    ## clear all data
    func clear() -> void:
        _transforms = []
        _colors = []
    
    ## add a new transform or position with optional color
    func add(Transform_or_Vector3, color: Color = Color.WHITE) -> void: # accepts Vector3 or Transform3D
        if Transform_or_Vector3 is Vector3:
            var t = Transform3D()
            t.origin = Transform_or_Vector3
            Transform_or_Vector3 = t
        assert(Transform_or_Vector3 is Transform3D)
        _transforms.append(Transform_or_Vector3)
        _colors.append(color)
    
    ## features beyond this point are optional and show example usage:
    
    ## draw all the cached transforms and flush the memory
    func update() -> void:
        
        multimesh.instance_count = _transforms.size()
        for i in _transforms.size():
            multimesh.set_instance_transform(i, _transforms[i])
            multimesh.set_instance_color(i, _colors[i]) # OPTIONAL FEATURE
        clear()
    
    ## set the multimesh up with a default settings and a cylinder (for line drawing) if it has no mesh already
    func setup():
        
        multimesh.instance_count = 0
        multimesh.transform_format = MultiMesh.TRANSFORM_3D
        multimesh.use_colors = true
        
        if multimesh.mesh == null: # if we have no mesh already, we make a default unshaded cylinder appropiate for drawing lines
            
            var material = StandardMaterial3D.new() # add a new material
            material.flags_unshaded = true # unshaded (not affected by shadows/fog)
            material.vertex_color_use_as_albedo = true # this is required for colors
            material.flags_transparent = true # allows the colors to be transparent
            
            var cylinder_mesh: CylinderMesh = CylinderMesh.new() # create our cylinder
            cylinder_mesh.rings = 0 # rings just waste polygons
            cylinder_mesh.radial_segments = 8 # 8 sides is fine
#            cylinder_mesh.cap_bottom = false
#            cylinder_mesh.cap_top = false
            cylinder_mesh.material = material
            
            multimesh.mesh = cylinder_mesh

    static func _calc_line_transform(_mag_vector: Vector3, _offset: Vector3 ,_width: float, _transform = Transform3D()) -> Transform3D:
        # _calc_line_transform
        # v1.0 (30/05/2022)
        #
        # this calculates a final transform to rotate/stretch/move a cylinder into place to be a line
        #
        # this cylinder goes from (0,0,0) to (1,0,0), thusly the built in cylinder must be adjusted
        #
        # this means it is best to supply a model of a hollow tube that goes 1 unit along the x axis
        #
        # to use this as a to and from:
        #
        # _mag_vector = to - from
        # _offset = from

        var mag_vector_copy = _mag_vector # correcting backwards bug (UNSURE STILL
        mag_vector_copy.x = -mag_vector_copy.x
        mag_vector_copy.z = -mag_vector_copy.z
        
        # stretch to the right length
        _transform = _transform.scaled(Vector3(mag_vector_copy.length(),_width,_width))
        
        var A = sqrt(pow(mag_vector_copy.x, 2.0) + pow(mag_vector_copy.z,2.0))
        #only rotate 2nd time if y is not 0, this elimnates a scene destroying bug!
        
        # rotate the on the z axis as the pitch
        if mag_vector_copy.y != 0.0: # avoids a bug? (no pitch required if no y on mag_vector)
            var H = mag_vector_copy.length()
            var theta = acos(A/H)
            if mag_vector_copy.y < 0.0: # WEIRD CORRECTION!!
                theta = -theta
        
            _transform = _transform.rotated(Vector3(0.0,0.0,1.0), theta)

        # rotate around the horizon as the direction (needs to be second rotation)
        _transform = _transform.rotated(Vector3.UP,atan2(mag_vector_copy.z,-mag_vector_copy.x))
        
        # this moves the offset (ignoring the scale and rotation), done last
        _transform.origin += _offset 

        return _transform
    
    ## add a line in 3D space, built by stretching a cylinder or mesh shape using
    func add_line(from: Vector3, to: Vector3, width: float = 1.0, color: Color = Color.WHITE) -> void:
        var _transform = Transform3D() # the final transform
        if multimesh.mesh is CylinderMesh: # if we used the built in CylinderMesh, assume it has 0.5 radius and a height of 2 (default)
            _transform = _transform.rotated(Vector3(0,0,1), deg_to_rad(90.0)) # rotate from vertical to along x axis
            _transform.origin.x += 1 # push to positive x
            _transform = _transform.scaled(Vector3(0.5,1.0,1.0)) # scale correction so it is 1 unit diameter, 1 unit long
        _transform = _calc_line_transform(to-from,from,width,_transform)
        add(_transform, color)
        
    ## add lines, so a list of points, useful to set a path
    func add_lines(points: Array, width: float = 1.0, color = Color.WHITE) -> void:
        for i in points.size() - 1:
            add_line(points[i], points[i+1], width, color)

    

