

# https://gist.github.com/andrew-wilkes/0c582c9a8d6d1553daef2027f8444a06

func sieve_of_eratosthenes(n: int):
    
    var nums = range(n + 1)
    for i in range(2, sqrt(n) + 1):
        var j = i * i
        while j <= n:
            nums[j] = 0
            j += i
    
    var primes: Array
    for p in nums:
        if p > 1:
            primes.append(p)
    print(primes)
