"""

load csv like:


this is how data pastes out of open office, so you can paste tsv data out (make sure to set \t instead of comma)



"""



const s = """
name	type	pellets	velocity	mass
9x19mm	FMJ	1	1180	115
.45 ACP	FMJ	1	835	230
.357 Magnum 	JHP	1	1450	125
.44 Magnum 	SJHP	1	1180	240
5.56 NATO 	FMJBT	1	3260	55
7.62 NATO 	FMJ	1	2800	147
00Buck9	00Buck 9 pellets	9	1200	54
"""



func macro_get_stuff():
    
    var data = csv_string_to_dicts(s, '\t')
    
    for key in data:
        print(data[key])



## turn a csv string into a dicts of dicts allowing loading spreadsheet data
## does not support escape characters and quotation marks unfortunatly
static func csv_string_to_dicts(tsv_string: String, split_symbol: String = ",") -> Dictionary:
    
    var return_dict: Dictionary = {}
    var lines: Array = tsv_string.strip_edges().split("\n")
    assert(lines.size() > 1)
    var keys: Array # save an array of keys
    
    for i in lines.size(): # for each line of string
        var row: Array = lines[i].split(split_symbol) # get a row by splitting
        if i == 0: # first row has keys
            keys = row
        else:
            if row.size() == keys.size(): # skip if the size is not valid
                var row_dict = {}
                return_dict[row[0]] = row_dict
                for i2 in row.size():
                    
                    var val = row[i2].strip_edges()
                    if val.is_valid_int(): # detect int
                        val = int(val)
                    elif val.is_valid_float(): # detect float
                        val = float(val)
                    
                    row_dict[keys[i2]] = val # also trim the entries
    return return_dict