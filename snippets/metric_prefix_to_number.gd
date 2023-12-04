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
##
## alt mode=1 instead uses the ×10¹⁵ format popular in maths
static func metric_prefix(n: float, decimal_places: int = 3, mode: int = 0) -> String:
    
    #https://en.wikipedia.org/wiki/Metric_prefix
    var symbols = "kMGTPEZYRQ" # positive symbols
    var superscript_chars = "⁰¹²³⁴⁵⁶⁷⁸⁹" # superscript number chars for mode 1
    
    # UNUSED TODO
    var symbols2 = "mμnpfazyrq" # for later, the fractions like mili, micro, nano, pico
    
    var symbol = "" # we put the symbol here if applicable (n >= 1000)
    
    var s = str(abs(n)).split('.') # make a split of the positive number to count the characters
    
    var chunks_count = int((s[0].length() - 1) / 3.0) # the total chunks of 3 past 1 number, ie 1000000 is 6 zeros, 2 chunks
    
    if chunks_count > 0: # if we have at least one chunk we will add a symbol
        symbol = " %s" % symbols[chunks_count - 1]
        
        if mode == 1:            
            var chunks_count_string = str(chunks_count * 3)
            var _super = ""            
            for char in chunks_count_string:
                _super += superscript_chars[int(char)] # adds the correct supertype char
            symbol = "×10%s" % _super
            
        n /= 1000 ** chunks_count # divide the number by 1000, 1000000, 1000000000 etc
    
    n = snapped(n, 0.1 ** decimal_places) # snap to decimal places (leaves no trailing zeros)
    
    return "%s%s" % [n, symbol] # return a string
        
