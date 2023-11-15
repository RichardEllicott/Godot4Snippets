"""
interpolate an array of floats

a graph of data for example could be represented as an array of float values, assumed of equal step

this quick dirty method will not smooth out the graph, so concider generating the data from numpy with many steps
numpy is capable of reinterpolating data to be suitable for usage

i made it for this rough polar data for a boat from here:
https://www.researchgate.net/publication/235639420_Omni-Directional_Camera_and_Fuzzy_Logic_Path_Planner_for_Autonomous_Sailboat_Navigation

"""

## example data could be higher resolution, can use numpy for this (make a cubic spline)
var data = [0.0, 5.0, 6.0, 5.5, 5.0, 5.0]

## input an array of data like floats or colors
## get the value at a position from 0 to 1, where 0 is the start and 1 the end of the array
static func lerp_array(data: Array, pos: float):

    pos = fmod(pos, 1.0)
    
    var div = data.size() - 1 # the total divisions is the amount of spaces in between the data values
    
    var seg_pos = int(pos * div) # our seg pos is the first lerp pos
    
    var lerp1 = data[seg_pos]
    var lerp2 = data[seg_pos + 1]
    
    # we find the position between the values
    var lerp_pos = pos - (seg_pos / float(div)) # chop off the number that is the segment
    lerp_pos = lerp_pos * float(div) # a bit confusing but works

    return lerp(lerp1, lerp2, lerp_pos) # pos between 0-1
    
    
    
func macro_test():
    
    var divs = 128
    
    data = [0.0, 5.0, 6.0, 5.5, 5.0, 5.0]
        
    for i in divs:
        
        var angle = i / float(divs)

        var polar = lerp_array(data, angle)
        
        
        print("angle: %.2f polar: %.2f" % [angle, polar])
