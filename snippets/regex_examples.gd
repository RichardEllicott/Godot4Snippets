"""
"""

## match exact string is a little off, see here:
## https://predictivehacks.com/?all-tips=regular-expression-for-exact-match

"(?i)(?<!\w)match string(?!\w)" # matches exactly "match string"
"^start string" # matches starting with "start string"
"(?i)(?<!\w)_ready(?!\w)|^macro" # matches exactly "_ready" or (the | character) starts with "macro" (used for my tool macros)


"<tag>(?<Rmk>[^<]*)</tag>" # between xml tags like <tag>hello world</tag>



## using regex to pattern match, similar to a glob:

var regex: RegEx = RegEx.new()
regex.compile("(?i)(?<!\w)_ready(?!\w)|^macro")

if regex.search != null:
    # if the search is not null, we must have a match
    pass



