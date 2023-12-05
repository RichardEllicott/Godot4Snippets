"""

normal distribution function and a probability distribution function



NOTES ON THE TWO METHODS OF GENERATING NORMALS

this guy has an interesting approach:
https://github.com/pgoral/Godot-Gaussian-Random/blob/master/GaussianRandom.gd
i belive he uses the "The Marsaglia polar method", i think this WAS faster before floating points, it uses discarding of values instead of cos and sin

2021... i ran a test of this algo vs my old one (which i think is a Box-Muller transform)
my old one was faster and this test was for 1D (despite my one being 2D)

testing 1'000'000 calculations:
    time taken: 2146 # this method
    time taken: 3534 # "The Marsaglia polar method"



note the RandomNumberGenerator has a normal function also, randfn()

i have these though as one extra thing can be done, and Godot has no "probability distribution function"


"""


## ported from the caltech lua one (i think, the link is dead!)
## http://www.design.caltech.edu/erik/Misc/Gaussian.html
## https://www.taygeta.com/random/gaussian.html # new link
## https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform
## r1 and r2 are floats from 0.0 to 1.0
func normal_2d(r1: float = randf(), r2: float = randf()) -> Vector2:
    var al1: float = sqrt(-2.0 * log(r1)) # part one
    var al2: float = 2.0 * PI * r2 # part two
    var x: float = al1 * cos(al2)
    var y: float = al1 * sin(al2)
    return Vector2(x,y)

## normal probability distribution function
## gives the height y of a bell curve where we are at the position x
## ported from python:
## https://stackoverflow.com/questions/12412895/how-to-calculate-probability-in-a-normal-distribution-given-mean-standard-devi
static func normal_pdf(x: float, mean: float = 0.0, standard_deviation: float = 1.0) -> float:
    var v: float = float(standard_deviation)**2
    var denom: float = (2 * PI * v)**.5
    var num: float = exp(-(float(x)-float(mean))**2 / (2 * v))
    return num / denom



