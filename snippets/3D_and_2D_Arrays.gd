"""

it is possible to use a serial array like a 2D or 3D Array, some do not seem to know this trick

however it is a bit of a pain to set up, especially in 3D, this objects demos a 3D array

"""



## a 3d array
## internally uses one giant long array, even a packed one
## this makes it more effecient than nested arrays
## note the array does make an assumption z is the "floor" when generating a string
## EXAMPLE USAGE:

class Array3D:
    
    var size: Vector3i # dimensions of the 3D array
    
    var array # can be array or packed array like PackedInt32Array
    
    ## resize entire array (expensive)
    ## will copy all the data accross if we increase the array size
    ## will crop data that doesn't fit (delete)
    ## empty cells will get a default value like null or 0 depending on array type
    func resize(new_size: Vector3i):
        
        var new_data = array.duplicate() # duplicate (will ensure same array type)
        new_data.clear() # clear it as the order no longer makes sense
        new_data.resize(new_size.x * new_size.y * new_size.z) # set to new size
        
        # copy area is smallest common area   
        var copy_area = size             
        if copy_area.x > new_size.x:
            copy_area.x = new_size.x
        if copy_area.y > new_size.y:
            copy_area.y = new_size.y
        if copy_area.z > new_size.z:
            copy_area.z = new_size.z
        
        # copy all the data accross 
        for z in copy_area.z:
            for y in copy_area.y:
                for x in copy_area.x:
                    var i = x + y * size.x + z * size.x * size.y # old array ref
                    var i2 = x + y * new_size.x + z * new_size.x * new_size.y #  new array ref
                    new_data[i2] = array[i]
                    
        array = new_data
        size = new_size
    
    ## we can optionally pass an array like PackedInt32Array()
    func _init(_size: Vector3i, _array = []):
                
        size = _size
        array = _array
        
        var target_size = size.x * size.y * size.z
        
        if array.size() == 0: # typically the array size should be 0 at this point
            array.resize(target_size) # this will crash if not a type of Array
        else:
            ## we can pass in a filled array if we like
            ## but it MUST have the correct dimensions
            assert(array.size() == target_size)
            
    
        
        
    ## get the value at a position, for 2D, use z=0
    func get_value(pos: Vector3i):
        var i = pos.x # inline to avoid passing value types
        i += pos.y * size.x
        i += pos.z * size.x * size.y
        return array[i]
        
    func set_value(pos: Vector3i, value):
        var i = pos.x # inline to avoid passing value types
        i += pos.y * size.x
        i += pos.z * size.x * size.y
        array[i] = value
    
    ## gets a string to visualize the array
    ## the string is actually the same serial array but arranged to look like floors
    ## string can therefore be pasted back into godot
    func get_string() -> String:
        var s = ""
        for z in size.z: # for all floors
            for y in size.y: # for all rows   
                for x in size.x: # add a csv style row
                    s += "%s, " % get_value(Vector3i(x,y,z))
                s += "\n"
            s += "\n" # seperate z floors with a gap        
        return s

    
func macro_test_array3d():
    
    # using PackedInt32Array
    var array3d = Array3D.new(Vector3i(8,8,1), PackedInt32Array())
    array3d.set_value(Vector3i(1, 3, 0), 4)
    array3d.set_value(Vector3i(2, 2, 0), 4)
    array3d.set_value(Vector3i(2, 1, 0), 4)
    print("ARRAY:")
    print(array3d.get_string())
    array3d.resize(Vector3i(4,4,2))
    print("ARRAY:")
    print(array3d.get_string())
    
    # using Array
    array3d = Array3D.new(Vector3i(8,8,1), [])
    array3d.set_value(Vector3i(1, 3, 0), 4)
    array3d.set_value(Vector3i(2, 2, 0), 4)
    array3d.set_value(Vector3i(2, 1, 0), 4)
    print("ARRAY:")
    print(array3d.get_string())
    array3d.resize(Vector3i(4,4,2))
    print("ARRAY:")
    print(array3d.get_string())
