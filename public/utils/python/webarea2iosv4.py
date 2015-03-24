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

import subprocess #required to run shell script 

area = sys.argv[1]

aws_photos_bucket = 'http://brwebproduction.s3.amazonaws.com/photos/'
aws_icons_bucket = 'http://brwebproduction.s3.amazonaws.com/vector_icons/'
br_wordsearch_url = 'http://boundround.com/Puzzles/word-search-game/words/'

#wapi = "http://peaceful-bastion-2430.herokuapp.com/areas/" 
wapi = "http://app.boundround.com/areas/" 
wapi_full = wapi+area+".json"


# Recursive check for file existence
def doesfileexist(filename,path) :
	for root, dirs, files in os.walk(path):
		for jname in fnmatch.filter(files, filename) :
			return True
	return False

def make_sure_path_exists(path):
    try:
        os.makedirs(path)
    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise    

def fFileExists(filePath):
    try:
        st = os.stat(filePath)
    except OSError:
        # TODO: should check that Errno is 2
        return False
    return True


#IMPORTANT: This function copies all resources into lower_case dest file
# All references to it must also be changed!
def retrievereport(src,dest,itemtype):
    failedDownload = False

    if os.path.exists(dest): return False

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

def handleMappedItem(itemtype,item,obj):
    if (item is not None) and (item != '') and (item != 'null'):
        if itemtype == 'photo':
            retrievereport (aws_photos_bucket+urllib2.quote(item), local_photos_bucket+item, itemtype)
#            if '.jpg' in item:
#                retrievereport (aws_photos_bucket+urllib2.quote(item), local_photos_bucket+item)
#            else:
#                retrievereport (aws_photos_bucket+urllib2.quote(item+'.jpg'), local_photos_bucket+item+".jpg")
            
        elif itemtype == 'icon':
#            print(item)
            if item.find(".png") >= 0 : item = item.replace(".png","")
#            item = item.lower()
#            print(item)
            if retrievereport (aws_icons_bucket+urllib2.quote(item+"_m.png"), local_icons_bucket+item+"_m.png", itemtype):
                print("Attempt to force download of icon:"+item+" as _m")
                if retrievereport (aws_icons_bucket+urllib2.quote(item+".png"), local_icons_bucket+item+"_m.png", itemtype):
                    print("Failed!, fix icon: "+item)
            else:
                if retrievereport (aws_icons_bucket+urllib2.quote(item+"_p.png"), local_icons_bucket+item+"_p.png", itemtype):
                    if retrievereport (aws_icons_bucket+urllib2.quote(item+"_m.png"), local_icons_bucket+item+"_p.png", itemtype):
                        print("Ack!, shouldn't reach here! on "+item)
            
        elif itemtype == 'video':
            #This is expecting a link
#            s = 'asdf=5;iwantthis123jasd'
            result = re.search('external\/(.*)\.m3u8', item)
            item = result.group(1)
            try:
                vfile = dropbox_videos_bucket+item+".mp4"
                if fFileExists(vfile) :
                    shutil.copyfile(vfile, (local_videos_bucket+item+".mp4").lower())
                    if 'Video' in obj:
                        obj['Video']=item
                    else:
                        obj['OverviewVideo']=item
                    return None
                else : 
                    print("Can't find video file: "+vfile)
                    return itemtype
            except OSError as e:
                print("Unable to find video: "+dropbox_videos_bucket+item+".mp4")
                print(e)
                return None              
#        elif itemtype == 'game':
#            if item.find(".png") >= 0 : item_target = item.replace(".png",".jpg")
#            retrievereport (aws_photos_bucket+urllib2.quote(os.path.basename(item)), local_games_bucket+os.path.basename(item))

#        elif itemtype == 'gameobject':
#           retrievereport (aws_photos_bucket+urllib2.quote(item), local_games_bucket+os.path.basename(item))

        return None
    else:
        return itemtype

def recurseObj(obj, mapping_rules):
    if isinstance(obj,list):
        for item in obj : recurseObj(item,mapping_rules)

    elif isinstance(obj,dict):
        for k, v in mapping_rules.items():
            if k in obj: 
                ted = handleMappedItem(v,obj[k],obj)
                #Force references to lower case
#                if ted != None: print("Missing Value for: "+k+" of type: "+ted)
#                else:
                if ted == None : 
                    #Force references to lower case
                    obj[k] = obj[k].lower()


        for k, v in obj.items():
                recurseObj(v, mapping_rules)

def replaceAll(file,searchExp,replaceExp):
    for line in fileinput.input(file, inplace=1):
        if searchExp in line:
            line = line.replace(searchExp,replaceExp)
        sys.stdout.write(line)

def loadvideos(vimeo_json):
    
    vimeo_dictionary = {}

    data = json.load(vimeo_json)

    # Iterate the video list
    for video in data['video'] :
        vimeo_dictionary[video['title']] = video['id']
    
    return vimeo_dictionary

#************************ENTRY POINT****************************

#vimeo_videos_json = '/Users/chrisrobertson/Desktop/Workbench/test/vimeo_videos.json'
#vimeo_dictionary = loadvideos(vimeo_videos_json)

local_bucket = './test/'+area+'/template/'
local_photos_bucket = local_bucket+'photos/'
local_icons_bucket = local_bucket+'icons/'
local_games_bucket = local_bucket+'games/'
local_videos_bucket = local_bucket+'videos/'
local_plists_bucket = local_bucket+'plists/'
local_tiles_bucket = local_bucket+'tiles'

make_sure_path_exists(local_bucket)
make_sure_path_exists(local_photos_bucket)
make_sure_path_exists(local_icons_bucket)
make_sure_path_exists(local_games_bucket)
make_sure_path_exists(local_videos_bucket)
make_sure_path_exists(local_plists_bucket)
make_sure_path_exists(local_tiles_bucket)


