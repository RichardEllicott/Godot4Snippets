"""

normal probability distribution function

this gives the height y of a bell curve where we are at the position x

"""


# ported normal probability distribution function
# https://stackoverflow.com/questions/12412895/how-to-calculate-probability-in-a-normal-distribution-given-mean-standard-devi
static func normal_pdf(x: float, mean: float = 0.0, standard_deviation: float = 1.0) -> float:
    var v: float = float(standard_deviation)**2
    var denom: float = (2 * PI * v)**.5
    var num: float = exp(-(float(x)-float(mean))**2 / (2 * v))
    return num / denom
