
// CS GridMap Pathfind based on Dijkstra's algorithm
// it behaves like a flood fill
// https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm

// Built here as a Node that can be created directly from GDScript (can't be accessed staticly, i decide to put up with this rather than create GDScript hooks)

// other grid type functions now also added, because roguelike AI would need all this
//
// so has become also a bit of a library to test Ling of Sight Algos and problems
//
// so added:
// Bresenham3D // draw lines on a grid, used for line of sight
// Shell2D // draw square type shells around a position, used to check outwards from a position

using System;
using System.Collections.Generic;
using System.Linq;
using Godot;



public static class Helper
{
    // public static bool is_instance_valid(Vector3I position, int item)
    // {
    //     bool result = item == -1;

    //     return result;
    // }

    public static bool test()
    {
        GD.Print("test function from C#!");
        return true;
    }


    // this is an Extenson to make it easier to check if node's are valid
    public static bool IsValid<T>(this T node) where T : Godot.GodotObject
    {
        return node != null
            && Godot.GodotObject.IsInstanceValid(node)
            && !node.IsQueuedForDeletion();
    }

}




[GlobalClass]
[Tool]
public partial class GridMapPathfindD : Node
{
    [Export]
    public GridMap gridmap; // target gridmap
    [Export]
    public bool mark_debug_gridmap;
    [Export]
    public GridMap debug_gridmap; // gridmap to mark
    [Export]
    public Vector3I from = new Vector3I(0, 0, 0);
    [Export]
    public Vector3I to = new Vector3I(8, 0, 8);
    [Export]
    public int max_checks = 1024 * 128; // just setting this very high so as to use max distance instead
    [Export]
    public int max_distance = 64; // set max_distance to -1 to ignore

    public Vector3I[] translations = {
            new Vector3I(0,0,-1),
            new Vector3I(1,0,0),
            new Vector3I(0,0,1),
            new Vector3I(-1,0,0),

            // new Vector3I(1,0,-1),
            // new Vector3I(1,0,1),
            // new Vector3I(-1,0,1),
            // new Vector3I(-1,0,-1),
        };

    public float[] translation_distances = {
            1,
            1,
            1,
            1,

            1.41421356237F,
            1.41421356237F,
            1.41421356237F,
            1.41421356237F,
        };

    public Func<Vector3I, int, bool> tile_valid_predicate = (pos, item) => item == -1; // predicate to check if we can move here, tile is not empty in this case
    public Func<Vector3I, int, bool> found_target_predicate; // predicate to check if we can move here, tile is not empty in this case


    public void set_default_predicates()
    {
        tile_valid_predicate = (pos, item) => item == -1;
        found_target_predicate = (x, y) => x == to;
    }


    public void set_debug_grid(Vector3I position, int item)
    {
        // if (debug_gridmap != null && Godot.GodotObject.IsInstanceValid(debug_gridmap))
        if (mark_debug_gridmap && debug_gridmap.IsValid())
        {

            debug_gridmap.SetCellItem(position, item);
        }
    }


    public Godot.Collections.Array pathfind(Vector3I from, Vector3I to)
    {
        this.from = from;
        this.to = to;
        found_target_predicate = (x, y) => x == to;
        return pathfind();
    }

    public Godot.Collections.Array pathfind()
    {
        found_target_predicate = (x, y) => x == to;
        return _pathfind_funct();
    }


    Godot.Collections.Dictionary<Vector3I, int> floodmap;

