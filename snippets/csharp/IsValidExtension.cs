static class Helper
{
    // this is an Extenson to make it easier to check if node's are valid
    public static bool IsValid<T>(this T node) where T : Godot.GodotObject
    {
        return node != null
            && Godot.GodotObject.IsInstanceValid(node)
            && !node.IsQueuedForDeletion();
    }
}
