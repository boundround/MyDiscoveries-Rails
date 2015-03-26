#
# Author: Chris Robertson
#
# Description: Generate locations.json file from Bound Round v1.2 Excel database
#							Also validate against resource directory containing audio, video & image files
#
# Inputs
#	1 - Excel Database File path
#	2 - App Name (e.g. SydneyApp)
#   3 - Root directory of resource tree (to check consistency of audio, images, video)
# Dependencies: 
#	re - regular expressions
#	xlrd (reader) - package at https://pypi.python.org/pypi/xlrd (also see: http://www.python-excel.org)

import sys

import json, codecs

import ucsv as csv
import copy

from string import join

import xlrd
import re

import fnmatch
import os
 
#rootPath = './Resources'
pattern = '*.mp3'

ignore_pattern = '(ignore)'

area_id = sys.argv[2]

resource_tree = sys.argv[3]
all_resources_tree = resource_tree+"/.."


def pathtobundlejpggamefile(bundlename,filename,gamedirectory,gamebundle) :
  if gamebundle == "Main" :
    return pathtobundlejpgfilefrommainbundlegame(bundlename,filename,gamedirectory)
  else :
    return pathtobundlejpgfilefrombundlegame(bundlename,filename,gamedirectory)

#!!This ONLY works if the games are in the main bundle!!
#Assumes HTML game is in mainbundle/Puzzles/<game>
#So to get to documents directory ../../../Documents
def pathtobundlejpgfilefrommainbundlegame(bundlename,filename,gamedirectory) :
  return '../../../Documents/AirplaneMode/'+bundlename+'/'+bundlename+'.bundle/'+gamedirectory+'/'+filename+'.jpg'

#!!This ONLY works if the games are in a downloaded bundle!!
#Assumes HTML game is in AirplaneMode/bundle_name/bundle_name.bundle/games/<game>
#So to get to another bundle resource just ../../../../
def pathtobundlejpgfilefrombundlegame(bundlename,filename,gamedirectory) :
  return '../../../../'+bundlename+'/'+bundlename+'.bundle/'+gamedirectory+'/'+filename+'.jpg'

# Recursive check for file existence
def doesfileexist(filename,path) :
	for root, dirs, files in os.walk(path):
		for jname in fnmatch.filter(files, filename) :
			return True
	return False

#Create a dictionary array for all rows in an excel sheet with single column filtering
#	sheet - Name of Excel sheet
# anarray - Array to populate
# checkcolum - Column to filter selection on
# mustmatch - String to match the in filter column
def fillarraydictcheck(sheet,anarray,checkcolumn,mustmatch) :
	for r in range (1, sheet.nrows) :
		adict = {}
		for c in range (0, sheet.ncols) :
			header = sheet.cell_value(rowx=0, colx=c)
			ip = re.search(ignore_pattern, header, re.IGNORECASE)
			if(ip == None ) :
				adict[header] = sheet.cell_value(rowx=r, colx=c)

#		print r, json.dumps(adict)
		if adict[checkcolumn] == mustmatch :
			anarray.append(copy.deepcopy(adict))

def fillarraydictexcheck(sheet,anarray,checkcolumn,mustnotmatch) :
	for r in range (1, sheet.nrows) :
		adict = {}
		for c in range (0, sheet.ncols) :
			header = sheet.cell_value(rowx=0, colx=c)
			ip = re.search(ignore_pattern, header, re.IGNORECASE)
			if(ip == None ) :
				adict[header] = sheet.cell_value(rowx=r, colx=c)

#		print r, json.dumps(adict)
		if adict[checkcolumn] != mustnotmatch :
			anarray.append(copy.deepcopy(adict))


#Create a dictionary array for all rows in an excel sheet
#	sheet - Name of Excel sheet
# anarray - Array to populate
def fillarraydict(sheet,anarray) :
	for r in range (1, sheet.nrows) :
		adict = {}
		for c in range (0, sheet.ncols) :
			header = sheet.cell_value(rowx=0, colx=c)
			ip = re.search(ignore_pattern, header, re.IGNORECASE)
			if(ip == None ) :
				adict[header] = sheet.cell_value(rowx=r, colx=c)
    
		anarray.append(copy.deepcopy(adict))
    
#Return all matching dictionaries containing the key value pair in the array
def fkvnoblank(anarray,key,value,colmust) :
  rarray = []
  for adict in anarray :
    if adict[key] == value :
      if adict[colmust] != "":
        rarray.append(adict)
  if len(rarray) < 1 :
    print "Can't find vector for ",key, ":", value
