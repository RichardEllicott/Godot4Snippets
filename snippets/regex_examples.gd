"""

regex patterns and examples

cheat sheet (perl compatible regex):
https://www.debuggex.com/cheatsheet/regex/pcre



"""

## match exact string is a little off, see here:
## https://predictivehacks.com/?all-tips=regular-expression-for-exact-match

## match exactly "match string"
"(?i)(?<!\w)match string(?!\w)"

match starting with "start string"
"^start string"

## match exactly "_ready" or starts with "macro" (used for my tool macros)
"(?i)(?<!\w)_ready(?!\w)|^macro" 

## match tags "<tag1> hello world <tag2> stuff" => ["<tag1>", "<tag2>"]
## based on: https://www.computerworld.com/article/2784456/using-regular-expressions-to-identify-xml-tags.html
"(<.[^(><.)]+>)"

## match between xml tags ??? unsure about this, also might not exclude larger matches giving bad results
## from here https://community.splunk.com/t5/Splunk-Search/How-to-extract-a-string-from-a-particular-XML-tags-with-regular/m-p/440397
## will sort out if i use it!
"<tag>(?<Rmk>[^<]*)</tag>" # between xml tags like <tag>hello world</tag>









