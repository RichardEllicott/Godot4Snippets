
## folded normal with an average output of 1
## the folded normal only returns positive numbers
## the constant used is (2.0/pi)**0.5
##
## good for delays like lightning
##
static func folded_normal() -> float:    
    return abs(randfn(0.0, 1.0)) / 0.7978845608028654
