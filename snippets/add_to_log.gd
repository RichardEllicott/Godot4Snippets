"""
adding to a label like a console log

"""

# simple log, adds only a max number of lines
var log = []
var log_max: int = 16
func add_to_log(s: String) -> void:    
    log.append_array(s.split("\n"))
    while log.size() > log_max:
        log.pop_front()
        
var log_text: String:
    get:
        return "\n".join(log)
