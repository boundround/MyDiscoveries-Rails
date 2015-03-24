#
# Author: Chris Robertson
#
# Description: Generate images for all devices to aspect ratio best fit
#              an explicit container width and heigth
#
# Inputs
#	1 - JPG quality (worst 0..100 best)
#	2 - Container width
# 3 - Container height
# 4 - Output directory path
# Dependencies: 
#	re - regular expressions

import os
import glob
import json
import math
import re
import sys
from PIL import Image
from psd_tools import PSDImage
from os import listdir

path = './'

jqual = float(sys.argv[1])
width = float(sys.argv[2])
height = float(sys.argv[3])
output = sys.argv[4]


def rint(num) :
	return int(round(num,0))

def getARMaxFitSize(image, max_width, max_height) :
  nw = max_width
  nh = max_height

  #Get the original image dimensions to resize
  h = image.size[1]
  w = image.size[0]
  ar = float(h)/float(w)

  max_ar = max_height/max_width

#  print ar, max_ar
  if ar >= max_ar :
    nw = w*nh/h
  else :
    nh = h*nw/w

  return rint(nw), rint(nh)


def arscaleandsave(outpath,width,height,suffix) :
  ipath = (outpath)
  try:
    os.makedirs(ipath)
  except OSError:
      pass

  for infile in glob.glob("*.psd"):
    file, ext = os.path.splitext(infile)
#    print file, ext
    psd = PSDImage.load(infile)
    im = psd.as_PIL()
    size = getARMaxFitSize(im,width,height)
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(ipath+"/"+file + suffix + ".jpg", "JPEG",quality=int(jqual))

  for infile in glob.glob("*.jpg"):
    file, ext = os.path.splitext(infile)
    print file, ext
    im = Image.open(infile)
    size = getARMaxFitSize(im,width,height)
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(ipath+"/"+file + suffix + ".jpg", "JPEG",quality=int(jqual))

  for infile in glob.glob("*.png"):
    file, ext = os.path.splitext(infile)
    print file, ext
    im = Image.open(infile)
    size = getARMaxFitSize(im,width,height)
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(ipath+"/"+file + suffix + ".jpg", "JPEG",quality=int(jqual))

  for infile in glob.glob("*.JPG"):
    file, ext = os.path.splitext(infile)
    print file, ext
    im = Image.open(infile)
    size = getARMaxFitSize(im,width,height)
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(ipath+"/"+file + suffix + ".jpg", "JPEG",quality=int(jqual))

  for infile in glob.glob("*.jpeg"):
    file, ext = os.path.splitext(infile)
    print file, ext
    im = Image.open(infile)
    size = getARMaxFitSize(im,width,height)
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(ipath+"/"+file + suffix + ".jpg", "JPEG",quality=int(jqual))

  for infile in glob.glob("*.JPEG"):
    file, ext = os.path.splitext(infile)
    print file, ext
    im = Image.open(infile)
    size = getARMaxFitSize(im,width,height)
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(ipath+"/"+file + suffix + ".jpg", "JPEG",quality=int(jqual))

  for fn in listdir(path):
#    print fn
    if '.' not in fn:
          # do something  for infile in glob.glob("*."):
#      print fn
      im = Image.open(fn)
      size = getARMaxFitSize(im,width,height)
      im.thumbnail(size, Image.ANTIALIAS)
      im.save(ipath+"/"+file + suffix + ".jpg", "JPEG",quality=int(jqual))

arscaleandsave(output,width,height,"")
