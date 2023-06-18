"""

for generating random keys etc


"""

# random bytes with optional seed
static func _get_random_bytes(count: int, seed = null) -> PackedByteArray:
    var rng: RandomNumberGenerator = RandomNumberGenerator.new()
    
    if seed:
        rng.seed = seed
    else:
        rng.randomize()
        
    var bytes = PackedByteArray()
    bytes.resize(count) 
    for i in count:
        bytes[i] = rng.randi() % 255
        
    return bytes

func macro_random_bytes():
    var byte_string = _get_random_bytes(16,4)
    print(byte_string.hex_encode()) # show as a hex string
    
    
## adapt for password
static func _get_random_string(count = 8, seed = null, chars: String = "0123456789abcdef"):
    var rng: RandomNumberGenerator = RandomNumberGenerator.new()
    if seed:
        rng.seed = seed
    else:
        rng.randomize()
    var s = ""
    for i in count:
        s += chars[rng.randi() % 16]
    return s
