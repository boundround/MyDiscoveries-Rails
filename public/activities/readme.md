# ReadMe

Activities are parameter driven HTML5 apps/games referred to in the Bound Round CMS.  These are the currently supported games and parameter lists.

## [Sliding](http://app.boundround.com/activities/Sliding/index.html)

###Parameters

	"imageurl" : "<internet path to an image>"

	"puzzlesize" : "int" //number of rows/columns

###Example


	http://app.boundround.com/activities/Sliding/index.html?imageurl=http://d1w99recw67lvf.cloudfront.net/photos/large_America_S_Cup_Yachts_65571.jpg&puzzlesize=3
	

## [Jigsaw](http://app.boundround.com/activities/Jigsaw/index.html)

###Parameters

	"imageurl" : "<internet path to an image>"
		
	"puzzlesize" : "int" //number of pieces (will round to integer product)

###Example


	http://app.boundround.com/activities/Jigsaw/index.html?imageurl=http://d1w99recw67lvf.cloudfront.net/photos/large_America_S_Cup_Yachts_65571.jpg&puzzlesize=12
	
## [Wordsearch](http://app.boundround.com/activities/Wordsearch/index.html)

###Parameters
	"hidden_words" : "comma separated word list" //words less than 9 characters, can specify as many words as desired but game picks maximum of six randomly 

	"bgnd_img" : "<internet path to an image>"

###Example


	http://app.boundround.com/activities/Wordsearch/index.html?hidden_words=ted,billy,bob&bgnd_img=http://d1w99recw67lvf.cloudfront.net/photos/large_America_S_Cup_Yachts_65571.jpg
	

## [SaveThePenguin](http://app.boundround.com/activities/SaveThePenguin/index.html)

###Parameters

	none

###Example


	http://app.boundround.com/activities/SaveThePenguin/index.html
	
