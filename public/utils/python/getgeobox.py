#
# Author: Chris Robertson
#
# Description: Transfer all assets for an area defined in the Bound Round Web app to generate iOS app bundles
#              Additionaly, adjust and validate fields for use in the iOS app
#
#               Nice to have : read in the wordsearch game word list 
#
# Inputs
#	1 - Area Name (required to download the app data)

# Dependencies: 
#	re - regular expressions

#Version 4: Improves upon v3, fixes without code change in app.  All HTML5 games now live in the overviews bundle rather than the app bundle. Paths to games now relative to the Airplane mode data directory, no need to figure out paths into the app bundle.

#Version 3: This version now sets all jigsaw and slider game images to online links due to iOS 8 change : https://developer.apple.com/library/ios/technotes/tn2406/_index.html


import urlparse

import sys

from bs4 import BeautifulSoup

import json, codecs

import ucsv as csv
import copy

import urllib2

from string import join

from pprint import pprint

#import xlrd
import re

import fnmatch
import os
import errno
import time

import shutil
import fileinput

area = sys.argv[1]

#wapi = "http://peaceful-bastion-2430.herokuapp.com/areas/" 
wapi = "http://app.boundround.com/areas/" 
wapi_full = wapi+area+".json"

def make_sure_path_exists(path):
    try:
        os.makedirs(path)
    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise    


#IMPORTANT: This function copies all resources into lower_case dest file
# All references to it must also be changed!
def retrievereport(src,dest,itemtype):
    failedDownload = False
    try:
        pngfile = urllib2.urlopen(src)
        #Note, forces lower case on the dest file
        output = open(dest.lower(),'wb')
        output.write(pngfile.read())
        output.close()
#            file, stuff = urllib.urlretrieve(src,dest)
    except:
        print("Unable to retrieve : "+src+" for type:"+itemtype)
#        print "exception: n  %s, n  %s, n  %s n  when downloading %s" % (sys.exc_info()[0], sys.exc_info()[1], sys.exc_info()[2], src)
        failedDownload = True
        # remove potentially only partially downloaded file

    if failedDownload and fFileExists(dest):
        removeRetryCount = 0
        while removeRetryCount < 3:
            time.sleep(1) # try to sleep to make the time for the file not be used anymore
            try:
                os.remove(dest)
                return
            except:
                print "exception: n  %s, n  %s, n  %s n  when trying to remove file %s" % (sys.exc_info()[0], sys.exc_info()[1], sys.exc_info()[2], dest)
                removeRetryCount += 1
    return failedDownload

def replaceAll(file,searchExp,replaceExp):
    for line in fileinput.input(file, inplace=1):
        if searchExp in line:
            line = line.replace(searchExp,replaceExp)
        sys.stdout.write(line)

#************************ENTRY POINT****************************

areapath = "test/"+area+"/"+area+".json"

make_sure_path_exists("test/"+area+"/")

#Download the area JSON file
retrievereport(wapi_full,areapath,"JSON File")

#Remove any "null" values in JSON, replace with empty strings
replaceAll(areapath,"null",'""')        
        
#Load the area json into memory
json_data=open(areapath)
areajson = json.load(json_data)
json_data.close()


#Load game URL photos
min_lat = +91
max_lat = -91

max_lon = -181
min_lon = 181
for place in areajson['places'] :
    
    lat = place['geolocation_latitude']
    lon = place['geolocation_longitude']

    print lat, lon
    
    if lat > max_lat : max_lat = lat
    if lat < min_lat : min_lat = lat
    if lon > max_lon : max_lon = lon
    if lon < min_lon : min_lon = lon
    
# sw, ne
new_ext = (max_lat-min_lat)*.2
max_lat += new_ext/2.
min_lat -= new_ext/2.

new_ext = (max_lon-min_lon)*.2
max_lon += new_ext/2.
min_lon -= new_ext/2.

#print "python fetchandgentiles.py %s %s %s %s 0 12 14 NO #%s" % (min_lat, min_lon, max_lat, max_lon, area)
print "python ../../../scripts/fetchtiles.py %s %s %s %s 0 12 NO #%s" % (min_lat, min_lon, max_lat, max_lon, area)


