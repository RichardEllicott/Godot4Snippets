



    public enum Mode
    {
        GridMap,
        GridMapDictionary,
    }


    private Mode _mode;

    [Export]
    public Mode mode
    {
        get { return _mode; }
        set
        {
            _mode = value;
            GD.Print("set mode ", _mode);

            switch (mode)
            {
                case Mode.GridMap:
                    _get_cell_item = (position) => gridmap.GetCellItem(position);
                    _set_cell_item = (position, item, orientation) => gridmap.SetCellItem(position, item, orientation);
                    _clear = () => gridmap.Clear();

                    break;
                case Mode.GridMapDictionary:
                    _get_cell_item = (position) => gridmap_dictionary.GetValueOrDefault(position, -1);

                    _set_cell_item = (position, item, orientation) =>
                    {
                        if (item == -1)
                        {
                            gridmap_dictionary.Remove(position);
                        }
                        else
                        {
                            gridmap_dictionary[position] = item;
                        }
                    };

                    _clear = () => gridmap_dictionary.Clear();
                    break;
            }

        }
    }


    // hooks
    Func<Vector3I, int> _get_cell_item;
    Action<Vector3I, int, int> _set_cell_item;
    Action _clear;
