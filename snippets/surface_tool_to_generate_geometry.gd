"""

SurfaceTool is the only geometry tool that can generate normals automaticly (very useful), and has complex features like importing meshes
https://docs.godotengine.org/en/stable/tutorials/3d/procedural_geometry/surfacetool.html

(ImmediateMesh is apparently faster, more suited for realtime)

you need one SurfaceTool per a material if you draw the materials out of order, so this boilerplate hides that fact

-materials must have at least one material
-set material (int) as the current one to draw with
-get_mesh will return the final mesh

"""
@tool
extends Node3D

## must contain at least one material
@export var materials: Array[Material] = []
## the current set material, set this number as you draw different materials
@export var material: int = 0

## get the correct surface tool, generates a surface tool for each material
var _surface_tools = []
func get_surface_tool() -> SurfaceTool:
    while  material >= _surface_tools.size():
        var st = SurfaceTool.new()
        st.begin(Mesh.PRIMITIVE_TRIANGLES) # set to trinagle mode
#        st.begin(Mesh.PRIMITIVE_LINES) # line mode leaves the lines too thin!
        _surface_tools.append(st)
        
    var surface_tool = _surface_tools[material] # tool to return
    surface_tool.set_material(materials[material]) # ensure has correct material set
    return surface_tool

## get the final mesh, generates normals and tangents
## uses multiple surface tools for the multiple materials
func get_mesh() -> Mesh:
    var mesh: Mesh
    for surface_tool in _surface_tools:
        surface_tool.generate_normals()
        surface_tool.generate_tangents()
        mesh = surface_tool.commit(mesh)
    return mesh

## if we want to draw new geometry, we must clear the old surface tools they will be full of old data
func clear():
    _surface_tools = [] # clearing the old tools (only method that works so far)
    for surface_tool in _surface_tools: # the manual leads me to belive i didn't have to delete the old SurfaceTools?
        surface_tool.clear()

## make any convex polygon shape
func make_ngon(vertices: PackedVector3Array, uvs: PackedVector2Array):    
    
    if flip_faces: # we use a dirty copy here, it just allows a global "flip_faces" setting
        vertices = vertices.duplicate()
        vertices.reverse()
        uvs = uvs.duplicate()
        uvs.reverse()
    
    get_surface_tool().add_triangle_fan(vertices, uvs)

## make a simple quad example, default is a 2x2 quad facing up (+y)
func make_quad(
    nw: Vector3 = Vector3(-1, 0, -1), # n is -z
    ne: Vector3 = Vector3(1, 0, -1),
    se: Vector3 = Vector3(1, 0, 1),
    sw: Vector3 = Vector3(-1, 0, 1),
    
    nw_uv: Vector2 = Vector2(0, 0),
    ne_uv: Vector2 = Vector2(1, 0),
    se_uv: Vector2 = Vector2(1, 1),
    sw_uv: Vector2 = Vector2(0, 1)
    ):
    make_ngon([nw,ne,se,sw], [nw_uv,ne_uv,se_uv,sw_uv])

## easy function to create childs in tool mode, used for demo here
static func get_or_create_child(parent: Node,node_name: String, node_type = Node) -> Node:        
    var node = parent.get_node_or_null(node_name) # get the node if present
    if not is_instance_valid(node): # if no node found make one
        node = node_type.new()
        node.name = node_name
        parent.add_child(node)
        if Engine.is_editor_hint():
            node.set_owner(parent.get_tree().edited_scene_root) # show in tool mode
#    assert(node is node_type) # best to check the type matches
    return node

## make a child mesh of current node, a row of quads with different materials
func macro_test_boilerplate_materials():
    
    clear() ## clear any old data
    
    var offset = Vector3(2,0,0) ## we move this offset
    
    var nw: Vector3 = Vector3(-1, 0, -1) # n is -z
    var ne: Vector3 = Vector3(1, 0, -1)
    var se: Vector3 = Vector3(1, 0, 1)
    var sw: Vector3 = Vector3(-1, 0, 1)
    
    for i in 8: # make 8 quads
        material = i % materials.size() # set their materials alternatly
        make_quad(nw,ne,se,sw)
        nw += offset
        ne += offset
        se += offset
        sw += offset
        
    var positions = []
    
    var mesh: Mesh = get_mesh()
    var mesh_instance: MeshInstance3D = get_or_create_child(self, "MeshInstance3D", MeshInstance3D)
    mesh_instance.mesh = mesh

