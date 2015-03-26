#!/bin/bash

#Start in the directory for the area
#There should be a template subdirectory with all golden source data
#We will create a bundles subdirectory then below that directories
#for each device

#Assumes
# ./scripts exist
#mybase=`pwd`

thumbsizes=(200)

basepath=`pwd`

cd "./heroes"

for crap in "${thumbsizes[@]}"
do
  echo $crap
  python "../../scripts/arscaledeviceimagespng.py" 100 ${crap} ${crap} output
done

cd "../Logos"
for is in "${thumbsizes[@]}"
do
  echo $is
  python "../../scripts/arscaledeviceimagespng.py" 100 ${is} ${is} output
done


