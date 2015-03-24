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
photowidths=(265 531 633 1266)
photoheights=(196 393 469 938)
#imagescales=(320./1496. 640./1496. 768./1496. 1496./1496.)
imagescales=(0.213903743 0.427807487 0.513368984 1.)

#Create bundles directory
basepath=`pwd`
areaname=$1
areapath=$basepath/$areaname

cd "./scripts"
scriptspath=`pwd`
cd $basepath

templatepath="$areapath/template"
bundlepath="$basepath/bundles"

#Source Paths that will be copied verbatim
srcpaths=("audio" "en.lproj" "tiles" "videos" "plists")

#AR Fit images
arpaths=("games" "photos")

#Scale images
spaths=("icons")


echo "MAKING BUNDLE DIRECTORY"
mkdir "$bundlepath"

i=0
for device in "${devices[@]}"
do
  devicepath="$bundlepath/$device/$areaname"
  cd "$bundlepath/$device"
  rm -rf -- "$areaname.bundle"
  echo "MAKING DEVICE SPECIFIC BUNDLE DIRECTORY"
  mkdir "$devicepath"

  cd "$templatepath"
  find . -type d -depth | cpio -dumpl "$devicepath"

  j=0
  for dpath in "${srcpaths[@]}"
  do
#    cp -r "$templatepath/${srcpaths[$j]}/*" "$devicepath/$dpath"
    cp -r "$templatepath/${srcpaths[$j]}" "$devicepath"
#    ted='cp -r "$templatepath/${srcpaths[$j]}/*" "$devicepath/$dpath"'
#    echo $ted
#    `$ted`
#    cp -r "${srcpaths[$j]}/*" $dpath this wouldn't work???
    ((j++))
  done

  #AR Fit images
  j=0
  for dpath in "${arpaths[@]}"
  do
    cd "$templatepath/$dpath"
    echo `pwd`
    python "$scriptspath/arscaledeviceimages.py" 70 ${photowidths[$i]} ${photoheights[$i]} "$devicepath/$dpath"
#    acmd="python $scriptspath/arscaledeviceimages.py 70 ${photowidths[$i]} ${photoheights[$i]} $devicepath/$dpath"
#    echo $acmd
#    `$acmd`
    ((j++))
  done

  #Scale images
  j=0
  for dpath in "${spaths[@]}"
  do
    cd "$templatepath/$dpath"
    echo `pwd`
    python "$scriptspath/scaledeviceimages.py" 70 ${imagescales[$i]} "$devicepath/$dpath"
#    echo $acmd
#    `$acmd`
    ((j++))
  done

  ((i++))
  mv "$devicepath" "$devicepath.bundle"

  cd "$devicepath.bundle"
  cd ".."
  rm "$areaname.bundle.zip"
  zip -r "$areaname.bundle.zip" "$areaname.bundle"
  rm -rf -- "$areaname.bundle"

done

