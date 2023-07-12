"""

grabbing the viewport as an image

i am unsure about image.convert(Image.FORMAT_RGBA8), seems to add size might be needed for alpha

"""



## get viewport as an image (for a screenshot)
## examle:
## var image = get_viewport_image(get_viewport())
static func get_viewport_image(viewport: Viewport) -> Image:
    var image: Image = viewport.get_texture().get_image()
#    image.convert(Image.FORMAT_RGBA8) # converts to 4 channel 8 bit (to keep the alpha)
#    image.flip_y() # no longer required in Godot 4
    return image
