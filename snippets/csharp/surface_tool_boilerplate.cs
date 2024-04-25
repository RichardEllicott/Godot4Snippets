

// [GlobalClass]
[Tool]
public partial class voxel_demo : Node3D
{

    // must contain at least one material
    [Export]
    Godot.Collections.Array<Material> materials = new Godot.Collections.Array<Material>();

    [Export]
    int material = 0;

    // get surface tool, corresponding to the current material
    SurfaceTool GetSurfaceTool()
    {
        // if our material count is different, we rebuild the tools, so set materials before building
        if (surface_tools.Count != materials.Count)
        {
            surface_tools = new Godot.Collections.Array<SurfaceTool>();

            for (int i = 0; i < materials.Count; i++)
            {
                var st = new SurfaceTool();
                st.Begin(Mesh.PrimitiveType.Triangles);
                st.SetMaterial(materials[i]);
                surface_tools.Add(st);
            }
        }

        return surface_tools[material];
    }


    // builds the final mesh
    Godot.ArrayMesh Commit()
    {
        Godot.ArrayMesh mesh = null;

        foreach (SurfaceTool st in surface_tools)
        {
            st.GenerateNormals();
            st.GenerateTangents();
            mesh = st.Commit(mesh);
        }

        return mesh;
    }



    Godot.Collections.Array<SurfaceTool> surface_tools = new Godot.Collections.Array<SurfaceTool>();

    void Clear()
    {
        surface_tools = new Godot.Collections.Array<SurfaceTool>();
    }


    void make_ngon(Godot.Vector3[] vertices, Godot.Vector2[] uvs)
    {
        GetSurfaceTool().AddTriangleFan(vertices, uvs);
    }


    // note requires the extension "GetOrCreateChild"
    MeshInstance3D CreateChildWithMesh(string child_name = "MeshInstance3D", bool collision = false)
    {
        var mesh = Commit();

        var mesh_instance = this.GetOrCreateChild<MeshInstance3D>(child_name);
        mesh_instance.Mesh = mesh;

        if (collision)
        {
            var static_body = mesh_instance.GetOrCreateChild<StaticBody3D>("StaticBody3D");
            var coll_shape = static_body.GetOrCreateChild<CollisionShape3D>("CollisionShape3D");
        }

        return mesh_instance;

    }

    void macro_quad_example()
    {

        GD.Print("macro_test...");

        material = 1;

        Godot.Vector3[] vertices = new Vector3[] {
            new Vector3(-1, 0, -1),
            new Vector3(1, 0, -1),
            new Vector3(1, 0, 1),
            new Vector3(-1, 0, 1) };

        Godot.Vector2[] uvs = new Vector2[] {
            new Vector2(0, 0),
            new Vector2(1, 0),
            new Vector2(1, 1),
            new Vector2(0, 1) };

        make_ngon(vertices, uvs);


        var child = CreateChildWithMesh();





    }
}
