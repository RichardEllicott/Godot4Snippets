"""
adding to a label like a console log

"""

var log: Array[String] = []
var log_max: int = 100
func add_to_log(s: String) -> void:
    log.append(s)
    if log.size() > log_max:
        log.pop_front()
    $Label.text = "\n".join(log)
