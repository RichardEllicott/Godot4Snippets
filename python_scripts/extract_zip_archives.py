"""

script to extract and rename ai generated tetures from

https://poly.cam/tools/ai-texture-generator


for each zip file in current dir

extract the contents (which are just plains albedo.png, roughness.png etc) .. renamed based on the archive name


shop front facade 2.zip

=>

shop_front_facade_2_albedo.png
shop_front_facade_2_displacement.png
shop_front_facade_2_normal.png


"""


import glob

import zipfile

import os

from PIL import Image  # to resize images


OVERWRITE = True

RESIZE_IMAGES = True

resize_dimensions = (256, 256)


for filename in glob.glob("*.zip"):

    extract_dir = "{}/".format(filename)

    print('found archive "{}"...'.format(filename))

    with zipfile.ZipFile(filename, "r") as zf:

        for name in zf.namelist():

            new_filename = "{}_{}".format(filename.split('.')[0], name).replace(' ', '_')

            if os.path.isfile(new_filename):
                print('file "{}" already exists!'.format(new_filename))

                if OVERWRITE:
                    print("deleting old file...")
                    os.remove(new_filename)
                else:
                    print("skipping...")
                    continue

            zf.extract(name)  # extract to working dir
            os.rename(name, new_filename)

            print('created file "{}"...'.format(new_filename))

            if RESIZE_IMAGES:
                image = Image.open(new_filename)
                image.thumbnail(resize_dimensions)
                image.save(new_filename)


    #     # zip_ref.extractall("targetdir")
    #     pass
