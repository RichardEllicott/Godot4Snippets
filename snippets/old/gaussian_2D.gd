"""
probabally not required anymore but does show at least a method for 2 floats to 2D Guassian

built in we could just use:

randfn(0.0,1.0)

"""


func gaussian_2D(r1 = randf(), r2 = randf()):
    """
    ported from the caltech lua one (i think, the link is dead!)
    http://www.design.caltech.edu/erik/Misc/Gaussian.html
    r1 and r2 are floats from 0 to 1
    ran_gaussian_2D(randf(),randf())
    """
    var al1 = sqrt(-2 * log(r1)) # part one
    var al2 = 2 * PI * r2 # part two
    var x = al1 * cos(al2)
    var y = al1 * sin(al2)
    return Vector2(x,y)
