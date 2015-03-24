import sys

import json, codecs

import ucsv as csv
import copy

from string import join


def flatten_array(array,separator) :
  output = ""
  for item in array:
    if item == array[-1] :
      output = output + item
    else :
      output = output + item + separator
  return output


def flatten_objectarray(array,separator) :
  return join(map(str,array),separator)


def add_table_row( atable, adict ) :
  atable.append(copy.deepcopy(adict))


def is_sequence(arg):
    return (not hasattr(arg, "strip") and
            hasattr(arg, "__getitem__") or
            hasattr(arg, "__iter__"))


#if this function encounters a field that is a dict/sequence it will dump the sequence as a json string
def table2csv(tablefilename,table) :
  # Open output file
  with open(tablefilename,'w') as csvfile :
  #  output = csv.writer(csvfile, encoding="utf-8", delimiter='|',
  #                              quotechar='\\', quoting=csv.QUOTE_MINIMAL)
  #  output = csv.writer(csvfile, encoding="cp1252", delimiter='|',
  #                              quotechar='\\', quoting=csv.QUOTE_MINIMAL)
  #  output = csv.writer(csvfile, delimiter='|')
  # "mac-roman" on mac excel 2007 corresponds to Macintosh
    output = csv.writer(csvfile, encoding='mac-roman', delimiter='|',
                                quotechar='\\', quoting=csv.QUOTE_MINIMAL)

    fields = []
    row = []

    #output fields
    for key in table[0] :
      fields.append(key)
      row.append("")
    output.writerow(fields)

    for adict in table :
      colindex = 0
      for field in fields :
        if is_sequence(adict[field]) :
#          print(json.dumps(adict[field]))
          row[colindex] = json.dumps(adict[field],ensure_ascii=False)
        else :
          row[colindex] = adict[field]
        
        colindex = colindex + 1
      output.writerow(row)

#if this function encounters a field that is a dict/sequence it will dump the sequence as a json string
def table2jsoncsv(tablefilename,table,pkfield) :
  # Open output file
  with open(tablefilename,'w') as csvfile :
  #  output = csv.writer(csvfile, encoding="utf-8", delimiter='|',
  #                              quotechar='\\', quoting=csv.QUOTE_MINIMAL)
  #  output = csv.writer(csvfile, encoding="cp1252", delimiter='|',
  #                              quotechar='\\', quoting=csv.QUOTE_MINIMAL)
  #  output = csv.writer(csvfile, delimiter='|')
  # "mac-roman" on mac excel 2007 corresponds to Macintosh
    output = csv.writer(csvfile, encoding='mac-roman', delimiter='|',
                                quotechar='\\', quoting=csv.QUOTE_MINIMAL)

    fields = [pkfield,'JSON']
    row = ["",""]

    output.writerow(fields)

    for adict in table :
      row[0] = adict[pkfield]
      row[1] = json.dumps(adict)
      output.writerow(row)


#Tables
areas =[]
#places = []
discountinfos = []
storypages = []
funfacts = []
passportinfos = []
buttoninfos = []
introblurbs = []
journalinfos = []
games = []

# Load the locations.plist from json version
input = codecs.open(sys.argv[1],"r")
#input = open(sys.argv[1],"r")
data = json.load(input)
#print json.dumps(data,ensure_ascii=False,encoding="utf-8")
input.close()

areaid = 0
loc_row = {}
game = {}

# Iterate the locations list
for location in data['locations'] :

  areaid = areaid + 1

  # location primary keys
  loc_row["areaid"] = areaid
  loc_row["address"] = location["address"]
  loc_row["free"] = location["free"]
  loc_row["identifier"] = location["identifier"]
  loc_row["name"] = location["name"]

  # "has a" simple 1-1 relationships, represent as single row
  button_info_d = location['button_info']
  button_info_d["areaid"] = areaid
  add_table_row(buttoninfos,button_info_d)

  intro_blurb_d = location['intro_blurb']
  intro_blurb_d['areaid'] = areaid
  add_table_row(introblurbs,intro_blurb_d)
  
  passport_info_d = location['passport_info']
  passport_info_d['areaid'] = areaid
  add_table_row(passportinfos,passport_info_d)

  # "has a" 1-1 but child has embedded array
  
  #strip down backpack_info, no longer separate entity
  backpack_info_d = location['backpack_info'] #fun facts
  loc_row["kidvideo"] = backpack_info_d['video']
  for funfact in backpack_info_d['funfacts'] :
    funfact['areaid'] = areaid
    add_table_row(funfacts,funfact)

  #strip out game, no longer part of story
  story_info = location['story_info'] #story segments
  game = story_info['game']
  game['areaid'] = areaid
  add_table_row(games,game)

  storypagenumber = 0
  for storypage in story_info['story_segments'] :
    storypagenumber = storypagenumber + 1
    storypage['pagenumber'] = storypagenumber
    storypage['areaid'] = areaid
    #ISSUE HERE, IMAGE KEY IS ARRAY, MAYBE HANDLE IN OUTPUT AS JSON?
    add_table_row(storypages,storypage)
    
# v2   story_infos_a = location['story_infos']
  journal_info_d = location['journal_info'] #questions
  journal_info_d['areaid'] = areaid
  add_table_row(journalinfos,journal_info_d)


  # "has a" 1-m relationship
  discount_infos_a = location['discount_infos']
  for discountinfo in discount_infos_a :
    discountinfo['areaid'] = areaid
    add_table_row(discountinfos,discountinfo)

  add_table_row(areas,loc_row)

#  print(areas[0]['areaid'])

table2csv("areas.txt",areas)
table2csv("discountinfos.txt",discountinfos)
table2csv("storypages.txt",storypages)
table2csv("funfacts.txt",funfacts)
table2csv("passportinfos.txt",passportinfos)
table2csv("buttoninfos.txt",buttoninfos)
table2csv("introblurbs.txt",introblurbs)
table2csv("journalinfos.txt",journalinfos)
table2jsoncsv("games.txt",games,"areaid")

