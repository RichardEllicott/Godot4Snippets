"""

a table building object, fast and simple


tested cell nodes:
    Label
    LineEdit
    Button
    CheckButton # simply inherits buttons, by default sends toggled signal
    CheckBox


call update() to trigger rebuild

"""
@tool
extends GridContainer
class_name FastTable


@export_group("Table")
## everything is based on the keys, must be unique strings
@export var keys: Array[String] = ["System", "Security", "Edit", "Select"]

## the header cell type is usually a Button so it can be pressed to sort the rows
@export var header_types = ["Button", "Button", "Button", "Button"] 

## disable the header, makes the button unselectable
@export var header_disabled = [false, false, false, false] 

## the type of control node for the rows themselves, use Label, LineEdit and Button
@export var types = ["Label", "Label", "LineEdit", "Button"] 


## clear all rows
func clear_rows():
    data = []

## can be called externally to build data
func add_row(row: Array):
    assert(row.size() == keys.size())
    data.append_array(row)
    

# new feature
var _cell_type_overrides = {}
func set_cell_type_override(row: int, column: int, type):
    _cell_type_overrides[Vector2i(column, row)] = type
    
func clear_cell_type_overrides():
    _cell_type_overrides = {}
    

## the data, but it is seriazlized, ensure the data size is divisible by the key count
@export var data = [
    "Sol",              "0.9",     "",     "",
    "Draco",            "0.3",     "",     "",
    "Betelgeuse",       "0.4",     "",     "",
    "Alpha Centuri",   "0.7",     "",     "",
    "Scorpius",          "0.3",     "",     "",
    "Gorgon",          "0.3",     "",     "",
    "New Haven",          "0.3",     "",     "",
    "Sirius",          "0.3",     "",     "",
    "Orion",          "0.3",     "",     "",
    "Canis Major",          "0.3",     "",     "",
    "Taurus",          "0.3",     "",     "",
    ]
    
## if this target is selected, we make a duplicate header here, useful when we need the scroll container
@export var build_header_in_control: Control
    
@export var minimum_column_widths: Array[float] = [128.0, 32.0, 64.0, 32.0]
    
    
@export_group("Scene Overrides")
## allows overriding the header so they look different (might be unimplemented)
@export var header_scene: PackedScene
    
@export_group("Debug")
@export var debug_always_rebuild_table = false # for debugging (slow)

@export var debug_messages = false

## hide the normal header
@export var hide_header = false

## hide the optional mirrored header
@export var hide_header2 = false

## track rows (records) to hide
var hidden_rows = {} # null ref dict to store hidden rows

## hide a row
func hide_row(row: int, hide: bool = true):
    if hide:
        hidden_rows[row] = null
    else:
        hidden_rows.erase(row)

## unhide a row
func unhide_row(row: int):
    hide_row(row, false)

## the expected child count is used to detect if a table rebuild is required
func _get_expected_child_count():
    assert(data.size() % keys.size() == 0)
    var entry_count = data.size() / keys.size()
    var expected_size = keys.size() * (entry_count + 1)
    return expected_size
    

## updates the data
## only calls a full rebuild at front if the amount of childs doesn't match what we expect
func update():
    
    if debug_messages: print("expected size ", _get_expected_child_count())
    
    if get_child_count() != _get_expected_child_count() or debug_always_rebuild_table:
        if debug_messages: print("trigger rebuild")
        rebuild()
    
    
    for x in keys.size(): # the header controls
        var key = keys[x]
        var control: Control = get_node(key)
        control.text = key
        control.visible = not hide_header
        
        if not control.pressed.is_connected(_on_header_pressed):        
            control.pressed.connect(_on_header_pressed.bind(x))

        
        
        if is_instance_valid(build_header_in_control): # extra feature
            var control2: Control = build_header_in_control.get_node(key)
            control2.text = key
            control2.visible = not hide_header2
            
            if not control2.pressed.is_connected(_on_header_pressed):        
                control2.pressed.connect(_on_header_pressed.bind(x))
        
        
        
    # iterate our data, which is serialized
    assert(data.size() % keys.size() == 0)
    var entry_count = data.size() / keys.size()

    for row in entry_count:
        for x in keys.size(): 
            var key = keys[x]            
            var child_name = "%s_%s" % [row, key]
        
            var control: Control = get_node(child_name)
            control.text = str(data[row * keys.size() + x])
            control.visible = not row in hidden_rows
            
            
            # signals (we now check on every update, as signals get from tool mode
            if control is Button:
                if not control.pressed.is_connected(_on_button_pressed):
                    control.pressed.connect(_on_button_pressed.bind(row, x))
                if not control.toggled.is_connected(_on_button_toggled):
                    control.toggled.connect(_on_button_toggled.bind(row, x)) # also works for checkbutton
                
            if control is LineEdit:
                if not control.text_submitted.is_connected(_on_text_submitted):
                    control.text_submitted.connect(_on_text_submitted.bind(row, x))
                if not control.text_changed.is_connected(_on_text_changed):
                    control.text_changed.connect(_on_text_changed.bind(row, x))

            
            
            
            
                
