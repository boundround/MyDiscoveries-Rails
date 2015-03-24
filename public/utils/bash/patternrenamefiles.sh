#!/bin/bash

#Example script for batch renaming files based on string substitute
#This replaces all "@2x" with nothing in all files with .jpg extension

for f in *.jpg; do mv "$f" "`echo $f | sed s/\@2x//g`"; done;