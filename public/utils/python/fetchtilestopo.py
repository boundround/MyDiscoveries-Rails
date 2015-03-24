import urllib2
import os
import time
import sys
import random

from math import *

def numTiles(z):
  return(pow(2,z))

def sec(x):
  return(1/cos(x))

def latlon2relativeXY(lat,lon):
  x = (lon + 180) / 360
  y = (1 - log(tan(radians(lat)) + sec(radians(lat))) / pi) / 2
#  print x,y
  return(x,y)

def latlon2xy(lat,lon,z):
  n = numTiles(z)
  x,y = latlon2relativeXY(lat,lon)
  return(n*x, n*y)
  
def tileXY(lat, lon, z):
  x,y = latlon2xy(lat,lon,z)
  return(int(x),int(y))

def xy2latlon(x,y,z):
  n = numTiles(z)
  relY = y / n
  lat = mercatorToLat(pi * (1 - 2 * relY))
  lon = -180.0 + 360.0 * x / n
  return(lat,lon)
  
def latEdges(y,z):
  n = numTiles(z)
  unit = 1 / n
  relY1 = y * unit
  relY2 = relY1 + unit
  lat1 = mercatorToLat(pi * (1 - 2 * relY1))
  lat2 = mercatorToLat(pi * (1 - 2 * relY2))
  return(lat1,lat2)

def lonEdges(x,z):
  n = numTiles(z)
  unit = 360 / n
  lon1 = -180 + x * unit
  lon2 = lon1 + unit
  return(lon1,lon2)
  
def tileEdges(x,y,z):
  lat1,lat2 = latEdges(y,z)
  lon1,lon2 = lonEdges(x,z)
  return((lat2, lon1, lat1, lon2)) # S,W,N,E

def mercatorToLat(mercatorY):
  return(degrees(atan(sinh(mercatorY))))

def tileSizePixels():
  return(256)

def tileLayerExt(layer):
  if(layer in ('oam')):
    return('jpg')
  return('png')

def deg2num(lat_deg, lon_deg, zoom):
  lat_rad = radians(lat_deg)
  n = 2.0 ** zoom
  xtile = int((lon_deg + 180.0) / 360.0 * n)
  ytile = int((1.0 - log(tan(lat_rad) + (1 / cos(lat_rad))) / pi) / 2.0 * n)
  return (xtile, ytile)

def toWhirlyY(y,z):
  return numTiles(z) - y #- 1

def tileXYWhirly(lat, lon, z):
  x,y = latlon2xy(lat,lon,z)
  return(int(x),int(toWhirlyY(y,z)))

def tileLayerBase(layer):
  layers = { \
    "tah": "http://cassini.toolserver.org:8080/http://a.tile.openstreetmap.org/+http://toolserver.org/~cmarqu/hill/",
	#"tah": "http://tah.openstreetmap.org/Tiles/tile/",
    "oam": "http://oam1.hypercube.telascience.org/tiles/1.0.0/openaerialmap-900913/",
    "mapnik": "http://tile.openstreetmap.org/mapnik/"
    }
  return(layers[layer])
  
def tileURL(x,y,z,layer):
  return "%s%d/%d/%d.%s" % (tileLayerBase(layer),z,x,y,tileLayerExt(layer))

if __name__ == "__main__":
#  print latlon2relativeXY(-34.157273,150.238037)
#  print "tile.z, tile.xmin, tile.xmax, tile.ymin, tile.ymax, west, south, east, north"

  swlat, swlon = float(sys.argv[1]),float(sys.argv[2])
  nelat, nelon = float(sys.argv[3]),float(sys.argv[4])
  zmin, zmax = int(sys.argv[5]),int(sys.argv[6])
  
  fetch = sys.argv[7]

#  swlat, swlon = -34.157273,150.238037
#  nelat, nelon = -33.574582,151.362762

    
  tilecount = 0

  for z in range(zmin,zmax+1):
#Sydney Region
    xsw,ysw = tileXY(swlat,swlon, z)
#    ysw = toWhirlyY(ysw,z)

    xne,yne = tileXY(nelat,nelon, z)
#    yne = toWhirlyY(yne,z)
    print "%d,%d,%d,%d,%d" % (z,xsw,xne,ysw,yne)
    #print "<img src='%s'><br>" % tileURL(x,y,z)

#    x,y = tileXY(-33.857373,151.21552, z)
#    print "SE: %d: %d,%d --> %1.3f :: %1.3f, %1.3f :: %1.3f" % (z,x,y,s,n,w,e)
#  print tileXYWhirly(-33.8612931,151.2132724, 17)if os.path.exists('tiles') == False:
    if os.path.exists('tiles') == False:
      os.mkdir('tiles')

    checkFirst = True

    numtiles = 1 << z
    print xsw, xne
    print yne, ysw
    for x in range(xsw,xne+1):
        for y in range(yne,ysw+1):
            for type in {'land-usages','water-areas','highroad'}:
                url = 'http://tile.openstreetmap.us/vectiles-%s/%d/%d/%d.topojson' % (type,z,x,y)
                dir = 'tiles/%s' % type
                path = '%s-%d_%d_%d.topojson' % (dir,z,x,y)

                doFetch = True
                if checkFirst:
                    if os.path.exists(path):
                        doFetch = False
            
                if doFetch:
                    if os.path.exists(path) == True:
                        os.remove(path)
#                    if os.path.exists(dir) == False:
#                        os.makedirs(dir)
                    
                    success = False
                    while success == False:
                        try:
                            print path
                            if(fetch == "YES"):
                              response = urllib2.urlopen(url)
                              json = response.read()
                              file = open(path,"w")
                              file.write(json)
                            tilecount += 1
                            success = True
                        except urllib2.URLError as e:
                            print 'Failed to fetch.  Waiting.'
                            time.sleep(10)
                    mewait = 5.*random.random()
                    print "Tile Count = %d" % tilecount
                    if(fetch == "YES"):
                      time.sleep(mewait)
