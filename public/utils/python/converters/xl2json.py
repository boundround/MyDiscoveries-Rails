import sys

import json, codecs

import ucsv as csv
import copy

from string import join

import xlrd

def fillarraydict(sheet,anarray) :
  for r in range (1, sheet.nrows) :
    adict = {}
    for c in range (0, sheet.ncols) :
      adict[sheet.cell_value(rowx=0, colx=c)] = sheet.cell_value(rowx=r, colx=c)
    anarray.append(copy.deepcopy(adict))
    
#Return all matching dictionaries containing the key value pair in the array
def fkv(anarray,key,value) :
  rarray = []
  for adict in anarray :
    if adict[key] == value :
      rarray.append(adict)
  if len(rarray) < 1 :
    print("Can't find ",key, ":", value)
    rarray.append(adict)
  return rarray

#Return all matching dictionaries containing the key value pair in the array
def fkvkv(anarray,key,value,key1,value1) :
  rarray = []
  for adict in anarray :
    if (adict[key] == value) & (adict[key1] == value1) :
      rarray.append(adict)
#  if len(rarray) < 1 :
#    print("Can't find ",key, ":", value)
#    rarray.append(adict)
  return rarray

def mergedict(src,dest) :
  if src != None :
    for key, value in src.iteritems() :
      dest[key] = value

book = xlrd.open_workbook(sys.argv[1])
#print "The number of worksheets is", book.nsheets


#for sn in book.sheet_names() :
#  sheet = book.sheet_by_name(sn)
#  print sheet.name, sheet.nrows, sheet.ncols

approots = []
fillarraydict(book.sheet_by_name("AppRoot"), approots)

areas = []
fillarraydict(book.sheet_by_name("Areas"), areas)

appareas = []
fillarraydict(book.sheet_by_name("AppAreas"), appareas)

places = []
fillarraydict(book.sheet_by_name("Places"), places)

storypages = []
fillarraydict(book.sheet_by_name("Story_Pages"), storypages)

#discountinfos = []
#fillarraydict(book.sheet_by_name("DiscountInfo"), discountinfos)

funfacts = []
fillarraydict(book.sheet_by_name("FunFacts"), funfacts)

areaplacemap = []
fillarraydict(book.sheet_by_name("AreaPlaceMap"), areaplacemap)

locationtypes = []
fillarraydict(book.sheet_by_name("LocationTypes"), locationtypes)

durations = []
fillarraydict(book.sheet_by_name("Durations"), durations)

placedurationmap = []
fillarraydict(book.sheet_by_name("PlaceDurationMap"), placedurationmap)

placelocationmap = []
fillarraydict(book.sheet_by_name("PlaceLocationTypeMap"), placelocationmap)

buttoninfos = []
fillarraydict(book.sheet_by_name("ButtonInfos"), buttoninfos)

games = []
fillarraydict(book.sheet_by_name("Games"), games)

introblurbs = []
fillarraydict(book.sheet_by_name("IntroBlurbs"), introblurbs)

passportinfos = []
fillarraydict(book.sheet_by_name("PassportInfos"), passportinfos)

journalinfos = []
fillarraydict(book.sheet_by_name("JournalInfos"),journalinfos)

for area in areas :
  area['story_infos'] = []
  area['discount_infos'] = []


for place in places :
  place['duration'] = []
  place['locationtype'] = []

#Flatten Places
for placeduration in placedurationmap :
  place = fkv(places,"PlaceID",placeduration['PlaceID'])[0]
  duration = fkv(durations,"DurationID",placeduration['DurationID'])[0]
  place['duration'].append(duration['Duration'])

for placelocation in placelocationmap :
  place = fkv(places,"PlaceID",placelocation['PlaceID'])[0]
  locationtype = fkv(locationtypes,"LocationTypeID",placelocation['LocationTypeID'])[0]
  place['locationtype'].append(locationtype['LocationType'])

for placelocation in placelocationmap :
  place = fkv(places,"PlaceID",placelocation['PlaceID'])[0]
  locationtype = fkv(locationtypes,"LocationTypeID",placelocation['LocationTypeID'])[0]
  place['locationtype'].append(locationtype['LocationType'])

for place in places :
  if place['5-8yrs'] == "yes" :
#    ssa = fkvkv(storypages,"PlaceID",place["PlaceID"],"Go/no-go","go")
    ssa = fkv(storypages,"PlaceID",place["PlaceID"])
    place['story_segments'] = ssa

for storypage in storypages :
  funfact = fkv(funfacts,"FunFactID",storypage["FunFactID"])[0]
  mergedict(funfact,storypage)
  if storypage["images"] != "" :
    storypage["images"] = json.loads(storypage["images"])
  else :
    storypage["images"] = []
  storypage["audio_text"] = {}
  storypage["audio_text"]["text"] = storypage["Story text"]
  storypage["audio_text"]["audio"] = storypage["Narration Audio File"]+"."+storypage["Audio File Extension"]
  storypage["sound_effects"] = json.loads(storypage["sound_effects"])


for areaplace in areaplacemap :
  area = fkv(areas,"AreaID",areaplace["AreaID"])[0]
  place = fkvkv(places,"PlaceID",areaplace["PlaceID"],"5-8yrs","yes")
  if len(place) > 0 :
    area['story_infos'].append(place[0])
    area['discount_infos'].append(place[0])

for apparea in appareas :
  area = fkv(areas,"AreaID",apparea["AreaID"])[0]
  buttoninfo = fkv(buttoninfos,"AreaID",apparea["AreaID"])[0]
  buttoninfo['map_location_ipad'] = {}
  buttoninfo['map_location_ipad']['x'] = buttoninfo['ipad_x']
  buttoninfo['map_location_ipad']['y'] = buttoninfo['ipad_y']
  buttoninfo['map_location_iphone'] = {}
  buttoninfo['map_location_iphone']['x'] = buttoninfo['iphone_x']
  buttoninfo['map_location_iphone']['y'] = buttoninfo['iphone_y']
  apparea['button_info'] = buttoninfo
  mergedict(area,apparea)

  game = json.loads(fkv(games,"AreaID",apparea["AreaID"])[0]['JSON'])
  apparea['game'] = game
  
  introblurb = fkv(introblurbs,"AreaID",apparea["AreaID"])[0]
  apparea['intro_blurb'] = introblurb

  passportinfo = fkv(passportinfos,"AreaID",apparea["AreaID"])[0]
  apparea['passport_info'] = passportinfo

  apparea['backpack_info'] = {}
  apparea['backpack_info']['funfacts'] = []
  apparea['backpack_info']['video'] = apparea['LocalKidVideo']
  apparea['backpack_info']['games'] = []
  apparea['backpack_info']['games'].append(game)

  apparea['journal_info'] = {}
  apparea['journal_info']['questions'] = json.loads(fkv(journalinfos,"AreaID",apparea["AreaID"])[0]["questions"])

approots[0]['locations'] = appareas

print json.dumps(approots[0])


#print "Worksheet name(s):", book.sheet_names()
#sh = book.sheet_by_index(0)
#print sh.name, sh.nrows, sh.ncols
#print "Cell D30 is", sh.cell_value(rowx=2, colx=3)
#for rx in range(sh.nrows):
#    print sh.row(rx)
# Refer to docs for more details.
# Feedback on API is welcomed.

