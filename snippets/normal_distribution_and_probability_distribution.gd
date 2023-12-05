"""

normal distribution functions



this guy has an interesting approach:
https://github.com/pgoral/Godot-Gaussian-Random/blob/master/GaussianRandom.gd
i belive he uses the "The Marsaglia polar method", i think this WAS faster before floating points, it uses discarding of values instead of cos and sin


2021... i ran a test of this algo vs my old one, my old one is faster (even for 1D)!



This orginal 2D method i have been using is faster, even despite generating 2 output values!
i think it is the:
Box-Muller transform

test showed

testing 1'000'000 calculations

time taken: 2146 # this method
time taken: 3534 # "The Marsaglia polar method"


note the RandomNumberGenerator has a guassian, randfn 



"""
## this is my old 
func normal_2d(r1 = randf(), r2 = randf()):
    """
    ported from the caltech lua one (i think, the link is dead!)
    http://www.design.caltech.edu/erik/Misc/Gaussian.html
    
    https://www.taygeta.com/random/gaussian.html # new link
    
    https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform

    r1 and r2 are floats from 0 to 1

    ran_gaussian_2D(randf(),randf())
    """
    var al1 = sqrt(-2 * log(r1)) # part one
    var al2 = 2 * PI * r2 # part two
    var x = al1 * cos(al2)
    var y = al1 * sin(al2)
    return Vector2(x,y)


#gives the height y of a bell curve where we are at the position x
# ported normal probability distribution function
# https://stackoverflow.com/questions/12412895/how-to-calculate-probability-in-a-normal-distribution-given-mean-standard-devi
static func normal_pdf(x: float, mean: float = 0.0, standard_deviation: float = 1.0) -> float:
    var v: float = float(standard_deviation)**2
    var denom: float = (2 * PI * v)**.5
    var num: float = exp(-(float(x)-float(mean))**2 / (2 * v))
    return num / denom

