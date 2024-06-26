"""
rendering server boilerplate example

"""
func _exit_tree():        
    clear_mesh_instances()
    

var rids: Array[RID] = []

func add_mesh_instance(_mesh: Mesh, _transform: Transform3D) -> RID:
    
    var rid: RID = RenderingServer.instance_create2(_mesh, get_world_3d().scenario)
    RenderingServer.instance_set_transform(rid, _transform)
    rids.append(rid)
    return rid
    
func clear_mesh_instances():
    for rid: RID in rids:
        RenderingServer.free_rid(rid)
    rids = []
