# ported normal probability distribution function
# https://stackoverflow.com/questions/12412895/how-to-calculate-probability-in-a-normal-distribution-given-mean-standard-devi
func normal_pdf(x: float, mean: float = 0.0, sd: float = 1.0) -> float:
    var v = float(sd)**2
    var denom = (2 * PI * v)**.5
    var num = exp(-(float(x)-float(mean))**2 / (2 * v))
    return num / denom
