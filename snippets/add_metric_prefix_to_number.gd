"""

the metric prefix is this:
https://en.wikipedia.org/wiki/Metric_prefix

this function takes a number and reduces it to the best metric prefix plus an optional number of decimal places

"""



## add the metric prefix to long numbers, good when dealing with long numbers like meters vs km
## ie:
## 1100 => 1.1 k
## 1000000 => 1 M
## 1234000 => 1.234 M
static func metric_prefix(n: float, decimal_places: int = 3, suffix = "W") -> String:
    
    #https://en.wikipedia.org/wiki/Metric_prefix
    var symbols = "kMGTPEZYRQ" # positive symbols
    
    var symbols2 = "mμnpfazyrq" # for later, the fractions like mili, micro, nano, pico
    
    var symbol = "" # we put the symbol here if applicable (n >= 1000)
    
    var s = str(abs(n)).split('.') # make a split of the positive number to count the characters
    
    var chunks_count = int((s[0].length() - 1) / 3.0) # the total chunks of 3 past 1 number, ie 1000000 is 6 zeros, 2 chunks
    
    if chunks_count > 0: # if we have at least one chunk we will add a symbol
        symbol = symbols[chunks_count - 1]
        n /= 1000 ** chunks_count # divide the number by 1000, 1000000, 1000000000 etc
    
    n = snapped(n, 0.1 ** decimal_places) # snap to decimal places (leaves no trailing zeros)
    
    return "%s %s%s" % [n, symbol, suffix] # return a string
        
