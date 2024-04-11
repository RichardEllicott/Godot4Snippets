
#// Bresenham in 3D (ported from CSharp to GDScript)
#// ported to suit Godot from:
#// https://www.geeksforgeeks.org/bresenhams-algorithm-for-3-d-line-drawing/
func Bresenham3D(from: Vector3i, to: Vector3i):

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
