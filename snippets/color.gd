"""

saturate colors


"""

## takes a colour and saturates it ie dark yellow becomes fully saturated yellow, navy blue becomes blue
## written as i couldn't find a Color to HSV function
static func saturate_color(color: Color) -> Color:
    
    var pole
    if color.r > color.g:
        if color.r > color.b:
            pole = 0
        else:
            pole = 2
    else:
        if color.g > color.b:
            pole = 1
        else:
            pole = 2
    
    var _scale
    match pole:
        0:
            _scale = 1.0/color.r
        1:
            _scale = 1.0/color.g
        2:
            _scale = 1.0/color.b
            
    color.r *= _scale
    color.g *= _scale
    color.b *= _scale
    
    return color
