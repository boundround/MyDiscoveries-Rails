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

cd "./launchimage"
i=0
for crap in "${launchws[@]}"
do
  echo $crap
  python "../../scripts/arscaledeviceimagespng.py" 100 ${launchws[$i]} ${launchhs[$i]} output
  ((i++))
done

i=0
cd "../appicon"
for is in "${iconsizes[@]}"
do
  echo $is
  python "../../scripts/arscaledeviceimagespng.py" 100 ${is} ${is} output
  ((i++))
done


