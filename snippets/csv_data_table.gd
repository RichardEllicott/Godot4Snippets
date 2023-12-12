"""

  simple object for loading data

  
"""

## some example data
const csv_planet_data ="""
Name,type,orbital radius (10^6 km),orbital eccentricity,Orbital Inclination (degrees),Orbital Velocity (km/s),diameter (km),Mass (10^24kg),Density (kg/m3),Gravity (m/s2),Escape Velocity (km/s),Rotation Period (hours),Length of Day (hours),Perihelion (10^6 km),Aphelion (10^6 km),Orbital Period (days),Obliquity to Orbit (degrees),Mean Temperature (C),Surface Pressure (bars),Number of Moons,Ring System?,Global Magnetic Field?
Sun,Star,0,0,,,1391400,1988500,1408,274,617.6,,,,,,,15000000,,,,
Mercury,Rocky Planet,57.9,0.206,7,47.4,4879,0.33,5429,3.7,4.3,1407.6,4222.6,46,69.8,88,0.034,167,0,0,0,1
Venus,Rocky Planet,108.2,0.007,3.4,35,12104,4.87,5243,8.9,10.4,-5832.5,2802,107.5,108.9,224.7,177.4,464,92,0,0,0
Earth,Rocky Planet,149.6,0.017,0,29.8,12756,5.97,5514,9.8,11.2,23.9,24,147.1,152.1,365.2,23.4,15,1,1,0,1
Moon,Rocky Moon,0.384,0.055,5.1,1,3475,0.073,3340,1.6,2.4,655.7,708.7,0.363,0.406,27.3,6.7,-20,0,0,0,0
Mars,Rocky Planet,228,0.094,1.8,24.1,6792,0.642,3934,3.7,5,24.6,24.7,206.7,249.3,687,25.2,-65,0.01,2,0,0
Jupiter,Gas Giant,778.5,0.049,1.3,13.1,142984,1898,1326,23.1,59.5,9.9,9.9,740.6,816.4,4331,3.1,-110,Unknown,92,1,1
Saturn,Gas Giant,1432,0.052,2.5,9.7,120536,568,687,9,35.5,10.7,10.7,1357.6,1506.5,10747,26.7,-140,Unknown,83,1,1
Uranus,Ice Giant,2867,0.047,0.8,6.8,51118,86.8,1270,8.7,21.3,-17.2,17.2,2732.7,3001.4,30589,97.8,-195,Unknown,27,1,1
Neptune,Ice Giant,4515,0.01,1.8,5.4,49528,102,1638,11,23.5,16.1,16.1,4471.1,4558.9,59800,28.3,-200,Unknown,14,1,1
Pluto,Rocky Planetoid,5906.4,0.244,17.2,4.7,2376,0.013,1850,0.7,1.3,-153.3,153.3,4436.8,7375.9,90560,122.5,-225,1e-05,5,0,Unknown
"""

## table object, just for data, loads from a csv string, used to manage spreadsheet style data
class DataTable:
    
    var keys: Array = []
    
    var rows: Array = []
    
    func size() -> int:
        return rows.size()
    
    func get_cell(id: int, key: String):
        assert(key in keys)
        var c = keys.find(key)
        assert(c != -1)
        return rows[id][c]
    
    ## get a csv string
    func get_string() -> String:
        
        var s = ""
        for key in keys:
            s += "%s," % str(key)
        s += "\n"
        
        for row in rows:
            for cell in row:
                s += "%s, " % str(cell)
            s += "\n"
        
        return s
    
    func _to_string() -> String:
        return get_string()
    
    ## load from a csv table as a string, the table will look like follows, the first row is the keys
    ##
    ## name, type, color
    ## orange, fruit, orange
    ## banana, fruit, yellow
    ##
    func load_from_csv_table(csv: String) -> void:
        
        clear()
        
        var strip = "\n\t " # strip these chars
        csv = csv.lstrip(strip).rstrip(strip)
        
        var lines = csv.split('\n')
        
        for i in lines.size():
            var line: Array = Array(lines[i].split(","))
            
            for j in line.size():
                
                var val = line[j].lstrip(strip).rstrip(strip) # strip spaces
                
                if val.is_valid_int(): # detect int
                    val = int(val)
                elif val.is_valid_float(): # detect float
                    val = float(val)
                
                line[j] = val
            
            if i == 0:
                keys = line
            else:          
                rows.append(line)
    
    func clear():     
        keys = []
        rows = []