#		print("Can't find ",key, ":", value, " in ", json.dumps(anarray))
  return rarray

#Return all matching dictionaries containing the key value pair in the array
def fkv(anarray,key,value) :
  rarray = []
  for adict in anarray :
    if adict[key] == value :
      rarray.append(adict)
  if len(rarray) < 1 :
    print "Can't find vector for ",key, ":", value
  #		print("Can't find ",key, ":", value, " in ", json.dumps(anarray))
  return rarray

#Return all matching dictionaries containing the key value pair in the array
def fkvdebug(anarray,key,value) :
  rarray = []
  for adict in anarray :
    print("looking for value ",value," to match ", adict[key])
    if adict[key] == value :
      rarray.append(adict)
  if len(rarray) < 1 :
    print "Can't find vector for ",key, ":", value
    #		print("Can't find ",key, ":", value, " in ", json.dumps(anarray))
  return rarray

#Return all matching dictionaries containing the key value pair in the array
#Don't care if we can't find it
def fkvchk(anarray,key,value) :
	rarray = []
	for adict in anarray :
		if adict[key] == value :
			rarray.append(adict)
	return rarray

#Return all matching dictionaries containing the key value pair in the array with filtering
#key1 - Filter key
#value1 = Filter value (to be chosen dict[key1] == value1
def fkvkv(anarray,key,value,key1,value1) :
	rarray = []
	for adict in anarray :
		if (adict[key] == value) & (adict[key1] == value1) :
			rarray.append(adict)
	#  if len(rarray) < 1 :
	#    print("Can't find ",key, ":", value)
	#    rarray.append(adict)
	return rarray

#Combine two dictonaries (shallow copy, CARE WITH nested DICIONARIES & ARRAYS?
def mergedict(src,dest) :
	if src != None :
		for key, value in src.iteritems() :
			dest[key] = value


#************************ENTRY POINT****************************


book = xlrd.open_workbook(sys.argv[1])
#print "The number of worksheets is", book.nsheets

arearoot = [{},{}]

areas = []
#areas_full = []
fillarraydictcheck(book.sheet_by_name("Areas"), areas,"identifier",area_id)

places = []
#fillarraydict(book.sheet_by_name("Places"), places)
fillarraydictexcheck(book.sheet_by_name("Places"), places, "Area_Type", "out")

#for place in places :
  #Check for existence of the image file
#  if place["Icon"] != "" :
#    simage = place["Icon"]
#    if not(doesfileexist(simage,resource_tree)) :
#      print place["venue_name"].encode('ascii','xmlcharrefreplace')+","+simage+", icon file missing at : "+resource_tree

#  if place["Video"] != "" :
#    simage = place["Video"]
#    if not(doesfileexist(simage,resource_tree)) :
#      print place["venue_name"].encode('ascii','xmlcharrefreplace')+","+simage+", video file missing at : "+resource_tree

photopages = []
fillarraydict(book.sheet_by_name("Photo_Pages"), photopages)
#Exclude all places with Area_Type = out
#fillarraydictexcheck(book.sheet_by_name("Photo_Pages"), photopages, "Area_Type", "out")

#funfacts = []
#fillarraydict(book.sheet_by_name("FunFacts"), funfacts)

  #Check for existence of the audio file
#	if photopage["story narration file"] != "" :
#		simage = photopage["story narration file"]
#    if not(doesfileexist(simage,resource_tree)) :
#      ted = fkvchk(places,"PlaceID",photopage["PlaceID"])
#      if len(ted) > 0 :
#        print ted[0]["venue_name"].encode('ascii','xmlcharrefreplace')+","+simage+", story narration missing at : "+resource_tree

