"""

functions for implementing simple shell style script

"""

## split command lines like a shell console
## split by spaces but uses quotes to allow spaces
## command "par1 is in quotes" pa2_no_quotes
## => ["par1 is in quotes", "pa2_no_quotes"]
##
## split command lines like a shell console
## split by spaces but uses quotes to allow spaces
##
func tcl_split(s, split_char = " ") -> Array[String]:
    
    #s = s.replace("'", '"') # replace all quotes same?
    
    var build = ""
    
    var quote1 = false
    
    var strings: Array[String] = [] # build return
    
    var escape_mode = false
    
    s += split_char # add one extra character to trigger a split at the end
    
    for char in s:
        
        if char == '"' and not escape_mode: # quotes flip the quote mode
            quote1 = not quote1
            
        if not quote1:
            if char == split_char: # trigger a split
                
                # if surrounded by quotes, remove them
                if build.length() > 2:
                    if build.begins_with('"') and build.ends_with('"'):
                        build = build.substr(1, build.length() - 2) # inner string
                        
                # clear surrounding whitespace
                build = build.strip_edges(true, true) # strip extra whitespace
                
                strings.append(build) # save the string we are building to the return array
                build = ""
            else:
                build += char
        else:
            build += char # if in quote mode, just copy chars through
            
        escape_mode = false # untested escape char mode
        if char == "\\":
            escape_mode = true
                    
    return strings
