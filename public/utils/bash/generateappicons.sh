#!/bin/bash

#Start in the directory for the area
#There should be a template subdirectory with all golden source data
#We will create a bundles subdirectory then below that directories
#for each device

#Assumes
# ./scripts exist
#mybase=`pwd`

devices=(iphone iphoneretina ipad ipadretina)
#devices=(iphone)

#app store(1)  app icon(3)  spotlight(2), settings(2), toolbar
iconsizes=(1024 120 152 144 114 100 80 76 72 60 50 40 57 29)

#iphone 5  iphone 4s  ipad  ipad hi-res
launchws=(1136 960 1024 2048)
launchhs=(640 640 768 1536)

basepath=`pwd`

retinaicon=$1
retinalaunch=$2

cd "./launchimage"
i=0
for crap in "${launchws[@]}"
do
  echo $crap
  python "../../scripts/scaledeviceimagespng.py" 100 ${launchws[$i]} ${launchhs[$i]} output
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


