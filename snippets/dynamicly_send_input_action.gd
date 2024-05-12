

## i wondered if you could send an input action as a global signal
## you could, it is a bit unwise i will build a singleton maybe
  
func send_input_action(action = "ui_left", pressed = true):

    if not InputMap.has_action(action): ## dynamicly add if no action
        InputMap.add_action(action)

    var event = InputEventAction.new() ## create the event
    event.action = action
    event.pressed = pressed
    
    Input.parse_input_event(event) # press the action