## allow sorting as is usual in tables by the column headers
@export var sort_rows_on_header_pressed = true

## pressing the same header cell twice reverses the order (similar to windows explorer etc)
@export var sort_backwards_on_double_press = true

## used internally to track the last sorted column
var _last_header_pressed = -1 # second click reverses the order (might drop this)

## still have not implemented this well, needs some sort of stretch mode like this
var _size_flags_horizontal = Control.SIZE_EXPAND_FILL 

## respond to header press
func _on_header_pressed(x: int):
    if debug_messages: print("_on_header_pressed %s" % x)
    
    if sort_rows_on_header_pressed: # if we sort rows when a header is pressed
        if x == _last_header_pressed:
            sort_by_column(x, true)
            _last_header_pressed = -1
        else:
            sort_by_column(x)
            if sort_backwards_on_double_press:
                _last_header_pressed = x
            else:
                _last_header_pressed = -1
    
    

# sent when a Button is pressed
signal button_pressed(row, column)
func _on_button_pressed(row, column):
    if debug_messages: print("_on_button_pressed %s, %s" % [row,column])
    emit_signal("button_pressed", row, column)
    
signal button_toggled(row, column, pressed)
func _on_button_toggled(pressed: bool, row: int, column: int):
    if debug_messages: print("_on_button_toggled %s %s, %s" % [pressed,row,column])
    emit_signal("button_toggled", row, column, pressed)
    

    
# sent when text is submitted to a LineEdit (must press enter, pretty lame)
signal text_submitted(row, column, text)
func _on_text_submitted(text, y, x):
    if debug_messages: print("_on_text_submitted %s, %s %s" % [text,y,x])
    emit_signal("text_submitted", y, x, text)

# sent when text has changed on a LineEdit
signal text_changed(row, column, text)
func _on_text_changed(text, y, x):
    if debug_messages: print("_on_text_changed %s %s, %s" % [text,y,x])
    data[y * keys.size() + x]  = text
    if debug_messages: print(data)
    emit_signal("text_changed", y, x, text)
    
    


## sort in a alphabetical sort, triggers full sort algo + reparenting the controls
func sort_by_column(col: int, reverse = false):
    
    var sort_data = [] # list of lists made to be easily with lambda
    
    assert(data.size() % keys.size() == 0) # check the data is div by the key count
    var entry_count = data.size() / keys.size()
    
    for row in entry_count: # build sort list
        var entry = data[row * keys.size() + col]
        sort_data.append([row,entry])
    
    if reverse:
        sort_data.sort_custom(func(a, b): return a[1] > b[1]) # sort me
    else:
        sort_data.sort_custom(func(a, b): return a[1] < b[1]) # sort me
    
    var row_positions2 = PackedInt32Array() # create back a new row_positions array
    row_positions2.resize(entry_count)
    for row in entry_count:
        row_positions2[row] = sort_data[row][0]
    row_positions = row_positions2
        
    resort_rows() # call a refresh (will reparent the childs in the new order)
    


## the row positions, usually like [0,1,2,3,4,5,6]
var row_positions: PackedInt32Array

## resorts the rows by deparenting all control nodes, then putting them back
## happens very fast compred to building new nodes
func resort_rows():
    
    # a few checks
    assert(data.size() % keys.size() == 0) # check the data is div by the key count
    var entry_count = data.size() / keys.size()
    assert(entry_count == row_positions.size())
    
    var controls = {}
    
    for child in get_children():
        remove_child(child)
        controls[child.name] = child # save in dict by child name
        
    for key in keys: ## add back header first
        if key in controls:
            add_child(controls[key])
    
    for i in row_positions.size():
        var row = row_positions[i]
        for x in keys.size():
            var key = keys[x]
            var _name = "%s_%s" % [row, key]
            
            var control: Control = controls[_name]
            
            add_child(control) # add all the childs back
            control.owner = get_tree().edited_scene_root # required for tool mode
            

