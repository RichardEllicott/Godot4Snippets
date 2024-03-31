


## https://en.wikipedia.org/wiki/Linear_congruential_generator
class LCG:
    
    # borland c++
    # tested for 10'000'000
    var modulus: int = 2**31
    var multiplier: = 22695477
    var increment: int = 1
    
    var value = 226921453465477
    
    func next(): # run congrugal generator, returns an int
        value *= multiplier
        value += increment
        value = value % modulus
        return value
        
    func get_float():
        return float(value) / float(modulus)
        
    func test2():
        var results = []
        
        var total = 0
        
        var checks = 1000 # 10000000
        for i in checks:
            next()
            var result = get_float()
            #print(result)
            total += result
            results.append(result)
            
        var average = total / checks
        
        print("average: ", average)
            
        
            
        
    func test():
        
        var checks = 1000000 # 10000000
        
        var start_time = Time.get_ticks_usec()
        
        var null_dict = {}
        var results = []
        
        
        for i in checks:
            var result = next()
            null_dict[result] = null
            #print(result)
            results.append(result)
            
        var end_time = Time.get_ticks_usec()
        
        var time_taken = (end_time - start_time) / 1000000.0
        
        print(null_dict.size())
        
        print("time_taken: %s seconds" % time_taken)
        
        #print(results)
