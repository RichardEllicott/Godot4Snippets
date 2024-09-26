"""

these color approximate "blackbody radiation" colors (for graphics not physics)

which is when something glows red, then orange, to yellow and then white
(not including any blue which might be appropiate for super hot blackbodies like stars)

based on this:
https://github.com/kennethmoreland-com/kennethmoreland-com.github.io/blob/master/color-advice/black-body/black-body.ipynb


function builds a simple equally spaced gradient

"""

## return array of fractions from 0 to 1
## for example like [0, 0.25, 0.5, 0.75, 1]
## the word "linspace" based on numpy.linspace()
static func get_linspace(length: int) -> Array:
    var ret := []
    for i in length:
        ret.append(float(i) / (length - 1.0))
    return ret

static func get_blackbody_gradient() -> Gradient:
    
    var x = 255.0
    
    var ret = Gradient.new()
    
    var color_count := 5 # note reading packed array count always goes wrong!
    
    ## rough blackbody radiation colors:
    ## https://github.com/kennethmoreland-com/kennethmoreland-com.github.io/blob/master/color-advice/black-body/black-body.ipynb
    var colors := PackedColorArray([
            Color(0, 0, 0, 1), # black
            Color(0.698, 0.1333, 0.1333, 1), # red
            Color(0.8902, 0.4118, 0.0196, 1), # orange
            Color(0.902, 0.902, 0.2078, 1), # yellow
            Color(1, 1, 1, 1) # white
            ])
            
    ret.colors = colors

    ret.offsets = PackedFloat32Array(get_linspace(color_count))
        
    return ret
