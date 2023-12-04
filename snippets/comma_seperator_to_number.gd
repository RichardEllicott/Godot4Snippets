"""

adding commas to a number like 1000 => 1,000


see also:
https://github.com/RichardEllicott/Godot4Snippets/blob/main/snippets/metric_prefix_to_number.gd
  
"""

# https://ask.godotengine.org/18559/how-to-add-commas-to-an-integer-or-float-in-gdscript
# added sep option, elegant solution (short and recursive)
static func comma_sep(n: int, sep: String = ",") -> String:
    var result := ""
    var i: int = abs(n)
    
    while i >= 1000:
        result = "%s%03d%s" % [sep, i % 1000, result]
        i /= 1000
        
    return "%s%s%s" % ["-" if n < 0 else "", i, result]


    
## looks less elegant no recursion
## but works with floats and might be faster (less sums?)
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
