"""
adding to a label like a console log

"""

## allow selecting label in editor
@export var _label: NodePath = "Label"
var label: Node:
    get:
        if not label: label = get_node_or_null(_label)
        return label

var log: Array[String] = []
var log_max: int = 100
func add_to_log(s: String) -> void:
    log.append(s)
    if log.size() > log_max:
        log.pop_front()
    label.text = "\n".join(log)