## seperated off just to look clearer
## perhaps could use for an "add row" feature
func _rebuild_row(row: int):
    
    for x in keys.size():
            
        var key = keys[x]
        var type = types[x]
    
        # new cell override
        var type2 = _cell_type_overrides.get(Vector2i(x, row))
        if type2:
            type = type2
    
        var control: Control = get_or_create_child(self, "%s_%s" % [row, key], type)
        
                
        control.custom_minimum_size.x = minimum_column_widths[x]
        
        # signals
        if control is Button:
            control.pressed.connect(_on_button_pressed.bind(row, x))
            control.toggled.connect(_on_button_toggled.bind(row, x)) # also works for checkbutton
            
        if control is LineEdit:
            control.text_submitted.connect(_on_text_submitted.bind(row, x))
            control.text_changed.connect(_on_text_changed.bind(row, x))


 # quick helpers to fill out default values if we missed them
func _set_default_values():
    
    while minimum_column_widths.size() < keys.size():
        minimum_column_widths.append(0) # minimum column widths of 0
        
    while types.size() < keys.size():
        types.append("Label") # default cell type as Label
        
    while header_types.size() < keys.size():
        header_types.append("Button") # default header as Button
        
    while header_disabled.size() < keys.size():
        header_disabled.append(false) # default header as Button

## a full rebuild, deleting all children and putting all the cells back (slow)
## required if our data length changes
## it is best to avoid needing to do this by hiding rows if possible
func rebuild():
    
    _set_default_values()
    
    for child in get_children(): # remove old childs
        remove_child(child)
        
    if is_instance_valid(build_header_in_control):
        for child in build_header_in_control.get_children(): # remove old childs
            build_header_in_control.remove_child(child)
    
    columns = keys.size() # #set the columns of grid container
    
    for x in keys.size(): # create our headers
        var key = keys[x]
        
        var target = self
        
        # this header is duplicated again below
        var control: Control = get_or_create_child(target, key, header_types[x])
        control.disabled = header_disabled[x]
        if control.disabled:
            control.focus_mode = 0 # stop us focusing on inactive control
        if control is Button:
            control.pressed.connect(_on_header_pressed.bind(x))
            
        control.custom_minimum_size.x = minimum_column_widths[x]
            
        ## duplicate code, just duplicates the header
        if is_instance_valid(build_header_in_control):
            target = build_header_in_control
            var control2: Control = get_or_create_child(target, key, header_types[x])
            control2.disabled = header_disabled[x]
            if control2.disabled:
                control2.focus_mode = 0 # stop us focusing on inactive control
            if control2 is Button:
                control2.pressed.connect(_on_header_pressed.bind(x))
                
            control2.custom_minimum_size.x = minimum_column_widths[x]
                       

    assert(data.size() % keys.size() == 0) # check the data is div by the key count
    var entry_count = data.size() / keys.size()
    row_positions = PackedInt32Array() # used to sort the entries
    row_positions.resize(entry_count)
            
    # iterate the data, builds correct amount of rows
    
    for row in entry_count:
        
        row_positions[row] = row # building the sort position
        
        _rebuild_row(row) # broken off as function so we can see the logic easier
        
        
    

func _ready():
#    rebuild() # needed for signals as of yet
    update() # calls rebuild as needed
    




## the following function is used to simplify instantiating controls

## super duck typed version of my standard get_or_create_child function
##
## either returns the existing node, or spawns a new one (including in tool mode)
##
## _parent: target parent to add childs to
## _name: if this is set as a string, will try to grab and return existing child (so as not to duplicate)
##        if null, will just create a new child
## _type: accepts a built in node like Button, Node3D etc
##        or a string of a built in, like "Button", "Node3D"
##        or a PackedScene
##        or a node we will duplicate
static func get_or_create_child(_parent: Node, _name: String, _type = Node) -> Node:
    var child = _parent.get_node_or_null(_name) # attempt to get the node by name
    if child == null: # if no node, we need to create one
        
        if _type is PackedScene: # if a PackedScene, instantiate it
            child = _type.instantiate()
            
        elif _type is String: # if a string, try to match it in the ClassDB
            if ClassDB.class_exists(_type):
                child = ClassDB.instantiate(_type)
            else: # unrecognised type string
                child = Label.new() 
                push_error("unrecognised type string: \"%s\"" % _type)
        
        elif _type is Node: # if a Node, duplicate it
            child = _type.duplicate() # warning using duplicate may be less effecient
        
        else: # last assumption is a plain type and try to call "new"
            child = _type.new()
        child.name = _name
        
        _parent.add_child(child)
        # we always set the owner after adding the node to a tree if using tool mode
        child.owner = _parent.get_tree().edited_scene_root 

    return child




# tests

func macro_sort_by_column_0():
    sort_by_column(0)

func macro_sort_by_column_1():
    sort_by_column(1)
    
func macro_sort_by_column_2():
    sort_by_column(2)
    
func macro_sort_by_column_3():
    sort_by_column(3)
    

func macro_test_reverse_sort_rows():
    row_positions.reverse()
    resort_rows()
    


func macro_options_table_test():
    
    
    pass

