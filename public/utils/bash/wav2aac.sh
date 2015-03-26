#!/bin/bash

#Assumes
# ../../scripts exist
#mybase=`pwd`


#find . -name '*.wav' -exec bash -c 'afconvert -f caff -d aac {}' \;
find . -name '*.wav' -exec bash -c 'afconvert -f m4af -d aac -b 64000 {}' \;

#afconvert track.aiff -o track.m4a -q 127 -b 128000 -f m4af -d aac