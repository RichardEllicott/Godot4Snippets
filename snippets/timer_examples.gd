"""
"""

## simple timer
var timer = 0.0
@export var delay = 1.0
@export var random_delay = -1

func _process(delta):
    timer += delta
    if timer >= delay:
        timer -= delay
        
        if random_delay > 0.0:
            delay = randf() * random_delay

## ticker timer
var timer = 0.0
@export var delay = 1.0
var ticker = 0

func _process(delta):
    timer += delta

    if (timer / delay) > ticker:
        ticker += 1
        print(ticker)



