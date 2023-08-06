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







# static function to return interpolated color value for coordinates from (0,0) to (1,1)
# used for me to get the exact same heightmaps values as a shader
static func get_image_interpolated(
    image: Image, # input an image to read, you may get this from a texture
    x: float, # x pos from 0->1
    y :float, # y pos from 0->1
    flip_x: bool = false, # flip the image on the x axis
    flip_y: bool = false, # as above for y
    transpose: bool = false # swap the x and y axis, use in combination with flip_x and flip_y to rotate
    ) -> Color:
    
    ## function reads color values from an image, using a bilinear sample (4 pixels for the final colour)
    ##
    ## has translation options (flip_x, flip_y, transpose):
    ## false, false, false # default no rotation (N)
    ## true, false, true # rotate clockwise 1 (E)
    ## true, true, false # rotate clockwise 2 (S)
    ## false, true, true # rotate clockwise 3 (W)

    var image_size = image.get_size() # image dimensions required to find pixel locations
    
    # ensure input is from 0 to 1, i added the addition as fmod provided odd return values for negative last time i tested
    x = fmod(x+1000000.0,1.0)
    y = fmod(y+1000000.0,1.0)
    
    if flip_x:
        x = 1.0 - x # "reverse" x pos
        x -= 1.0 / image_size.x # flip_x needs a 1 pixel correction as the bilinear is written the forwards way around
        
    if flip_y:
        y = 1.0 - y # "reverse" y pos
        y -= 1.0 / image_size.y # flip_xyneeds a 1 pixel correction as the bilinear is written the forwards way around
        
    if transpose: # swap the x and y
        var x_bak = x
        x = y
        y = x_bak
    
    x *= image_size.x # to find pixel positions we need to scale up by the image size
    y *= image_size.y
    
    x -= 0.5 # - 0.5 so we end up in the middle of our sample (i worked this out by trial and error!)
    y -= 0.5
    
    var image_size_xi: int = int(image_size.x) # ensure int (probabally not required)
    var image_size_yi: int = int(image_size.y)
    var xi: int = int(x) # using ints we locate 4 pixel locations, we cannot reference an image between pixels
    var yi: int = int(y)
    
    # collect 4 pixels, note also wraps around
    var pix1 = image.get_pixel(fmod(xi, image_size_xi), fmod(yi, image_size_yi)) # collect 4 pixels to fade between, note the fmod here causes the pixels to tile infinite
    var pix2 = image.get_pixel(fmod(xi + 1, image_size_xi), fmod(yi, image_size_yi))
    var pix3 = image.get_pixel(fmod(xi, image_size_xi), fmod(yi + 1, image_size_yi))
    var pix4 = image.get_pixel(fmod(xi + 1, image_size_xi), fmod(yi + 1, image_size_yi))
    
    # we need to find the difference between our integer x position, and ideal float x position
    # this shows how where on an imaginary 2x2 pixel square we are, giving our blend values
    var x_fraction: float = x - xi
    var y_fraction: float = y - yi
    
    # this will provide the average color of the 4 pixels, weighted by the ideal float pixel position
    var color1 = lerp(pix1, pix2, x_fraction) # first lerp the top row of pixels
    var color2 = lerp(pix3, pix4, x_fraction) # then the bottom row
    var color3 = lerp(color1, color2, y_fraction) # then the two rows results
                
    return color3
        