    public Godot.Collections.Array _pathfind_funct()
    {
        GD.Print("_pathfind_funct...");

        if (debug_gridmap != null && Godot.GodotObject.IsInstanceValid(debug_gridmap))
        {
            debug_gridmap.Clear();
        }

        // we use a dictionary to be a floodmap, we will mark cells we have visited with a distance number
        floodmap = new Godot.Collections.Dictionary<Vector3I, int>();

        // these parrel arrays contain tile check instructions
        // we will put future checks here at the back (Add/Append)
        // remove them from the front
        // the Array's must match, sometimes this pattern is faster than creating an Object
        var check_positions = new Godot.Collections.Array<Vector3I>(); // add new position to check here
        var check_distances = new Godot.Collections.Array<int>(); // add new position to check here
        // add our start position so we have an instruction for our loop
        check_positions.Add(from);
        check_distances.Add(0);

        int valid_count = 0; // count the valid checks, this could be used to measure the size of an island

        bool found_target = false; // did we sucessfully trigger our found_target_predicate, which means we found a target, usually the to

        Vector3I found_target_position = new Vector3I(); // where did we find the target, incase we serach for the nearest of some match for example

        int found_target_distance = -1; // the distance to the sucess match from the from

        for (int i = 0; i < max_checks; i++) // a for loop sets the max checks to stop halting, it will continue so long as we have outstanding data in [check_positions && check_distances]
        {
            if (check_positions.Count == 0) // // if no remaining checks
            {
                break; // exit loop
            }

            Vector3I check_position = check_positions[0]; // pop our position from the front (First In First Out)
            check_positions.RemoveAt(0);
            int check_distance = check_distances[0]; // pop our position from the front (First In First Out)
            check_distances.RemoveAt(0);

            int check_item = gridmap.GetCellItem(check_position); // find what item is in the check cell

            // validate this tile
            bool is_valid = tile_valid_predicate(check_position, check_item); // ensure check position is valid
            is_valid = is_valid && !floodmap.ContainsKey(check_position); // ensure we have not already checked this tile by checking for Vector3i key
            if (max_distance >= 0) is_valid = is_valid && check_distance <= max_distance; // ensure within max_distance, set max_distance to -1 to ignore


            if (is_valid)
            {
                set_debug_grid(check_position, 1);

                valid_count += 1;

                floodmap.Add(check_position, check_distance); // mark our cell as already checked

                if (found_target_predicate(check_position, check_item))
                { // if we find our target break the loop
                    set_debug_grid(check_position, 2);
                    found_target = true;
                    found_target_position = check_position;
                    found_target_distance = check_distance;
                    break;
                }

                // check each translation
                for (int i2 = 0; i2 < translations.Length; i2++)
                {
                    Vector3I translation = translations[i2];
                    Vector3I new_check = check_position + translation;

                    check_positions.Add(new_check);
                    check_distances.Add(check_distance + 1);
                }
            }

        }


        GD.Print("valid_count: ", valid_count);
        GD.Print("found_target: ", found_target);

        var return_path = new Godot.Collections.Array(); // buid a list to return for the path coordinates

        if (found_target)
        {

            Vector3I current_position = found_target_position;


            for (int i = 0; i < found_target_distance; i++)
            {


                int lowest_distance = 1000000;
                int correct_translation = -1;


                Vector3I next_pos = new Vector3I();


                // int distance = check_grid[current_position]; // i don't think we can find this on the first one 


                for (int i2 = 0; i2 < translations.Length; i2++)
                {
                    Vector3I translation = translations[i2];
                    Vector3I check_pos = current_position + translation;

                    if (floodmap.ContainsKey(check_pos))
                    {
                        int distance2 = floodmap[check_pos];

                        if (distance2 < lowest_distance) // if this check results in a lower distance, this is the best direction
                        {
                            next_pos = check_pos;
                            correct_translation = i2;
                            lowest_distance = distance2;
                        }

                    }
                }


                if (correct_translation != -1)
                {
                    current_position = current_position + translations[correct_translation];
                    // current_position = next_pos;

                    return_path.Add(current_position);

                    set_debug_grid(current_position, 2);
                }

            }


            return_path.Reverse();
            return_path.Add(found_target_position);



        }


        return return_path;

    }





    public void macro_test_pathfind()
    {
        pathfind();
    }

    public void macro_test123()
    {
        GD.Print("macro_test123...");
    }



    // Bresenham in 3D
    // ported to suit Godot from:
    // https://www.geeksforgeeks.org/bresenhams-algorithm-for-3-d-line-drawing/
    public static Godot.Collections.Array<Vector3I> Bresenham3D(Vector3I from, Vector3I to)
    {
        var ListOfPoints = new Godot.Collections.Array<Vector3I>();

        ListOfPoints.Add(from);
        int dx = Math.Abs(to.X - from.X);
        int dy = Math.Abs(to.Y - from.Y);
        int dz = Math.Abs(to.Z - from.Z);
        int xs;
        int ys;
        int zs;
        if (to.X > from.X)
            xs = 1;
        else
            xs = -1;
        if (to.Y > from.Y)
            ys = 1;
        else
            ys = -1;
        if (to.Z > from.Z)
            zs = 1;
        else
            zs = -1;

        // Driving axis is X-axis"
        if (dx >= dy && dx >= dz)
        {
            int p1 = 2 * dy - dx;
            int p2 = 2 * dz - dx;
            while (from.X != to.X)
            {
                from.X += xs;
                if (p1 >= 0)
                {
                    from.Y += ys;
                    p1 -= 2 * dx;
                }
                if (p2 >= 0)
                {
                    from.Z += zs;
                    p2 -= 2 * dx;
                }
                p1 += 2 * dy;
                p2 += 2 * dz;
                ListOfPoints.Add(from);
            }
            // Driving axis is Y-axis"
        }
        else if (dy >= dx && dy >= dz)
        {
            int p1 = 2 * dx - dy;
            int p2 = 2 * dz - dy;
            while (from.Y != to.Y)
            {
                from.Y += ys;
                if (p1 >= 0)
                {
                    from.X += xs;
                    p1 -= 2 * dy;
                }
                if (p2 >= 0)
                {
                    from.Z += zs;
                    p2 -= 2 * dy;
                }
                p1 += 2 * dx;
                p2 += 2 * dz;
                ListOfPoints.Add(from);
            }
            // Driving axis is Z-axis"
        }
        else
        {
            int p1 = 2 * dy - dz;
            int p2 = 2 * dx - dz;
            while (from.Z != to.Z)
            {
                from.Z += zs;
                if (p1 >= 0)
                {
                    from.Y += ys;
                    p1 -= 2 * dz;
                }
                if (p2 >= 0)
                {
                    from.X += xs;
                    p2 -= 2 * dz;
                }
                p1 += 2 * dy;
                p2 += 2 * dx;
                ListOfPoints.Add(from);
            }
        }
        return ListOfPoints;
    }


