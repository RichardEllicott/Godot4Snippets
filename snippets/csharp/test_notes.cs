

// this test shows how static properties are shared
static Godot.Collections.Dictionary<Node3D, bool> _test_if_we_are_shared = new Godot.Collections.Dictionary<Node3D, bool>();public void test_if_we_are_shared(){
    _test_if_we_are_shared[this] = true;
    GD.Print("test_if_we_are_shared: ", _test_if_we_are_shared);

    foreach (var entry in _test_if_we_are_shared)
    {
        GD.Print("-entry: ", entry);
    }
}
