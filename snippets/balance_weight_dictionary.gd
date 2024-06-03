## take a dict of numbers
## ensure that all the numbers add up to 1.0
## works on dict in place (modifys the dict)
##
## used to decide say the results of a lootbox, wth differing probabilities for rewards

static func balance_weight_dictionary(_dict: Dictionary) -> void:
    
    var total: float = 0.0
    for key in _dict:
        var val = _dict[key]
        assert(val is float or val is int)
        total += _dict[key]
        
    for key in _dict:
        var val = _dict[key]
        _dict[key] = val / total
