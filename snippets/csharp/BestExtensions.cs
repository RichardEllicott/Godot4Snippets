

static class BestExtensions
{
    // this is an Extenson to make it easier to check if node's are valid (same as is_instance_valid in gdscript)
    public static bool IsValid<T>(this T node) where T : Godot.GodotObject
    {
        return node != null
            && Godot.GodotObject.IsInstanceValid(node)
            && !node.IsQueuedForDeletion(); // prevents a crash where the object is being trashed
    }

    // get a node by name, if it doesn't exist create one
    // example:
    // var mm3d = this.GetOrCreateChild<MultiMeshInstance3D>("MultiMeshInstance3D");
    //
    // this function makes it very easy to set up a node hierarchy in script, which can make scripts easier to use 
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



    // sort using a "straight insertion" method, does not return a re-ordered array but an array of indexes like:
    // {2,1,0,3}
    // if the list was already sorted for example, the result would be {0,1,2,3}

    // effecient for small arrays
    public static Godot.Collections.Array<int> InsertSort<[MustBeVariant] T>(this Godot.Collections.Array<T> input_array, Func<T, T, bool> lambda)
    {
        var order = new Godot.Collections.Array<int>(); // we will return a list of the new order
        order.Resize(input_array.Count);

        for (int i = 0; i < input_array.Count; i++)
        {
            order[i] = i;
        }

        for (int i = 0; i < input_array.Count - 1; i++)
        {
            for (int j = i + 1; j > 0; j--)
            {
                var x_ref = order[j - 1];
                var y_ref = order[j];

                var x = input_array[x_ref];
                var y = input_array[y_ref];

                if (lambda(x, y))  // Swap if the element at j - 1 position is greater than the element at j position
                {
                    int temp = order[j - 1];
                    order[j - 1] = order[j];
                    order[j] = temp;
                }
            }
        }
        return order; // Return the sorted array
    }

    public static Godot.Collections.Array<int> InsertSort(this Godot.Collections.Array<int> input_array)
    {
        return InsertSort(input_array, (x, y) => x > y);
    }

    public static Godot.Collections.Array<int> InsertSort(this Godot.Collections.Array<float> input_array)
    {
        return InsertSort(input_array, (x, y) => x > y);
    }


    // easy set bit flags on an integer
    public static int SetBit(this int i, int position, bool value)
    {
        if (value) return i |= (1 << position); // set bit to 1
        else return i & ~(1 << position);   // set bit to 0
    }
    public static bool GetBit(this int value, int position)
    {
        return (value & (1 << position)) != 0; // get bit at position
    }
    public static int FlipBit(this int value, int position)
    {
        return value.SetBit(position, !value.GetBit(position));
    }






}
