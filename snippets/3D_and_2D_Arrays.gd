"""

it is possible to use a serial array like a 2D or 3D Array, some do not seem to know this trick

however it is a bit of a pain to set up, especially in 3D, this objects demos a 3D array

this object allows creating an Array
get and setting it in 2D/3D
resizing the array


"""
class_name MyArrays



## EXAMPLE
## get_value(pos)
## set_value(pos, value)
class Array3D:
    var _size: Vector3i  # dimensions of array (private)
    var _array  # the array itself (private)

    ## setting the size may trigger the array to have to copy (slow)
    ## may loose data if we crop the area
    var size: Vector3i:
        get:
            return _size
        set(val):
            set_size(val)
    
    ## empty all the values of the array
    func clear():
        _array.clear()
        _array.resize(size.x * size.y * size.z)

    func set_size(new_size: Vector3i):
        if new_size != _size:  # only resize if we change the size
            var new_data = _array.duplicate()  # duplicate (will ensure same array type)
            new_data.clear()  # clear it as the order no longer makes sense
            new_data.resize(new_size.x * new_size.y * new_size.z)  # set to new size

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
                        var i = x + y * _size.x + z * _size.x * _size.y  # old array ref
                        var i2 = x + y * new_size.x + z * new_size.x * new_size.y  #  new array ref
                        new_data[i2] = _array[i]

            _array = new_data
            _size = new_size

    ## we can optionally pass an array like PackedInt32Array()
    func _init(size: Vector3i, array = []):
        if not array is Array:  # we try to only allow "Array" or "Packed*"
            var s = var_to_str(array)
            assert(s.begins_with("Packed"))

        _size = size
        _array = array

        var target_size = _size.x * _size.y * _size.z

        if array.size() == 0:  # typically the array size should be 0 at this point
            array.resize(target_size)  # this will crash if not a type of Array
        else:
            ## we can pass in a filled array if we like
            ## this assert stops the wrong dimensions being passed in
            assert(array.size() == target_size)

    ## get the value at a position, for 2D, use z=0
    func get_value(pos: Vector3i):
        var i = pos.x + pos.y * _size.x + pos.z * _size.x * _size.y  # inline
        return _array[i]

    func set_value(pos: Vector3i, value):
        var i = pos.x + pos.y * _size.x + pos.z * _size.x * _size.y  # inline
        _array[i] = value

    ## get a 2D array
    static func get_2d_array(size: Vector2i, array = []):
        return Array3D.new(Vector3i(size.x, size.y, 1), array)

    ## 2D functions assume z to be 0
    func get_value_2d(pos: Vector2i):
        var i = pos.x + pos.y * _size.x  # inline
        return _array[i]

    ## 2D functions assume z to be 0
    func set_value_2d(pos: Vector2i, value):
        var i = pos.x + pos.y * _size.x  # inline
        _array[i] = value

    ## pastabe string simple version
    func _to_string_simple() -> String:
        var indent = "    "
        var s = ""
        s += "Array3D.new(%s, " % var_to_str(_size)
        s += var_to_str(_array)
        s += ")"
        return s

    ## build the array as a printable string
    func build_print_array():
        var indent = "    "
        var s = ""
        s += "[\n"
        for z in _size.z:  # for all floors
            for y in _size.y:  # for all rows
                s += indent  # lines start with indent
                for x in _size.x:  # add a csv style row
                    s += "%s, " % var_to_str(get_value(Vector3i(x, y, z)))
                s += "\n"
            if z != _size.z - 1:
                s += "\n"  # seperate z floors with a gap
        s += "]"
        return s

    ## convert the object to a string representation
    ## pastable for the var version anyway
    func _to_string() -> String:
        var indent = "    "
        var s = ""
        s += "Array3D.new(%s, " % var_to_str(_size)

        var s2 = "%s"  # this string is for the array
        var array_string: String = var_to_str(_array)
        if array_string.begins_with("Packed"):  # we detected Packed arrays
            s2 = array_string.split("(")[0] + "(%s)"

        s += s2
        s += ")"

        s = s % build_print_array()

        return s

    

## a 3D array can get huge so sometimes it's better just to use a dictionary, and also far easier as this small object shows
## this would use less memory if sparsely filled, more if full
## it has an advantage that it is never full, we don't have to specify dimensions
class DictionaryArray3D:
    
    var _dictionary: Dictionary
    func _init():
        _dictionary = {}
    
    ## set value, null will delete
    func set_value(pos: Vector3i, value):
        if value == null:
            _dictionary.erase(pos)
        else:
            _dictionary[pos] = value
    
    ## get value, null assumed empty
    func get_value(pos: Vector3i):
        return _dictionary.get(pos)



func macro_test_array3d():
    
    var array3d 
    
    # using PackedInt32Array
    array3d = MyArrays.Array3D.new(Vector3i(8,8,1), PackedInt32Array())
    array3d.set_value(Vector3i(1, 3, 0), 4)
    array3d.set_value(Vector3i(2, 2, 0), 4)
    array3d.set_value(Vector3i(2, 1, 0), 4)
    print("ARRAY:")
    print(array3d)
    array3d.size = Vector3i(4,4,2)
    print("ARRAY:")
    print(array3d)
    
    # using Array
    array3d = MyArrays.Array3D.new(Vector3i(8,8,1), [])
    array3d.set_value(Vector3i(1, 3, 0), 4)
    array3d.set_value(Vector3i(2, 2, 0), 4)
    array3d.set_value(Vector3i(2, 1, 0), 4)
    print("ARRAY:")
    print(array3d)
    array3d.size = Vector3i(4,4,2)
    print("ARRAY:")
    print(array3d)
    
    
    # dict version for comparison
    array3d = MyArrays.DictionaryArray3D.new()
    array3d.set_value(Vector3i(1, 3, 0), 4)
    array3d.set_value(Vector3i(2, 2, 0), 4)
    array3d.set_value(Vector3i(2, 1, 0), 4)
    print("ARRAY:")
    print(array3d._dictionary)
    array3d.size = Vector3i(4,4,2)
    print("ARRAY:")
    print(array3d._dictionary)