#Insert buttoninfo, game, introblurb, passportinfo, backpackinfo, journal_info
print "getting places for area"
for area in areas :
  print("Length of places",len(places))
  ssa = fkvnoblank(places,"Area",area["Code"],"identifier")
  area['places'] = ssa


  places_with_stories = []

  print "getting photo pages vector for each place"
  for place in area['places'] :
    #Link relevant photo pages into places for all areas retrieved
    ssa = fkvnoblank(photopages,"PlaceID",place["PlaceID"],"image_file_name")
    #    ssa = fkv(storypages,"PlaceID",place["PlaceID"])

    #if there are no story pages, I don't want the location
    if len(ssa) > 0 :
      
      places_with_stories.append(place)
      
    place['photo_pages'] = ssa
    
  #Check for existence of the image file
    if place["Icon"] != "" :
      simage = place["Icon"]+"*"
      if not(doesfileexist(simage,all_resources_tree)) :
        ted = fkvchk(areas,"Code",place["Area"])
        if len(ted) > 0 :
          print ted[0]["Display_name"].encode('ascii','xmlcharrefreplace')+","+simage+", icon file missing at : "+resource_tree

  #Check for existence of the image file
    if place["Logo_image"] != "" :
      simage = place["Icon"]+"*"
      if not(doesfileexist(simage,all_resources_tree)) :
        ted = fkvchk(areas,"Code",place["Area"])
        if len(ted) > 0 :
          print ted[0]["Display_name"].encode('ascii','xmlcharrefreplace')+","+simage+", logo image missing at : "+all_resources_tree

    for photopage in place['photo_pages'] :
    #  if photopage["FunFactID"] != "" :
    #    funfact = fkv(funfacts,"FunFactID",photopage["FunFactID"])
    #    if len(funfact) > 0 :
    #      funfact = funfact[0]
    #      mergedict(funfact,photopage)

    #Check for existence of the image file
      if photopage["image_file_name"] != "" :
        simage = photopage["image_file_name"]+"*"
        if not(doesfileexist(simage,resource_tree)) :
          ted = fkvchk(places,"PlaceID",photopage["PlaceID"])
          if len(ted) > 0 :
            print ted[0]["venue_name"].encode('ascii','xmlcharrefreplace')+","+simage+", image filename missing at : "+resource_tree

    #Check for existence of audio files
      if photopage["sound_sprite_audio_file"] != "" :
        simage = photopage["sound_sprite_audio_file"]+"*"
        if not(doesfileexist(simage,resource_tree)) :
          ted = fkvchk(places,"PlaceID",photopage["PlaceID"])
          if len(ted) > 0 :
            print ted[0]["venue_name"].encode('ascii','xmlcharrefreplace')+","+simage+", audio filename missing at : "+resource_tree


  area['places'] = places_with_stories

  for place in area['places'] :
    jsonRep = {}
    if place['Game'] == 'wordsearch' :
      jsonRep['Type'] = "WordSearch"
      jsonRep['Bundle'] = "Main"
      jsonRep['Path'] = "Puzzles/WordSearch/demo.html"
      jsonRep['Instructions']=['Find all the words!','Tap and drag over hidden words','Tap the word in list for help']

      jsonRep['Parameters']=['Grid Size','Font','Font Color','Background Color','Border Color','Words']
      jsonRep['Grid Size'] = "12"
      jsonRep['Font'] = "Handlee"
      jsonRep['Font Color'] = "0000FF"
      jsonRep['Background Color'] = "EEEEEE"
      jsonRep['Border Color'] = "999999"
      wstr = place['Game_parameters']
      wstr = wstr.replace(u"\u201c",'')
      wstr = wstr.replace(u"\u201d",'')
      wstr = wstr.replace('"','')
      wstr = wstr.replace(' ','')
      jsonRep['crap'] = wstr
      jsonRep['Words'] = wstr.split(',')


    elif place['Game'] == 'slider' :
      jsonRep['Type'] = "Sliding"
      jsonRep['Bundle'] = "Main"
      jsonRep['Path'] = "Puzzles/Sliding/index.html"
      jsonRep['Instructions']=['Complete the Slider Puzzle!','Slide pieces to reassemble the photo','Drag each piece with your finger to move']

      jsonRep['Parameters']=['Size','Photo']
      jsonRep['Size'] = "4"
      
      #ONLY FOR GAMES IN MAIN BUNDLE!
      jsonRep['Photo'] = pathtobundlejpggamefile(area['identifier'],place['Game_parameters'],'games','Main')


    elif place['Game'] == 'jigsaw' :
      jsonRep['Type'] = "Puzzle"
      jsonRep['Bundle'] = "Main"
      jsonRep['Path'] = "Puzzles/Jigsaw/index.html"
      jsonRep['Instructions']=['Complete the Jigsaw Puzzle!','Tap pieces to spin them','Tap, hold and drag to move them']

      jsonRep['Parameters']=['Pieces','Photo']
      jsonRep['Pieces'] = "12"

      #ONLY FOR GAMES IN MAIN BUNDLE!
      jsonRep['Photo'] = pathtobundlejpggamefile(area['identifier'],place['Game_parameters'],'games','Main')
      
    place['Game']=jsonRep


arearoot[0]['locations'] = areas

print json.dumps(areas[0])


