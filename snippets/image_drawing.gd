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
static func get_image_interpolated(heightmap_image: Image, x: float, y :float) -> Color:
    """
    reads the colours of an image using a simple "bilinear filter", this means the returned result is built of four sampled pixel values
    this is so i can read a heightmap from an image
    
    built and tested working on 14/07/2022
    
    x and y coors are from 0 to 1, and then repeat like UV maps
    """
    x = fmod(x+1000000.0,1.0) # these lines ensure the x and y are numbers wrapped into 0->1 (we add 10^6 since negative fmod can be weird)
    y = fmod(y+1000000.0,1.0)
    
    var image_size = heightmap_image.get_size()
    
    x *= image_size.x # scaling to the image size so all texture resolutions give the same results
    y *= image_size.y
    
    x -= 0.5 # - 0.5 so we end up in the middle of our sample (i prob worked this out by trial and error!)
    y -= 0.5
    
    var image_size_xi: int = int(image_size.x) # ensure int (probabally not required)
    var image_size_yi: int = int(image_size.y)
    var xi: int = int(x) # using ints we locate 4 exact pixel locations
    var yi: int = int(y)
    
    var pix1 = heightmap_image.get_pixel(fmod(xi, image_size_xi), fmod(yi, image_size_yi)) # collect 4 pixels to fade between, note the fmod here causes the pixels to tile infinite
    var pix2 = heightmap_image.get_pixel(fmod(xi + 1, image_size_xi), fmod(yi, image_size_yi))
    var pix3 = heightmap_image.get_pixel(fmod(xi, image_size_xi), fmod(yi + 1, image_size_yi))
    var pix4 = heightmap_image.get_pixel(fmod(xi + 1, image_size_xi), fmod(yi + 1, image_size_yi))
    
    var x_fraction: float = x - xi # the part of x past the decimal point (used on the lerps to give the blended position, imagine a small square of 4 pixels)
    var y_fraction: float = y - yi

    var col1 = lerp(pix1, pix2, x_fraction) # first lerp these two b x
    var col2 = lerp(pix3, pix4, x_fraction)
    var col12 = lerp(col1, col2, y_fraction) # then lerp the results by y
                
    return col12
