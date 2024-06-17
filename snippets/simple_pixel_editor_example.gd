"""

very simple pixel editor, needs a child TextureRect


will draw and update when we draw over the TextureRect's area

uses the transform, so supports scaling the TextureRect

"""
@tool
extends Control

## get our TextureRect, make sure there is one!
var texture_rect: TextureRect:
    get:
        #return self
        if not texture_rect:
            texture_rect = $TextureRect
            #texture_rect = StaticLib6.get_or_create_child(self, "TextureRect", TextureRect)
        return texture_rect
    
    
@export var image_size: Vector2i = Vector2(16, 16)

@export var draw_action: String = "ui_mouse_left_button"

## will get our image, the same image will be kept in memory and used to update the texture
var image: Image:
    get:
        
        if not image: # if no image yet, we ensure a texture exists
            
            if not texture_rect.texture: # if no texture either create one
                image = Image.create(image_size.x, image_size.y, true, Image.FORMAT_RGBA8)
                image.fill(Color.DARK_GREEN)
                var texture: ImageTexture = ImageTexture.create_from_image(image)
                texture_rect.texture = texture
            
            # get the image from the texture (this goes back and forth but just once!)
            image = texture_rect.texture.get_image()
            
        ## TODO, RESIZE IMAGE??
        if image.get_size() != image_size: # if image size now wrong, create a new image
            image = Image.create(image_size.x, image_size.y, true, Image.FORMAT_RGBA8)
            image.fill(Color.DARK_GREEN)
        
        return image
            

## ensure the texture matches the image
func _update():
    texture_rect.texture = ImageTexture.create_from_image(image)
    

    
    
## translate a position to it's position on the image
## gets which pixel our mouse hovers over
func global_position_to_image_position(_position: Vector2) -> Vector2:
    
    var image_size = image.get_size()
    # firstly use the transform (for offset scale and rotation)
    var image_position: Vector2 = _position * texture_rect.get_global_transform()    
    # then scale the position based on the ratio between rect size and image size
    image_position *=  Vector2(image_size) / texture_rect.size
    
    # check the position is actually inside the image, if not we return Vector2(-1-1)
    # this allows us to not update if not required
    if image_position.x < 0.0 or image_position.y < 0.0 or image_position.x >= image_size.x or image_position.y >= image_size.y:
        image_position = Vector2(-1,-1)
    
    return image_position

var drawing = false


## uses unhandled_input
## if it is not working, make sure all the controls node are set to mouse pass (not stop)
## using mouse filtering like this blocks drawing if we click a button above the draw area
func _unhandled_input(event):
    
    if event.is_action(draw_action):
        if event.is_pressed():
            if global_position_to_image_position(mouse_position) != Vector2(-1,-1):
                drawing = true
        else:
            drawing = false


var mouse_position: Vector2 = Vector2.ZERO
    
func _process(delta) -> void:
    
    if Engine.is_editor_hint(): # skip following in tool mode (tool mode i just use for testing)
        return
    
    #mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()
    mouse_position = get_viewport().get_mouse_position()
    
    if drawing: # tool modes doesn't like custom event names
        var draw_position: Vector2 = global_position_to_image_position(mouse_position)
        
        if draw_position != Vector2(-1,-1):
            image.set_pixel(draw_position.x, draw_position.y, Color.RED)
            _update()
        

func _ready() -> void:
    texture_rect # just call the properties to ensure they exist
    image
    texture_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS # pixel mode
        
        