#Mapping join table
#mapped_rules = { 'HeroPhoto' : 'photo', 'OverviewVideo' : 'video', 'Video' : 'video', 'Logo_image' : 'photo', 'image_file_name' : 'photo', 'Photo' : 'game', 'Icon' : 'icon', "Game" : 'gameobject'}
#mapped_rules = { 'HeroPhoto' : 'photo', 'OverviewVideo' : 'video', 'Video' : 'video', 'Logo_image' : 'photo', 'image_file_name' : 'photo', 'Photo' : 'game', 'Icon' : 'icon'}
mapped_rules = { 'HeroPhoto' : 'photo', 'OverviewVideoLink' : 'video', 'VideoLink' : 'video', 'Logo_image' : 'photo', 'image_file_name' : 'photo', 'Photo' : 'game', 'Icon' : 'icon'}

areapath = "test/"+area+"/"+area+".json"
#Always get a fresh copy of the json from the server
if fFileExists(areapath) : os.remove(areapath)


make_sure_path_exists("test/"+area+"/")

#dropbox_videos_bucket = "/Users/chrisrobertson/Dropbox/Bound Round - Tech Stuff/v1.5/content_template/"+area+"/template/videos/"
dropbox_videos_bucket = "./test/videos/iosvideos/"
dropbox_tiles_bucket = "/Users/chrisrobertson/Dropbox/Bound Round - Tech Stuff/v1.5/content_template/"+area+"/template/tiles/"

#Download the area JSON file
retrievereport(wapi_full,areapath,"JSON File")

#Remove any "null" values in JSON, replace with empty strings
replaceAll(areapath,"null",'""')        
        
#Load the area json into memory
json_data=open(areapath)
areajson = json.load(json_data)
json_data.close()

#Copy Tiles
#shutil.rmtree(local_tiles_bucket+"_old")
#shutil.move(local_tiles_bucket,local_tiles_bucket+"_old")

make_sure_path_exists(local_tiles_bucket)
shutil.rmtree(local_tiles_bucket)
shutil.copytree(dropbox_tiles_bucket, local_tiles_bucket)
    
#Load game URL photos
for place in areajson['places'] :
    pgame = place['Game']
    
    if pgame != "" and pgame != None and isinstance(pgame,basestring) : place['Game'] = json.loads(pgame)

    if not isinstance(place['Game'],basestring) :
    
        url = place['Game']['gameURL']
        if url != "" :
            par = urlparse.parse_qs(urlparse.urlparse(url).query)
    
            if url.find('word-search-game') >= 0 :
                wordspath = par['puzzle'][0]+".txt"
                retrievereport(br_wordsearch_url+wordspath,wordspath,'word search puzzle')
            
                fileref = open(wordspath,"r")
                wcount = 0
                place['Game']['Words'] = []
                for line in fileref:
                    if line.find("#") < 0 :
                        line = line.replace("|","")
                        place['Game']['Words'].append(line.strip())
                        ++wcount
        
            #Downstream scripts convert all game PNGs to jpgs so rename the files in the JSON
            elif url.find('Jigsaw') >= 0 or url.find('Sliding') >= 0:
                gp = par['imageurl'][0]         #e.g. http://x.y.z/photos/a_photo.png
                pgp = urlparse.urlparse(gp)     #   photos/a_photo.png
                pp = os.path.basename(pgp.path) #   a_photo.png
    #            print(os.path.basename(pgp.path))
                retrievereport(gp,local_games_bucket+pp,"Jigsaw & Sliding game image ")
                

#Copy over all the assets
recurseObj(areajson,mapped_rules)

        #Downstream scripts convert all game PNGs to jpgs so rename the files in the JSON
for place in areajson['places'] :
    
    #Fix mismatch in JSON versus iOS app data model
    soup = BeautifulSoup(place['Info_Page'])
    place['Info_Page'] = soup.get_text()
    
    pgame = place['Game']
    if pgame != "" and pgame != None : 

        url = place['Game']['gameURL']
        # VERSION 4 : All games now assumed to be in the overviews bundle.
        place['Game']['Bundle'] = "overviews"

        if url.find('Jigsaw') >= 0 or url.find('Sliding') >= 0:
            par = urlparse.parse_qs(urlparse.urlparse(url).query)
            gp = par['imageurl'][0]
            pgp = urlparse.urlparse(gp)
            pp = os.path.basename(pgp.path)
            #Force lowercase
#            place['Game']['Photo'] = "../../../Documents/AirplaneMode/"+areajson['identifier']+"/"+areajson['identifier']+".bundle/games/"+pp.lower()
#            result = re.search('imageurl\=(.*)\&puzzlesize', place['Game']['gameURL'])
#            place['Game']['Photo'] = result.group(1)
# VERSION 4 : All games now assumed to be in the overviews bundle.
            place['Game']['Bundle'] = "overviews"
            place['Game']['Photo'] = "../../../../../"+areajson['identifier']+"/"+areajson['identifier']+".bundle/games/"+pp.lower()
                
        for photo in place['photo_pages'] :
            pp = photo['image_file_name']
            if pp.find(".png") >= 0 : photo['image_file_name'] = pp.replace(".png",".jpg")
    else :
        if place['Area_Type'] == "Premium": print("STOP!!!  Premium Place "+place['venue_name']+" doesn't have a game and will crash IOS app.")

#Save the adjusted JSON out
with open(areapath, 'w') as outfile:
  json.dump(areajson, outfile)
  
puc = "plutil -convert xml1 %s -o %s%s.plist" % (areapath,local_plists_bucket,area)
print puc
os.system(puc)

