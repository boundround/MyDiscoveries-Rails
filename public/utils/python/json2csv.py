import json, sys, codecs
import ucsv as csv
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

# Load the locations.plist from json version
input = codecs.open(sys.argv[1],"r")
data = json.load(input)
input.close()

# Open output file
with open(sys.argv[2],'w') as csvfile :
#  output = csv.writer(csvfile, encoding="cp1252", delimiter='|',
#                              quotechar='\\', quoting=csv.QUOTE_MINIMAL)
# "mac-roman" on mac excel 2007 corresponds to Macintosh
  output = csv.writer(csvfile, encoding='mac-roman', delimiter='|',
                              quotechar='\\', quoting=csv.QUOTE_MINIMAL)

 
  # TODO output.write(data[0].keys())  # header row
  output.writerow(['id','name'])

  # Iterate the locations list
  for video in data['video'] :
    vid = video['id']
    vname = video['title']
    output.writerow([vid,vname])
