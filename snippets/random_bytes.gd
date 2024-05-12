"""

for generating random keys etc for example as a token


"""

## random bytes with optional input rng (for procedural)
## examples:
## print(get_random_bytes(8).hex_encode()) # print 8 random bytes as hex
## print(Marshalls.raw_to_base64(get_random_bytes(8))) # print 8 random bytes in base64
##
static func get_random_bytes(count: int, rng: RandomNumberGenerator = RandomNumberGenerator.new()) -> PackedByteArray:
    var bytes = PackedByteArray()
    bytes.resize(count) 
    for i in count:
        bytes[i] = rng.randi() % 255
    return bytes

    
# random string gets bytes also
static func _get_random_string(count = 8, seed = null, chars: String = "0123456789abcdef") -> String:
    var rng: RandomNumberGenerator = RandomNumberGenerator.new()
    if seed:
        rng.seed = seed
    else:
        rng.randomize()
    var s = ""
    for i in count:
        s += chars[rng.randi() % chars.length()]
    return s

# used for a password generator
static func _get_random_password(count = 8, seed = null) -> String:
    var chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
#    chars += "!£$%^&*()_+-=[]#{}~;':@,.<>?"
    return _get_random_string(count, seed, chars)
    
    

