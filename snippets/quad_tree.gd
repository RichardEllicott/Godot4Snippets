"""

working quadtree demo


this allows saving "data" to "positions"
it is useful for finding the nearest neighbours or entries within a 2D area
similar to a BSP scheme but kinda easier as it uses squares
this is a similar reason i belive people use octrees in 3D (they have always 8 childs)


so far just an animation

"""
@tool
extends Node2D


@export var draw_scale = Vector2(512, 512)


@export var delay = 1.0
var timer = 0.0


func _process(delta):
    timer += delta
    if timer >= delay:
        timer -= delay
        
        
        queue_redraw()
        
        macro_test_quadtree()


func _ready():
    macro_reset_quadtree()
    

func _draw():
    
#    draw_line(Vector2(), Vector2(32,32), Color.WHITE)
    
    for i in debug_rects.size():
        var rect = debug_rects[i]
        var color = debug_rect_colors[i]
        rect.position *= draw_scale
        rect.size *= draw_scale
        draw_rect(rect, color, false, 1.0)
        
    for i in debug_dots.size():
        var pos = debug_dots[i]
        var color = debug_dot_colors[i]
        pos *= draw_scale
        draw_circle(pos, 1.0, color)
    
var debug_rects = []
var debug_rect_colors = []

func debug_clear_rects():
    debug_rects = []
    debug_rect_colors = []

func debug_add_rect(rect: Rect2, color = Color.WHITE):
    debug_rects.append(rect)
    debug_rect_colors.append(color)
    

var debug_dots = []
var debug_dot_colors = []

func debug_clear_dots():
    debug_dots = []
    debug_dot_colors = []

func debug_add_dot(pos: Vector2, color = Color.WHITE):
    debug_dots.append(pos)
    debug_dot_colors.append(color)
    
    


## a recursive QuadTree object
## as positions are added it will create more QuadTree objects
class QuadTree:
    
    ## if null we have no branches, we must be at the end of the tree
    ## if we split, we will have 4 children here
    var branches 
    
    ## if we are the end of the tree, we will store the positions and their contents
    ## if we split, this data is copied to the children instead
    var _positions = []
    var _contents = []
    
    # the quadtree's cover area, we can only add positions in this area
    var area: Rect2
    
    ## the max amount to store in this branch before splitting into four children
    var max_contents = 5 
    

    
    ## when we make this object, the 
    func _init(_dimensions: Rect2 = Rect2(Vector2(), Vector2(1,1))):
        area = _dimensions
    
    ## when we add data, if we have less than max add here
    ## if we have more than max make a split
    func add_data(_position: Vector2, data):
                
        assert(area.has_point(_position)) ## ensure this position in range
        
        if branches == null: # we must be at the end of the tree
            _positions.append(_position)
            _contents.append(data)
            
            if _positions.size() > max_contents:
                
                assert(_contents.size() == _positions.size())
                
                _split() # split into 4 subobjects (quads)
                
                var redundant_check = false
                for i in _contents.size(): # for each entry
                    var this_content = _contents[i]
                    var this_position = _positions[i]
                    
                    for j in 4:
                        var branch: QuadTree = branches[j]
                        
                        if branch.dimensions.has_point(this_position):
                            branch.add_data(this_position, this_content)
                            redundant_check = true
                            break
                            
                    assert(redundant_check) # if no branch was valud, something must be wrong!
                        
                _positions = []
                _contents = []
                
                
        else:            
            var redundant_check = false # we must have sucess
            for i in 4:
                var branch: QuadTree = branches[i]
                
                if branch.dimensions.has_point(_position):
                    branch.add_data(_position, data)
                    redundant_check = true
                    break
            assert(redundant_check) # something went wrong, the position doesn't match any child
            
            

    ## split this branch such that it now has 4 childs and is no longer drawn
    func _split():
        
        # rects:
        # +-+-+
        # |1|2|
        # +-+-+
        # |3|4|
        # +-+-+
                
        assert(branches == null) # must have not already split
    
        var rect1 = area # the first rect, same pos, half dimensions
        rect1.size /= 2.0
        
        var rect2 = rect1 # moves to the x
        rect2.position.x += area.size.x / 2.0
        
        var rect3 = rect1
        rect3.position.y += area.size.y / 2.0
        
        var rect4 = rect1
        rect4.position += area.size / 2.0
        
        branches = [
            QuadTree.new(rect1),
            QuadTree.new(rect2),
            QuadTree.new(rect3),
            QuadTree.new(rect4)
        ]
        
    
    ## DEBUG FUNCTIONS (showing test usage)
        
    ## return all rects (of all childs) recursivly so we can visualize the QuadTree
    ## this function is only intended for visualization, may be slow
    func get_all_rects(array = []):
        if branches:
            for branch in branches:
                array.append_array(branch.get_all_rects())
        else:
            array.append(area)
        return array
    
    ## return all positions (of all childs) recursivly so we can visualize the QuadTree
    ## this function is only intended for visualization, may be slow
    func get_all_positions(array = []):
        if branches:
            for branch in branches:
                array.append_array(branch.get_all_positions())
        else:
            array.append_array(_positions)            
        return array



var qt: QuadTree
var rng: RandomNumberGenerator
var count = 0
func macro_reset_quadtree():
    
    rng = RandomNumberGenerator.new()
    rng.seed = 10
    qt = QuadTree.new(Rect2(Vector2(0,0), Vector2(1,1)))
    count = 0
    
func macro_test_quadtree():
    
    
    if Engine.is_editor_hint() and count >= 200:
        return
    
    
#    var rand_pos = Vector2(rng.randf(), rng.randf())
    var rand_pos = Vector2(rng.randfn(0.5, 0.25), rng.randfn(0.5, 0.25))
    
    
    if qt.dimensions.has_point(rand_pos):
        qt.add_data(rand_pos, "test%s" % count)
        count += 1
    
    
#    for i in 64:
#        var pos = Vector2(rng.randf(), rng.randf())
#        qt.add_data(pos, "test%s" % i)
    
    
    
    debug_clear_rects()
    debug_clear_dots()
    
    var rects = qt.get_all_rects()
    var dots = qt.get_all_positions()
    
    print("rects: %s dots: %s" % [rects.size(), dots.size()])
        
    for rect in rects:
#        print("🍋 ", rect)
        debug_add_rect(rect)
    for pos in dots:
#        print("🍊 ", pos)
        debug_add_dot(pos)
    




    queue_redraw()
    
