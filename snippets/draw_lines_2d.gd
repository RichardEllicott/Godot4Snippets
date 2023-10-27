"""
quick 2D drawing


"""


## draw an array of coordinates as lines

## no point! use "draw_polyline" keeping as notes incase i forget!



func _draw_array_lines(coors: Array, color: Color = Color.WHITE, width: float = -1.0, antialiased: bool = true):
    for i in coors.size() - 1:
        draw_line(coors[i], coors[i + 1], color, width, antialiased)
