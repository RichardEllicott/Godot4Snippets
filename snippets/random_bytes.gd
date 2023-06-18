"""

for generating random keys etc


"""

# random bytes with optional seed
static func _get_random_bytes(count = 8, seed = null):
    var rng: RandomNumberGenerator = RandomNumberGenerator.new()
    if seed:
        rng.seed = seed
    else:
        rng.randomize()
    var chars: String = "0123456789abcdef"
    var s = ""
    for i in count:
        s += chars[rng.randi() % 16]
    return s
