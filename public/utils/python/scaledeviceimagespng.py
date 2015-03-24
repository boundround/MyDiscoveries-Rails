#
# Author: Chris Robertson
#
# Description: Generate images for all devices to aspect ratio best fit
#              an explicit container width and heigth
#
# Inputs
#	1 - JPG quality (worst 0..100 best)
#	2 - Scale
# 3 - Output directory path
# Dependencies: 
#	re - regular expressions

import os
import glob
import json
import math
import re
import sys
from PIL import Image


path = './'

jqual = sys.argv[1]*1
width = float(sys.argv[2])
height = float(sys.argv[3])
output = sys.argv[4]


def rint(num) :
	return int(round(num,0))

def scaleandsave(outpath, width, height, suffix) :
  ipath = (outpath)
  try:
    os.makedirs(ipath)
  except OSError:
      pass

  suffix = str(int(width))

  for infile in glob.glob("*.psd"):
    file, ext = os.path.splitext(infile)
    psd = PSDImage.load(infile)
    im = psd.as_PIL()
    size = rint(width), rint(height)
#    im.thumbnail(size, Image.ANTIALIAS)
    im = im.resize(size)
    im.save(ipath+"/"+file + suffix + ".png", "PNG",quality=int(jqual))

  for infile in glob.glob("*.png"):
    file, ext = os.path.splitext(infile)
    im = Image.open(infile)
    size = rint(width), rint(height)
#    im.thumbnail(size, Image.ANTIALIAS)
    im = im.resize(size)
    im.save(ipath+"/"+file + suffix + ".png", "PNG",quality=int(jqual))

  for infile in glob.glob("*.jpg"):
    file, ext = os.path.splitext(infile)
    im = Image.open(infile)
    size = rint(width), rint(height)
#    im.thumbnail(size, Image.ANTIALIAS)
    im = im.resize(size)
    im.save(ipath+"/"+file + suffix + ".png", "PNG",quality=int(jqual))

  for infile in glob.glob("*.JPG"):
    file, ext = os.path.splitext(infile)
    im = Image.open(infile)
    size = rint(width), rint(height)
#    im.thumbnail(size, Image.ANTIALIAS)
    im = im.resize(size)
    im.save(ipath+"/"+file + suffix + ".png", "PNG",quality=int(jqual))

  for infile in glob.glob("*.jpeg"):
    file, ext = os.path.splitext(infile)
    im = Image.open(infile)
    size = rint(width), rint(height)
#    im.thumbnail(size, Image.ANTIALIAS)
    im = im.resize(size)
    im.save(ipath+"/"+file + suffix + ".png", "PNG",quality=int(jqual))

  for infile in glob.glob("*.JPEG"):
    file, ext = os.path.splitext(infile)
    im = Image.open(infile)
    size = rint(width), rint(height)
#    im.thumbnail(size, Image.ANTIALIAS)
    im = im.resize(size)
    im.save(ipath+"/"+file + suffix + ".png", "PNG",quality=int(jqual))

#  for infile in glob.glob("*.png"):
#    file, ext = os.path.splitext(infile)
#    im = Image.open(infile)
#    size = rint(im.size[0]*scale), rint(im.size[1]*scale)
#    im.thumbnail(size, Image.ANTIALIAS)
#    im.save(ipath+"/"+file + suffix + ".png", "PNG")

scaleandsave(output,width,height,"")
