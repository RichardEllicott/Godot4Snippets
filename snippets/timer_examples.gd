"""
"""



## countdown timer with random delays
##

@export var timer_active: bool = true 

@export var timer_delay: float = 1.0 ## the timer for this
@export var timer_random_delay: float = 0.0
@export var timer_normal_delay: float = 0.0

## counts down, used for triggering the pattern to fire
var timer: float = 0.0

## folded normal with an average output of 1
## the folded normal only returns positive numbers
## the constant used is (2.0/pi)**0.5
func folded_normal():    
    return abs(randfn(0.0, 1.0)) / 0.7978845608028654

func _physics_process(delta):
    
    if timer_active:
        timer -= delta
        if timer <= 0.0:
            timer += timer_delay
            
            if timer_random_delay:
                timer += randf() * timer_random_delay
            if timer_normal_delay:
                timer += folded_normal() * timer_normal_delay

            ## TRIGGER ACTIONS HERE





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



