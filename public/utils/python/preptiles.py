import urllib2
import os
import time
import shutil

if os.path.exists('bundle') == False:
    os.mkdir('bundle')

level = 0
while level < 6:
    x = 0
    while x < 1 << level:
        y = 0
        while y < 1 << level:
            for type in {'land-usages','water-areas'}:
                dir = 'tiles/vectiles-%s' % type
                path = '%s/%d-%d-%d.json' % (dir,level,x,y)
                
                if os.path.exists(path):
                    destpath = 'bundle/%s-%d-%d-%d.json' % (type,level,x,y)
                    shutil.copyfile(path,destpath)
            y = y + 1
        x = x + 1
    level = level + 1
