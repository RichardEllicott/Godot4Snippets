
#// Bresenham in 3D (ported from CSharp to GDScript)
#// ported to suit Godot from:
#// https://www.geeksforgeeks.org/bresenhams-algorithm-for-3-d-line-drawing/
static func Bresenham3D(from: Vector3i, to: Vector3i):

    var ListOfPoints = []

    ListOfPoints.append(from)
    var dx: int = abs(to.x - from.x)
    var dy: int = abs(to.y - from.y)
    var dz: int = abs(to.z - from.z)
    var xs: int
    var ys: int
    var zs: int
    if (to.x > from.x):
        xs = 1
    else:
        xs = -1
    if (to.y > from.y):
        ys = 1
    else:
        ys = -1
    if (to.z > from.z):
        zs = 1
    else:
        zs = -1

    #// Driving axis is X-axis"
    if (dx >= dy && dx >= dz):
    #{
        var p1: int = 2 * dy - dx
        var  p2: int = 2 * dz - dx
        while (from.x != to.x):

            from.x += xs
            if (p1 >= 0):
                
                from.y += ys
                p1 -= 2 * dx

            if (p2 >= 0):

                from.z += zs
                p2 -= 2 * dx

            p1 += 2 * dy
            p2 += 2 * dz
            ListOfPoints.append(from)

        #// Driving axis is Y-axis"

    elif (dy >= dx && dy >= dz):

        var p1 = 2 * dx - dy
        var p2 = 2 * dz - dy
        while (from.y != to.y):
        #{
            from.y += ys
            if (p1 >= 0):

                from.x += xs
                p1 -= 2 * dy

            if (p2 >= 0):

                from.z += zs
                p2 -= 2 * dy

            p1 += 2 * dx
            p2 += 2 * dz
            ListOfPoints.append(from)

        #// Driving axis is Z-axis"

    else:

        var p1: int = 2 * dy - dz
        var p2: int = 2 * dx - dz
        while (from.z != to.z):

            from.z += zs
            if (p1 >= 0):

                from.y += ys
                p1 -= 2 * dz

            if (p2 >= 0):

                from.x += xs
                p2 -= 2 * dz

            p1 += 2 * dy
            p2 += 2 * dx
            ListOfPoints.append(from)

    return ListOfPoints




#// return a square shaped "shell" aroud a position, used for line of sight to check outwards from 2D rouguelike player
#// order should be 1 or more
#// i think the shells are probabally more simple and useful than the snake
static func Shell2D(origin: Vector3i, order: int) -> Array[Vector3i]:
#{
    var positions: Array[Vector3i] = []

    if (order == 0): #// do we need this?
        positions.append(origin);
        return positions;

    var line_length: int = 2 * order;
    var line_start1: Vector3i = Vector3i(order, 0, order);
    var line_start2: Vector3i = Vector3i(-order, 0, order);
    var line_start3: Vector3i = Vector3i(-order, 0, -order);
    var line_start4: Vector3i = Vector3i(order, 0, -order);

    for i in line_length:
    
        var vec1 = Vector3i(0, 0, -1) * i; #// +x
        positions.append(origin + vec1 + line_start1)

        var vec2 = Vector3i(1, 0, 0) * i; #// +z
        positions.append(origin + vec2 + line_start2)

        var vec3 = Vector3i(0, 0, 1) * i; #// -x
        positions.append(origin + vec3 + line_start3)

        var vec4 = Vector3i(-1, 0, 0) * i; #// -z
        positions.append(origin + vec4 + line_start4)

    return positions;
