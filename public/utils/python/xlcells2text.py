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

#area_id = sys.argv[2]

#resource_tree = sys.argv[3]

# Recursive check for file existence
# Behaviour similar to NSBundle lookup routines in Apple paradigm
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
def fkv(anarray,key,value) :
	rarray = []
	for adict in anarray :
		if adict[key] == value :
			rarray.append(adict)
	if len(rarray) < 1 :
		print("Can't find ",key, ":", value)
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
    print("Can't find ",key, ":", value)
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

rows = []
fillarraydict(book.sheet_by_name("Game_Parameters"), rows)

for place in rows:
    if(place['Game']=='wordsearch') :
        wstr = place['Game_parameters']
        wstr = wstr.replace(u"\u201c",'')
        wstr = wstr.replace(u"\u201d",'')
        wstr = wstr.replace('"','')
        wstr = wstr.replace(' ','')
        
        word_list = wstr.split(",")
        f = open(place['identifier']+".txt",'w')
        f.write('# alphabet: abcdefghijklmnopqrstuvwxyz\n')
        f.write('# size: 12\n')
        f.write('# showSolveButton: 0\n')
        f.write('# showDescriptions: 0\n')
        f.write('# totalWords: '+str(len(word_list))+'\n')
        f.write('# initialScore: 1000\n')
        f.write('# every: 10\n')
        f.write('# deduct: 2\n')
        f.write('# puzzleDescription: '+place['venue_name']+'\n')
        f.write('# name: '+place['venue_name']+'\n')
        
        for word in word_list:
            f.write(word+' |\n')
            


