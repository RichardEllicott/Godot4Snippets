"""

method of lerping an array, i made it for this rough polar data for a boat from here:

https://www.researchgate.net/publication/235639420_Omni-Directional_Camera_and_Fuzzy_Logic_Path_Planner_for_Autonomous_Sailboat_Navigation




"""


## input an array of data like floats or colors
## get the value at a position from 0 to 1, where 0 is the start and 1 the end of the array
func get_lerped_array(data: Array, pos: float):
    
    var div = data.size() - 1 # the total divisions is the amount of spaces in between the data values
    
    var seg_pos = int(pos * div) # our seg pos is the first lerp pos
    
    var lerp1 = data[seg_pos]
    var lerp2 = data[seg_pos + 1]
    
    # we find the position between the values
    var lerp_pos = pos - (seg_pos / float(div)) # chop off the number that is the segment
    lerp_pos = lerp_pos * float(div) # a bit confusing but works

    return lerp(lerp1, lerp2, lerp_pos) # pos between 0-1



## example:

data = [0.0, 5.0, 6.0, 5.5, 5.0, 5.0]
print(get_lerped_array(data, 0.253)







## OLD OBJECT:

## this object lerps a linear sequence of floats
class LerpArray:
    
    # a linear sequence of floats
    var data = [0.0, 5.0, 6.0, 5.5, 5.0, 5.0]
    
    # get a lerped value, input a pos between 0 to 1
    # the value returned will be inbetween one of te
    func get_lerped(pos: float):
        
        var div = data.size() - 1 # the total divisions is the amount of spaces in between the data values
        
        var seg_pos = int(pos * div) # our seg pos is the first lerp pos
        
        var lerp1 = data[seg_pos]
        var lerp2 = data[seg_pos + 1]
        
        # we find the position between the values
        var lerp_pos = pos - (seg_pos / float(div)) # chop off the number that is the segment
        lerp_pos = lerp_pos * float(div) # a bit confusing but works
    
        return lerp(lerp1, lerp2, lerp_pos) # pos between 0-1
        
    func test():
        
        var divs = 128
            
        for i in divs:
            
            var angle = i / float(divs)

            var polar = get_lerped(angle)
            
            
            print("angle: %.2f polar: %.2f" % [angle, polar])
