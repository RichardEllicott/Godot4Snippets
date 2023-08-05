"""

image drawing functions


"""

## draw a solid rectangle on an image
static func image_draw_rect(image: Image, rect: Rect2i, color: Color):
    for _y in rect.size.y:
        for _x in rect.size.x:        
            var x = _x + rect.position.x
            var y = _y + rect.position.y
            image.set_pixel(x, y, color)

