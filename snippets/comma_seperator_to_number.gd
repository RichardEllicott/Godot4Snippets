"""

  adding commas to a number like 1000 => 1,000
  
"""
  
  

# https://ask.godotengine.org/18559/how-to-add-commas-to-an-integer-or-float-in-gdscript
# added sep option
static func comma_sep(n: int, sep: String = ",") -> String:
    var result := ""
    var i: int = abs(n)
    
    while i >= 1000:
        result = "%s%03d%s" % [sep, i % 1000, result]
        i /= 1000
        
    return "%s%s%s" % ["-" if n < 0 else "", i, result]
