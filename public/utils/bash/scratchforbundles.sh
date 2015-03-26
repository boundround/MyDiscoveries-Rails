#!/bin/bash

#Start in the directory for the area
#There should be a template subdirectory with all golden source data
#We will create a bundles subdirectory then below that directories
#for each device

#Assumes
# ../../scripts exist
#mybase=`pwd`

devices=(iphone iphoneretina ipad ipadretina)
photowidths=(265 531 633 1266)
photoheights=(196 393 469 938)

#Create bundles directory
basepath=`pwd`

templatepath="$basepath/template"
bundlepath="$basepath/bundles"

mkdir bundlepath

i = 0
for device in "${devices[@]}"
do
  devicepath="$bundlepath/$device"
  mkdir $devicepath

  cd $templatepath
  find . -type d -depth | cpio -dumpl $devicepath


done

python ../../../scripts/getVisibleLayers.py ../../skin/Menu.psd
# iphone Puzzle pieces are scaled at 0.4x iPad retina
python ../../../scripts/scaleiPadRetinaMenutoalldevices.py 60
cd ..

#App Specific
python ../../scripts/getVisibleLayers.py ../Passport/passport2048x1330_Docklands.psd
python ../../scripts/getVisibleLayers.py ../MapsIconsMenus/Docklands_MAP_FINAL.psd

#Puzzle game sizing
mkdir puzzle
cd puzzle
python ../../../scripts/getVisibleLayers.py ../../games/puzzle/ICESKATER_Puzzle2.psd
python ../../../scripts/getVisibleLayers.py ../../games/puzzle/RUGBYPLAYER_Puzzle.psd

# iphone Puzzle pieces are scaled at 0.4x iPad retina
python ../../../scripts/scaleiPadRetinaPuzzletoalldevices.py 60
cd ..

#Find Game sizing
mkdir find
cd find
cp ../../games/find/*.jpg .
python ../../../scripts/scaleiPadRetinaFindtoalldevices.py 60
cd ..

#Memory Game copy
cp ../games/memory/*.png .

#Size everything
python ../../scripts/scaleiPadRetinatoalldevices.py 60

# Copy videos
cd ./v12
mkdir shared
cd shared
cp ../../../../video/m4a/*.* .

# Copy audio

cp ../../../../audio/m4a/*.* .



#Run PNGQuant on all png files, reduce to 256 byte colour pallete
#find . -name '*.png' -exec bash -c '/Applications/ImageAlpha.app/Contents/Resources/pngquant -force -ext .png 256 {}' \;
cd ..
