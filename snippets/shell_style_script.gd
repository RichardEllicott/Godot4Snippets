

## split command lines like a shell console
## split by spaces but uses quotes to allow spaces
## command "par1 is in quotes" pa2_no_quotes
## => ["par1 is in quotes", "pa2_no_quotes"]
##
func tcl_split(s, split_char = " ") -> Array[String]:
    
    var build = ""
    
    var quote1 = false
    
    var ret: Array[String] = []
    
    var escape_mode = false
    
    s += split_char
    
    for char in s:
        
        if char == '"' and not escape_mode: # quotes flip the quote mode
            quote1 = not quote1
            
        if not quote1:
            if char == split_char:
                
                # if surrounded by quotes, remove them
                if build.length() > 2:
                    if build.begins_with('"') and build.ends_with('"'):
                        build = build.substr(1, build.length() - 2)
                        
                # clear surrounding whitespace
                build = build.strip_edges(true, true) # strip extra whitespace
                
                ret.append(build)
                build = ""
            else:
                build += char
        else:
            build += char
            
        escape_mode = false # untested escape char mode
        if char == "\\":
            escape_mode = true
                    
    return ret
