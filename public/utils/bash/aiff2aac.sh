#!/bin/bash

#Assumes
# ../../scripts exist
#mybase=`pwd`


#find . -name '*.wav' -exec bash -c 'afconvert -f caff -d aac {}' \;
#find . -name '*.wav' -exec bash -c 'afconvert -f m4af -d aac -b 64000 {}' \;
find . -name '*.aiff' -exec bash -c 'afconvert -f m4af -d aac -b 64000 {}' \;

#track.aiff -o track.m4a -q 127 -b 128000 -f m4af -d aac