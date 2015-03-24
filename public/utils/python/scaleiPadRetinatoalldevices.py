import os
import glob
import json
import math
import re
import sys
from PIL import Image
from psd_tools import PSDImage


path = './'

myquality=100*1
if len(sys.argv) > 1 :
	myquality = sys.argv[1]*1

print "myquality","= ",myquality

def rint(num) :
	return int(round(num,0))

def scaleandsave(outpath,scale,suffix) :
  ipath = (outpath)
  try:
    os.makedirs(ipath)
  except OSError:
      pass

  for infile in glob.glob("*.psd"):
    file, ext = os.path.splitext(infile)
    psd = PSDImage.load(infile)
    im = psd.as_PIL()
    size = rint(im.size[0]*scale), rint(im.size[1]*scale)
    im.thumbnail(size, Image.ANTIALIAS)

# PSDs encountered at moment are memory game cards
#    im.save(ipath+"/"+file + suffix + ".png", "PNG",quality=int(myquality))
    im.save(ipath+"/"+file + suffix + ".jpg", "JPEG",quality=int(myquality))
#    im.save(ipath+"/"+file + suffix + ".png", "PNG")

  for infile in glob.glob("*.png"):
    file, ext = os.path.splitext(infile)
    im = Image.open(infile)
    size = rint(im.size[0]*scale), rint(im.size[1]*scale)
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(ipath+"/"+file + suffix + ".png", "PNG",quality=int(myquality))

  for infile in glob.glob("*.jpg"):
    file, ext = os.path.splitext(infile)
    im = Image.open(infile)
    size = rint(im.size[0]*scale), rint(im.size[1]*scale)
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(ipath+"/"+file + suffix + ".jpg", "JPEG",quality=int(myquality))

  for infile in glob.glob("*.jpeg"):
    file, ext = os.path.splitext(infile)
    im = Image.open(infile)
    size = rint(im.size[0]*scale), rint(im.size[1]*scale)
    im.thumbnail(size, Image.ANTIALIAS)
    im.save(ipath+"/"+file + suffix + ".jpg", "JPEG",quality=int(myquality))

scaleandsave("../skin/iPad/retina",1,"@2x")
scaleandsave("../skin/iPad/normal",.5,"")
scaleandsave("../skin/iPhone/retina",.4166666667,"_iphone@2x")
scaleandsave("../skin/iPhone/normal",.41666666667/2.,"_iphone")
