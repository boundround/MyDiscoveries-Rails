import json
import re
import sys
import os

from psd_tools import PSDImage

fname = sys.argv[1]
psd = PSDImage.load(fname)

filter = ""
print len(sys.argv)
if len(sys.argv) > 2 :
	filter = sys.argv[2]

layermetas = []
lm = []

class LayerMeta:
	name = ''
	x = 0
	y = 0
	w = 0
	h = 0


def recurselayers(g):
  j = g.__class__.__name__
  if j == 'Group':
    for gn in g.layers:
      if gn.visible :
        recurselayers(gn)

    if g.visible :
      lm = LayerMeta()
      lm.name = g.name
      lm.w = g.bbox.width
      lm.h = g.bbox.height
      lm.x = g.bbox.x1
      lm.y = g.bbox.y1
      lm.visible = g.visible
      print lm.name
      layermetas.insert(0,lm)
      layer_image = g.as_PIL()
      if layer_image != None :
        matching = re.search(filter,g.name)
        if matching != None :
          jpg = re.search(".jpg",g.name)
          if jpg != None :
            layer_image.save(g.name,"JPEG")
          else :
            layer_image.save(g.name+'.png',"PNG")

for g in psd.layers:
  for h in g.layers:
    if h.visible :
      recurselayers(h)

joe = []
with open('meta.json', 'w') as outfile:
	for ls in layermetas :
		data = ls.__dict__
		data['x']=data['x']/2.
		data['y']=data['y']/2.
		data['w']=data['w']/2.
		data['h']=data['h']/2.
		if data['visible'] :
			polaroid = re.search(filter,data['name'])
			if polaroid != None :
				joe.append(data)

print json.dumps(joe)
#  outfile.close()

#		json.dump(ls.__dict__, outfile)

