"""
extract custom tags from strings, used to add instructions to blender objects, tested Godot 4

"""

## tag extract discreet version:
## tags like <tag <subtag>> will return back as "tag <subtag>"
## but normally throws error as max_nest = 1!
static func tag_extract(input_string: String, open_symbol: String = '<', close_symbol: String = '>') -> Array[String]:

    var nesting: int = 0
    var text: String = "" # store all text not in tags
    var tags: Array[String] = []
    var bracketed_text: String = ""
    var max_nest: int = 1

    for _char in input_string:
        
        if _char == open_symbol: ## when we open the brackets
            nesting += 1
            if nesting > max_nest:
                push_error("tag extract nest exceeded %s (malformed xml)" % [max_nest])
            if nesting > 1: # as we are already nested so we store the < char
                bracketed_text += _char
            
        elif _char == close_symbol: ## when we close the brackets
            nesting -= 1
            if nesting > 0: # we still have a tag open so store the > char
                bracketed_text += _char
            
            if nesting == 0: # we must have closed the tag, so save this text
                tags.append(bracketed_text)
                bracketed_text = ""
            
        elif nesting == 0: # at nest zero no tags are open
            text += _char
        elif nesting > 0: # if tags open
            bracketed_text += _char
            
    if nesting > 0:
        push_error("tag extract, tag not closed (malformed xml)")

    return tags
    
    

## extract a string like found in an xml tag, seperates by spaces (ignoring quotes)
## for example:
## start text="hello there" par3
## =>
## ['start', 'text="hello there"', 'par3']
static func xml_tag_split(s: String) -> Array[String]:
    
    var result: Array = []
    var split_char: String = ' '
    var text: String = ""
    var is_split: bool = false
    var quotes_open: bool = false
    var quote_char: String = '"'
    var quote_char2: String = "'"
    
    for char in s:
            
        if char == quote_char or char == quote_char2: # if we find a quote char
            quotes_open = not quotes_open # flip quotes open
        
        if char == split_char and quotes_open == false: # if no quotes and we find a split char
            if not is_split: # start split
                if text.length() > 0:
                    result.append(text) # save last splits text
                    text = ""
                is_split = true
        else:
            is_split = false
            text += char
            
    if text.length() > 0: # some text may still be here
        result.append(text)
    return result


## shortcut for a quick regex cache
var _regex_cache = {}
func regex_cache(regex: String) -> RegEx:
    if not regex in _regex_cache:
        var regex2 = RegEx.new()
        regex2.compile(regex)
        _regex_cache[regex] = regex2
    return _regex_cache[regex]
    
## tag extract using the regex cache above, find all the things inside tags like "<tag1> hello world <tag2> stuff etc" => ["tag1", "tag2"]
func regex_tag_extract(s: String, open_tag = "<", close_tag = ">"):
    var results: Array[String] = []
    for result in regex_cache("(%s.[^(><.)]+%s)" % [open_tag, close_tag]).search_all(s): # this regex matches inside tags, trying to ignore invalid characters
        var result_string = result.get_string()
        results.push_back(result_string.substr(1,result_string.length() - 2)) # chop off the brackets for the return result
    return results
