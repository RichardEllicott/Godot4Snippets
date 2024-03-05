"""

custom resource image generator example

this can be used to make a custom grid texture for example



i note some issues using the texture in 3D, so for now just use normal images

"""
@tool
class_name ImageTextureGeneratorExample
extends ImageTexture

## this boolean is just for clicking in the editor to trigger a refresh
@export var trigger_update: bool:
    set(value):
        if value and Engine.is_editor_hint():
            _update()

## our custom update that sets the image
func _update():
    set_image(generate_image_function())


## override this function
func generate_image_function() -> Image:
    
    var img = Image.create(size.x, size.y, true, Image.FORMAT_RGBA8)
    #img.fill(Color(1,0,0,1))
    
    var thickness = 0
    
    for y in size.y:
        for x in size.x:
            
            var col = Color.BLACK
            if y - thickness <= 0 or x - thickness <= 0:
                col = Color.WHITE
                
            if y + 1 >= size.y:
                col = Color.WHITE
            
            if x + 1 >= size.x:
                col = Color.WHITE
            
            img.set_pixel(x,y, col)
    
    
    
    return img




@export var size = Vector2(64,64)

## draw a solid rectangle on an image
static func image_draw_rect(image: Image, rect: Rect2i, color: Color):
    for _y in rect.size.y:
        for _x in rect.size.x:        
            var x = _x + rect.position.x
            var y = _y + rect.position.y
            image.set_pixel(x, y, color)
            
            

func _init():
    _update()
 


