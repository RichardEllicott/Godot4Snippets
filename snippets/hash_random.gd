"""
this random object saves a state in bytes from the result of Sha256's

shows how we can get random numbers that we could reproduce on other systems
  
"""

class HashRandom:
    
    var state: PackedByteArray = PackedByteArray([0])
    var ctx: HashingContext = HashingContext.new()
    
    func seed(input):
        input = String(input)
        state = _hash(input.to_utf8_buffer())
    
    func _init():
        pass
        
    func get_int() -> int:
        
        return state.decode_s64(0)
        
    func _hash(input: PackedByteArray):
        #ctx = HashingContext.new()
        ctx.start(HashingContext.HASH_SHA256)
        ctx.update(input)
        return ctx.finish()
        
    func next() -> PackedByteArray:
        state = _hash(state)
        return state
        
    func test():
        print("run random test...")
        
        var count = 1024
        var total = 0.0
        var min = 0.0
        var max = 0.0
        
        for i in count:
            next()
            #print(hr.state.hex_encode().substr(0, 8))        
            var number = get_int() / float(2**63)
            
            total += number
            
            if number < min:
                min = number
            elif number > max:
                max = number
            
            print(number)
            #print(hr.state)
        print("average: ", total / count)
        print("min: ",  min)
        print("max: ",  max)


# simple hash example
func sha256(input: PackedByteArray) -> PackedByteArray:
    var ctx: HashingContext = HashingContext.new()
    ctx.start(HashingContext.HASH_SHA256)
    ctx.update(input)
    return ctx.finish()
