import json, sys, codecs
import ucsv as csv
from string import join

import xml.etree.cElementTree as etree

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

# Load the locations.plist from json version
input = et.parse(sys.argv[1],"r")
root = input.getroot()

# Open output file
with open(sys.argv[2],'w') as csvfile :
#  output = csv.writer(csvfile, encoding="cp1252", delimiter='|',
#                              quotechar='\\', quoting=csv.QUOTE_MINIMAL)
# "mac-roman" on mac excel 2007 corresponds to Macintosh
  output = csv.writer(csvfile, encoding='mac-roman', delimiter='|',
                              quotechar='\\', quoting=csv.QUOTE_MINIMAL)

 
  # TODO output.write(data[0].keys())  # header row
  output.writerow(['area','place','address','intro_text','intro_audio','segment_text','segment_audio','segment_images_s','sound_effects_s','game_type_s','funfacts_s'])

  # Iterate the locations list
  for location in data['locations'] :
    address = location['address']
    free = location['free']
    identifier = location['identifier']
    name = location ['name']

    video_s = location['backpack_info']['video']
    funfacts_s = flatten_objectarray(location['backpack_info']['funfacts'],';')
    mapicon_s = location['button_info']['image']
    intro_audio = location['intro_blurb']['audio']
    intro_text = location['intro_blurb']['text']
    story_info = location['story_info']
    game_type_s = str(story_info['game'])

    story_segments_a = story_info['story_segments']

    for segment in story_segments_a :
      segment_audio = segment['audio_text']['audio']
      segment_text = unicode(segment['audio_text']['text'])
      segment_images_s = flatten_objectarray(segment['images'],';')
      sound_effects_s = flatten_objectarray(segment['sound_effects'],';')

      output.writerow(['Sydney',name,address,intro_text,intro_audio,segment_text,segment_audio,segment_images_s,sound_effects_s,game_type_s,funfacts_s])

# output.writerow([row['website'], row['phone_number'], row['description'], row['venue_name'], row['opening_hours']])
 # output.writerow([row['website'], row['phone_number'], row['description'], row['venue_name'], row['opening_hours']])
#  output.writerow([row['website'], row['phone_number'], row['description'], row['venue_name'], row['opening_hours']])
#  output.writerow([row['website'], row['phone_number'], row['description'], row['venue_name'], row['opening_hours']])
#    output.writerow(row.values())
#website,phone_number,description,venue_name,opening_hours,image,terms_and_conditions,address,identifier,discount_summary

