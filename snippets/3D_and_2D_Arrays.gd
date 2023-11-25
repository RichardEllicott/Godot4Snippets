"""

it is possible to use a serial array like a 2D or 3D Array, some do not seem to know this trick

however it is a bit of a pain to set up, especially in 3D, this objects demos a 3D array

"""




## a 3d array
## internally uses one giant long array, even a packed one
## this makes it more effecient than nested arrays
## note the array does make an assumption z is the "floor" when generating a string
## EXAMPLE USAGE:
## 
## var array2d = Array3D.new(Vector3i(8,8,1)) # 2D var array
## var array3d = Array3D.new(Vector3i(8,8,8), PackedInt32Array()) # 3D int array
##
## WARNING, using 3 dimensions can use a crazy amount of memory!
class Array3D:
    
    var _size: Vector3i # dimensions of array (private)
    var _array # the array itself (private)
    
    ## setting the size may trigger the array to have to copy (slow)
    var size: Vector3i:
        get:
            return _size
        set(val):
            set_size(val)
    
    ## resize entire array (expensive)
    ## will copy all data it can, drop data that doesn't fit   
    func set_size(new_size: Vector3i):
        
        if new_size != _size: # only resize if we change the size
            
            var new_data = _array.duplicate() # duplicate (will ensure same array type)
            new_data.clear() # clear it as the order no longer makes sense
            new_data.resize(new_size.x * new_size.y * new_size.z) # set to new size
            
            # copy area is smallest common area   
            var copy_area = _size             
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
                        var i = x + y * _size.x + z * _size.x * _size.y # old array ref
                        var i2 = x + y * new_size.x + z * new_size.x * new_size.y #  new array ref
                        new_data[i2] = _array[i]
                        
            _array = new_data
            _size = new_size
    
    ## we can optionally pass an array like PackedInt32Array()
    func _init(size, array = []):
        
        if size is Vector2i:
            size = Vector3i(size.x, size.y, 1)
        assert(size is Vector3i)
                
        _size = size
        _array = array
        
        var target_size = _size.x * _size.y * _size.z
        
        if array.size() == 0: # typically the array size should be 0 at this point
            array.resize(target_size) # this will crash if not a type of Array
        else:
            ## we can pass in a filled array if we like
            ## this assert stops the wrong dimensions being passed in
            assert(array.size() == target_size)
            
    ## get the value at a position, for 2D, use z=0
    func get_value(pos: Vector3i):
        var i = pos.x + pos.y * _size.x + pos.z * _size.x * _size.y # inline
        return _array[i]
        
    func set_value(pos: Vector3i, value):
        var i = pos.x + pos.y * _size.x + pos.z * _size.x * _size.y # inline
        _array[i] = value
    
    ## 2D functions assume z to be 0
    func get_value_2d(pos: Vector2i):
        var i = pos.x + pos.y * _size.x # inline
        return _array[i]
        
    ## 2D functions assume z to be 0
    func set_value_2d(pos: Vector2i, value):
        var i = pos.x + pos.y * _size.x # inline
        _array[i] = value
    
    ## gets a string to visualize the array
    ## the string is actually the same serial array but arranged to look like floors
    ## string can therefore be pasted back into godot
    func get_string() -> String:
        var s = ""
        for z in _size.z: # for all floors
            for y in _size.y: # for all rows   
                for x in _size.x: # add a csv style row
                    s += "%s, " % get_value(Vector3i(x,y,z))
                s += "\n"
            s += "\n" # seperate z floors with a gap        
        return s

## a 3D array can get huge
## we can use a dictionary for a dimensionless array instead
## this would use less memory if sparsely filled, more if full
class DictArray3D:
    
    var _dictionary: Dictionary
    func _init():
        _dictionary = {}
        
    func set_value(pos: Vector3i, value):
        if value == null:
            _dictionary.erase(pos)
        else:
            _dictionary[pos] = value
        
    func get_value(pos: Vector3i):
        return _dictionary.get(pos)
    
## example usage of the array
func macro_test_array3d():
    
    var array3d 
    
    # using PackedInt32Array
    array3d = Array3D.new(Vector3i(8,8,1), PackedInt32Array())
    array3d.set_value(Vector3i(1, 3, 0), 4)
    array3d.set_value(Vector3i(2, 2, 0), 4)
    array3d.set_value(Vector3i(2, 1, 0), 4)
    print("ARRAY:")
    print(array3d.get_string())
    array3d.size = Vector3i(4,4,2)
    print("ARRAY:")
    print(array3d.get_string())
    
    # using Array
    array3d = Array3D.new(Vector3i(8,8,1), [])
    array3d.set_value(Vector3i(1, 3, 0), 4)
    array3d.set_value(Vector3i(2, 2, 0), 4)
    array3d.set_value(Vector3i(2, 1, 0), 4)
    print("ARRAY:")
    print(array3d.get_string())
    array3d.size = Vector3i(4,4,2)
    print("ARRAY:")
    print(array3d.get_string())
    
    # dict version for comparison
    array3d = DictArray3D.new()
    array3d.set_value(Vector3i(1, 3, 0), 4)
    array3d.set_value(Vector3i(2, 2, 0), 4)
    array3d.set_value(Vector3i(2, 1, 0), 4)
    print("ARRAY:")
    print(array3d._dictionary)
    array3d.size = Vector3i(4,4,2)
    print("ARRAY:")
    print(array3d._dictionary)
