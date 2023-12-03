"""

  adding commas to a number like 1000 => 1,000
  
"""
  
  
# https://ask.godotengine.org/18559/how-to-add-commas-to-an-integer-or-float-in-gdscript
static func comma_sep(n: int) -> String:
    var result := ""
    var i: int = abs(n)
    
    var mode = 1

    while i > 999:
        result = ",%03d%s" % [i % 1000, result]
        i /= 1000

    return "%s%s%s" % ["-" if n < 0 else "", i, result]
