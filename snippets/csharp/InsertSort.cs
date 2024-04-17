
static class Helper{

    

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
}

    public static Godot.Collections.Array<int> InsertSort(this Godot.Collections.Array<float> input_array)
    {
        return InsertSort(input_array, (x, y) => x > y);
    }

