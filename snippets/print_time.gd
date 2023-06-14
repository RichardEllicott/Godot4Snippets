"""
time functions



"""

# https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_format_string.html

## convert a unix time number to a readable string
## built to display a time to the user like 03/06/2017 13:01:44
## 
## "{year}-{month}-{day} {hour}:{minute}:{second}" # military style, orders folders and doesn't confuse americans
## "{day}/{month}/{year} {hour}:{minute}:{second}" # UK style
##
## example (print current time)
## print(unix_time_to_timestamp(Time.get_unix_time_from_system()) + " UTC")

static func unix_time_to_timestamp(seconds: float, format: String = "{year}-{month}-{day} {hour}:{minute}:{second}") -> String:
    return format.format(Time.get_datetime_dict_from_unix_time(seconds))


## get a unix time from setting the year/month/day...
# built to make it easy to construct a made up future time in unix time, like the 31st century or something
static func unix_time_from_year(year = 2000, month = 1, day = 1, hour = 0, minute = 0, second = 0):
    
    var ret = OS.get_unix_time_from_datetime({
        'year' : year,
        'month' : month,
        'day' : day,
        'hour' : hour,
        'minute' : minute,
        'second' : second
        })
        
    return ret
    

static func get_time() -> float:
    return Time.get_ticks_usec() / 1000000.0 ## normal way to get the session time in seconds, using the more accurate cpu clock
    

Time.get_unix_time_from_system() # get the unix time from the clock
    
