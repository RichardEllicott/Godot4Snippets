


      // get or create child works like:
      // var multimesh_instance3d = this.GetOrCreateChild<MultiMeshInstance3D>("MultiMeshInstance3D");
      // called on a Node
  public static T GetOrCreateChild<T>(this Godot.Node _parent, string _name) where T : Godot.Node, new()
  {
      var child = _parent.GetNodeOrNull(_name);

      if (child == null)
      {
          child = new T();// as Godot.Node;

          child.Name = _name;
          _parent.AddChild(child);
          if (Engine.IsEditorHint())
          {
              child.Owner = _parent.GetTree().EditedSceneRoot;
          }
      }
      return child as T;
  }


