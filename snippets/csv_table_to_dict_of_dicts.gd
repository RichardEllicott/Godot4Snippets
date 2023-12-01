"""

a quick way of getting data from a spreadsheet, paste out some csv or tsv, use this to turn it into dictionaries


"""



const bullet_data_from_spreadsheet = """
#name	type	pellets	drag	velocity	mass
9x19mm	FMJ	1	1	1180	115
.45 ACP	FMJ	1	1	835	230
.357 Magnum 	JHP	1	1	1450	125
.44 Magnum 	SJHP	1	1	1180	240
5.56 NATO 	FMJBT	1	1	3260	55
7.62 NATO 	FMJ	1	1	2800	147
00Buck9	00Buck 9 pellets	9	1	1200	54

5.45x39mm	7N6M FMJ	1	1	2900	53







"""


## easy csv string to dict of dicts function
## uses what i call a "csv table", where line 0 is a header
## doesn't support quote marks allowing commands inside
## does detect valid ints and floats
static func csv_table_to_dict_of_dicts(csv_string: String, split_symbol: String = ",") -> Dictionary:
    
    var return_dict: Dictionary = {}
    var lines: Array = csv_string.strip_edges().split("\n")
    assert(lines.size() > 1)
    var keys: Array # save an array of keys
    
    for i in lines.size(): # for each line of string
        var row: Array = lines[i].split(split_symbol) # get a row by splitting
        if i == 0: # first row has keys
            keys = row
            
            for i2 in keys.size():
                var string = keys[i2].strip_edges() # strip spaces around key
                keys[i2] = string
            
        else:
            if row.size() == keys.size(): # skip if the size is not valid
                var row_dict = {}
                return_dict[row[0].strip_edges()] = row_dict
                for i2 in row.size():
                    
                    var val = row[i2].strip_edges()
                    
                    if val.is_valid_int(): # detect int
                        val = int(val)
                    elif val.is_valid_float(): # detect float
                        val = float(val)
                    
                    row_dict[keys[i2]] = val # also trim the entries
    return return_dict

