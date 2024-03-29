"""

adding commas to a number like 1000 => 1,000


see also:
https://github.com/RichardEllicott/Godot4Snippets/blob/main/snippets/metric_prefix_to_number.gd
  
"""

## make a large number clearer to read, eg:
## 1000 => 1,000
## 1100000.123 => 1,100,000.123
## 
## improved version of below
## https://ask.godotengine.org/18559/how-to-add-commas-to-an-integer-or-float-in-gdscript
## supports decimal places, set -1 to disable
##
static func comma_seperator(n: float, decimal_places: int = 3, sep: String = ',') -> String:
    var result := ""
    var i: int = abs(n) # the abs int is the whole component
    
    var fraction: float = n - i # the fraction alone
    if decimal_places != -1:
        fraction = snapped(fraction, 0.1 ** decimal_places) # snap to decimal places (leaves no trailing zeros)
    var fraction_string = "" 
    if fraction > 0.0: # if we have a fraction
        fraction_string = ".%s" % str(fraction).split('.')[1] # use a string split to get the decimal part
            
    while i >= 1000: # recurses while over 1000
        result = "%s%03d%s" % [sep, i % 1000, result]
        i /= 1000
        
    return "%s%s%s%s" % ["-" if n < 0 else "", i, result, fraction_string]



## method using strings, works with floats, may be faster?
## it doesn't round properly however TODO??
## delete?
static func comma_sep2(n: float, sep: String = ","):
    
    var split = str(abs(n)).split('.') # split by decimal place, if no decimaal the split will 1 long
    var s0 = split[0] # the whole number part
    
    var chunks = [] # build chunks of 3 characters
    var chunk = "" # current chunk of 3 characters
    
    for i in s0.length(): # iterate our string
        var inv = s0.length() - i - 1 # backwards
        
        chunk = s0[inv] + chunk
        
        if i % 3 == 2:
            chunks.append(chunk)
            chunk = ""
                
    if chunk.length() > 0: # ensure all chunks added
        chunks.append(chunk) 
        
    chunks.reverse() # the chunks will be backwards
    
    var ret = ",".join(chunks) # join by the commas
    
    if split.size() == 2: # if we had a fraction
        ret = ret + ".%s" % split[1] # add it with a decimal point
    
    if n < 0.0: #add the minus back if negative
        ret = "-%s" % ret
    
    return ret



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
        
        var symbol_ref = chunks_count - 1
        if symbol_ref < symbols.length(): # this check may be pointless as the number is too large for a float anyway
            symbol = " %s" % symbols[symbol_ref]
        else:
            mode = 1 # we cannot get a symbol use the ×10¹⁵ format
        
        if mode == 1:            
            var chunks_count_string = str(chunks_count * 3)
            var _super = ""            
            for char in chunks_count_string:
                _super += superscript_chars[int(char)] # adds the correct supertype char
            symbol = "×10%s" % _super
            
        n /= 1000 ** chunks_count # divide the number by 1000, 1000000, 1000000000 etc
    
    n = snapped(n, 0.1 ** decimal_places) # snap to decimal places (leaves no trailing zeros)
    
    return "%s%s" % [n, symbol] # return a string
