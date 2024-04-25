


// get or create child works like:
// var multimesh_instance3d = this.GetOrCreateChild<MultiMeshInstance3D>("MultiMeshInstance3D");
// called on a Node
//
// this extension should be put in a public static class, it can then be called from any Godot.Node

    public static T GetOrCreateChild<T>(this Godot.Node _parent, string _name) where T : Godot.Node, new()
    {
        var child = _parent.GetNodeOrNull(_name); // check for child

        if (child == null) // if no child
        {
            child = new T(); // create a new one

            child.Name = _name; // set it's name
            _parent.AddChild(child); // add as child
            if (Engine.IsEditorHint()) // if in editor
            {
                child.Owner = _parent.GetTree().EditedSceneRoot; // set the owner, this makes spawned nodes show up in tool scripts
            }
        }
        return child as T;
    }