    public void draw_line(Vector3I from, Vector3I to, int val = 0)
    {
        var line = Bresenham3D(from, to);

        for (int i = 0; i < line.Count; i++)
        {
            var position = line[i];
            var position2 = line[line.Count - 1 - i];
            gridmap.SetCellItem(position, val);
            gridmap.SetCellItem(position2, val);

        }
    }


    // return a square shaped "shell" aroud a position, used for line of sight to check outwards from 2D rouguelike player
    // order should be 1 or more
    public static Godot.Collections.Array<Vector3I> Shell2D(Vector3I origin, int order)
    {
        var positions = new Godot.Collections.Array<Vector3I>();

        if (order == 0) // do we need this?
        {
            positions.Add(origin);
            return positions;
        }

        int line_length = 2 * order;
        Vector3I line_start1 = new Vector3I(order, 0, order);
        Vector3I line_start2 = new Vector3I(-order, 0, order);
        Vector3I line_start3 = new Vector3I(-order, 0, -order);
        Vector3I line_start4 = new Vector3I(order, 0, -order);

        for (int i = 0; i < line_length; i++) // the technique we use is to draw 4 lines at once
        {
            var vec1 = new Vector3I(0, 0, -1) * i; // +x
            positions.Add(vec1 + line_start1);

            var vec2 = new Vector3I(1, 0, 0) * i; // +z
            positions.Add(vec2 + line_start2);

            var vec3 = new Vector3I(0, 0, 1) * i; // -x
            positions.Add(vec3 + line_start3);

            var vec4 = new Vector3I(-1, 0, 0) * i; // -z
            positions.Add(vec4 + line_start4);
        }

        return positions;
    }


    // testing checking all around LOS
    public void macro_los_checker()
    {

        int range = 8;

        for (int i = 1; i <= range; i++)
        {
            var positons = Shell2D(from, i);

            for (int j = 0; j < positons.Count; j++)
            {
                var positon = positons[j];

                var check = los_check(from, positon); // this marks the grid

            }

            // var check = los_check()
        }



    }

    public void draw_shell_2D(Vector3I position, int order, int value = 0)
    {

        var cells = Shell2D(position, order);
        for (int i = 0; i < cells.Count; i++)
        {
            var cell = cells[i];
            gridmap.SetCellItem(cell, value);
        }

    }


    public void macro_test_Shell2D()
    {

        debug_gridmap.Clear();

        var shell_count = 8;

        for (int i = 0; i < shell_count; i++)
        {

            draw_shell_2D(new Vector3I(), i, i);



        }

    }



    // public void shell_pattern(Vector3I position, int shell_count = 8){

    //     for (int i = 0; i < shell_count; i++){

    //     }

    // }


    public Func<Vector3I, int, bool> visible_predicate = (position, value) => value == -1; // unblocked as in visible, we can see through




    public bool los_check(Vector3I from, Vector3I to)
    {

        bool ignore_from_position = false;
        var line = Bresenham3D(from, to);

        int view_range = 8;

        bool blocked = false;

        for (int i = 0; i < line.Count; i++)
        {
            if (ignore_from_position && i == 0)
            { // skip first one
                continue;
            }
            var position = line[i];
            var val = gridmap.GetCellItem(position);

            var distance = (from - to).Length();

            if (distance >= view_range)
            {
                blocked = true;
                break;
            }


            var visible = visible_predicate(position, val);

            if (!visible)
            { // blocked
                blocked = true;
            }

            if (debug_gridmap.IsValid())
            {

                if (blocked)
                {
                    debug_gridmap.SetCellItem(position, 1);
                }
                else
                {

                    debug_gridmap.SetCellItem(position, 2);
                }
            }



        }



        return !blocked;

    }



    public void macro_clear_gridmap()
    {
        if (gridmap.IsValid())
        {
            gridmap.Clear();
        }
    }

    public void macro_clear_debug_gridmap()
    {
        if (debug_gridmap.IsValid())
        {
            debug_gridmap.Clear();
        }
    }



    public void macro_test_Bresenham3D()
    {
        GD.Print("macro_test_Bresenham3D...");

        var data = Bresenham3D(from, to);
        GD.Print(data);

        draw_line(from, to, 1);



    }

}
