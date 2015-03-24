#!/bin/bash

#Example script for batch renaming files based on string substitute
#This replaces all "@2x" with nothing in all files with .jpg extension

cline="^\s*\#"
IFS=$'\n'

targethost="http://localhost:3000/"
sourcehost="http://boundround.com/"

for f in *.txt; 
do 
	bline=''
	for aline in `cat $f`
	do
		if [[ ! $aline =~ ${cline} ]]; then
				if [ -z "$bline" ]; then
				  bline=`echo $aline| sed 's/ *\s*\| *\s*//g'`
				else	
  			  bline="$bline,`echo $aline| sed 's/ *\s*\| *\s*//g'`"
				fi
		fi
	done;
	gl=`echo $f | sed 's/.txt//g'`
	bline=`echo $bline | tr '[:upper:]' '[:lower:]'` 
	echo "UPDATE games SET url='${targethost}activities/Wordsearch/?hidden_words=$bline' where url='${sourcehost}Puzzles/word-search-game/?puzzle=$gl';\n"
done;
