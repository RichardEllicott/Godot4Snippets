"""

cache tool for the multimesh that can make lines by stretching cylinders


# make one of these objects
var mmc = MultiMeshInstance3DCache.new() 

# autosetup the mesh and material (will use a cylinder)
mmc.setup() 

## add some lines
mmc.add_lines([
    Vector3(),
    Vector3(8,0,0),
    Vector3(8,8,0),
    Vector3(8,8,8),
    ])

## update will display the lines, also clear the cache (so you need to put them back to redraw)
mmc.update()


"""
@tool
extends MultiMeshInstance3D
class_name MultiMeshInstance3DCache


## automaticly set the multimesh with a Cylinder designed for line drawing
func setup():
    
    if not multimesh:
        multimesh = MultiMesh.new()
    
        multimesh.instance_count = 0
        multimesh.transform_format = MultiMesh.TRANSFORM_3D
        multimesh.use_colors = true
        
        if not multimesh.mesh:
            
            var material = StandardMaterial3D.new() # add a new material
            material.flags_unshaded = true # unshaded (not affected by shadows/fog)
            material.vertex_color_use_as_albedo = true # this is required for colors
            material.flags_transparent = true # allows the colors to be transparent
            
            var cylinder_mesh: CylinderMesh = CylinderMesh.new() # create our cylinder
            cylinder_mesh.rings = 0 # rings just waste polygons
            cylinder_mesh.radial_segments = 8 # 8 sides is fine
            cylinder_mesh.cap_bottom = false
            cylinder_mesh.cap_top = false
            cylinder_mesh.material = material
            
            multimesh.mesh = cylinder_mesh
            
func macro_setup():
    setup()
    

var _transforms: Array = []
var _colors: Array = []

## clear all data
func clear() -> void:
    _transforms = []
    _colors = []
    
    
## add a new transform or position for the multimesh with optional color
func add(Transform_or_Vector3, color: Color = Color.WHITE) -> void: # accepts Vector3 or Transform3D
    if Transform_or_Vector3 is Vector3:
        var t = Transform3D()
        t.origin = Transform_or_Vector3
        Transform_or_Vector3 = t
    assert(Transform_or_Vector3 is Transform3D) # better have been a Transform3D
    _transforms.append(Transform_or_Vector3)
    _colors.append(color)    
    
## set all the multimesh positions, clear the data on this object
func update() -> void:
    multimesh.instance_count = _transforms.size()
    for i in _transforms.size():
        multimesh.set_instance_transform(i, _transforms[i])
        multimesh.set_instance_color(i, _colors[i]) # OPTIONAL FEATURE
    clear()
        
        
## convert a vector to a compass direction and pitch (or tilt, angle from hozizon)
## returns as x for rotations, y for tilt
## when using with a camera feed the cameras -transform.basis.z in
## with -z we will get rotation anticlockwise
static func vector_to_rotations(direction: Vector3) -> Vector2:
    var rotations = Vector2(atan2(direction.x, direction.z), 0.0) # add first compass angle in radians
    direction = direction.rotated(Vector3(0,1,0), -rotations.x) # rotate to eliminate the angle
    rotations.y = atan2(direction.y, direction.z) #the tilt
    return rotations

## new cleaner version
static func _calc_line_transform(_mag_vector: Vector3, _offset: Vector3 ,_width: float, _transform = Transform3D()) -> Transform3D:
                    
        _transform = _transform.scaled(Vector3(_mag_vector.length(),_width,_width)) # first stretch
        var rots: Vector2 = vector_to_rotations(_mag_vector) # note this function works for -z like cameras, we make a correction at the end so it works for rotating the +x axis
        _transform = _transform.rotated(Vector3(0.0,0.0,1.0), rots.y) # rotate to tilt first
        # the minus -90 corrects from -z version to +x version            
        _transform = _transform.rotated(Vector3.UP, rots.x + deg_to_rad(-90.0)) # rotate around horizon
        _transform.origin += _offset # finally offset
        return _transform

## older version was convuluted but does work
static func _calc_line_transform2(_mag_vector: Vector3, _offset: Vector3 ,_width: float, _transform = Transform3D()) -> Transform3D:
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
    
#        if multimesh.mesh is CylinderMesh: # if we used the built in CylinderMesh, assume it has 0.5 radius and a height of 2 (default)
    if true:
        _transform = _transform.rotated(Vector3(0,0,1), deg_to_rad(90.0)) # rotate from vertical to along x axis
        _transform.origin.x += 1 # push to positive x
        _transform = _transform.scaled(Vector3(0.5,1.0,1.0)) # scale correction so it is 1 unit diameter, 1 unit long
    
    
    _transform = _calc_line_transform(to-from,from,width,_transform)
    add(_transform, color)
    
## add lines, so a list of points, useful to set a path
func add_lines(points: Array, width: float = 1.0, color = Color.WHITE) -> void:
    for i in points.size() - 1:
        add_line(points[i], points[i+1], width, color)
        



# hanging cables (catenary curve)
    
const e: float = 2.71828182845904523536028747135266249775724709369995 # Euler's number

static func _catenary_function(x: float) -> float:
    # https://proofwiki.org/wiki/Equation_of_Catenary
    # pretty sure the cant can just be scaled (don't need a)
    return (pow(e,x) + pow(e,-x))/2.0
    
static func _catenary(x: float) -> float:
    # formulae corrected for coeffecient from 0-1 with offset correction
    x *= 2.0
    x -= 1.0
    var y = _catenary_function(x)
#    y -= (e + (1.0/e))/2.0 # the max drop can be defined by taking e=1
    y -= 1.543081 # result of (e + (1.0/e))/2.0
    return y

func add_catenary(from: Vector3, to: Vector3, div: int, droop: float, line_width: float = 1.0, color: Color = Color.WHITE):

    var coors = []
    for i in div+1:
        var x: float = float(i) / float(div)
        var pos: Vector3 = lerp(from,to, x)
        pos.y += _catenary(x) * droop
        coors.append(pos)
        
    for i in coors.size()-1:
        add_line(coors[i],coors[i+1],line_width, color)
        
        
        

func macro_test_lines():
    
    setup()
    
    add_lines([
        Vector3(),
        Vector3(8,0,0),
        Vector3(8,8,0),
        Vector3(8,8,8),
        ])
        
        
    add_catenary(Vector3(16,0,0), Vector3(16,0,16), 32, 8.0)
        
    update()
    
    pass
    

func _ready():
    pass


func _process(delta):
    pass
