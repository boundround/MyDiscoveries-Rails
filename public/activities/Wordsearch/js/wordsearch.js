//***********************************************************
//     			WORD SEARCH PUZZLE GAME ON WEBSITE
//***********************************************************

//***********************************************************
//                Create game scene
//***********************************************************	
Crafty.scene("gameScene", function () {	
	var howto = ['Click on the first and last letter to select a word','Click on the first and last letter to select a word','Click on the first and last letter to select a word','Click on the first and last letter to select a word','Click on the first and last letter to select a word','Click on the first and last letter to select a word','Click on the first and last letter to select a word','Click on the first and last letter to select a word','Click on the first and last letter to select a word','Click on the first and last letter to select a word',"Escolhe a primeira e a última letra para marcares a palavra!"];
	var wordsCoord = [],
	SIZE_GRID_X = 9,
	SIZE_GRID_Y = 9,
	letterCoord = new Array(SIZE_GRID_X),
	firstLetterSelected = false,
	firstLetterCoord={},
	wordSignArr = [],
	randomisedArray,
	letterBox=[];

	function addSelectedBar(word,outcome){
		//outcome 0:white 1: reset 2: darken
		var selectedBox;
		if(word.direction=="X") return;
		for (var i = 0 ; i <word.length ; i++){
			 if(word.direction=="N")  selectedBox =letterBox[word.y-i][word.x] ;
				else if (word.direction=="NE") selectedBox =letterBox[word.y-i][word.x+i];
				else if (word.direction=="E")  selectedBox =letterBox[word.y][word.x+i];
				else if (word.direction=="SE") selectedBox =letterBox[word.y +i][word.x+i];
				else if (word.direction=="S")  selectedBox =letterBox[word.y +i][word.x];
				else if (word.direction=="SW") selectedBox =letterBox[word.y +i][word.x-i];
				else if (word.direction=="W")  selectedBox =letterBox[word.y][word.x -i]; 
				else if (word.direction=="NW") selectedBox =letterBox[word.y-i][word.x -i];
			if(outcome ==0)
				selectedBox.css({'background-color': hex2rgb("#ffffff")}) 
			else if(outcome==1)
				selectedBox.css({'background-color': hex2rgb(gameAssets.banner.bgnd_color)});
			else
				selectedBox.css({'background-color': lightenColor(gameAssets.banner.bgnd_color).toRgbString() });			
		}
	}
	function placeWordInArray(word,vector){
		var loop=0;
		for (var i = 0 ; i <word.length ; i++){
			if(vector.direction=="N")  letterCoord[vector.y-i][vector.x] = word[loop];
				else if (vector.direction=="NE") letterCoord[vector.y-i][vector.x+i] = word[loop];
				else if (vector.direction=="E")  letterCoord[vector.y][vector.x+i] = word[loop];
				else if (vector.direction=="SE")  letterCoord[vector.y +i][vector.x+i] = word[loop];
				else if (vector.direction=="S")  letterCoord[vector.y +i][vector.x] = word[loop];
				else if (vector.direction=="SW")   letterCoord[vector.y +i][vector.x-i] = word[loop];
				else if (vector.direction=="W")  letterCoord[vector.y][vector.x -i] = word[loop]; 
				else if (vector.direction=="NW")  letterCoord[vector.y-i][vector.x -i] = word[loop];
			loop++;
		}
		wordsCoord.push(vector);
	}
	function noWordHere(word){
		var val=0;
		for (var i = 0 ; i <word.length ; i++){
			try {
				if(word.direction=="N") val =  letterCoord[word.y-i][word.x];
				else if (word.direction=="NE") val =  letterCoord[word.y-i][word.x+i];
				else if (word.direction=="E") val =  letterCoord[word.y][word.x+i];
				else if (word.direction=="SE") val =  letterCoord[word.y +i][word.x+i];
				else if (word.direction=="S") val =  letterCoord[word.y +i][word.x];
				else if (word.direction=="SW") val =  letterCoord[word.y +i][word.x-i];
				else if (word.direction=="W") val =  letterCoord[word.y][word.x -i]; 
				else if (word.direction=="NW") val =  letterCoord[word.y-i][word.x -i]; 
				if(val!=-1) return false;
			}catch(err){
				return false;
			}	
		}
		return true;
	}
	function randomCoord(){
		var vDirection = ['N','NE','E','SE','S','SW','W','NW'],coord={};
		coord.x = Math.floor((Math.random()*SIZE_GRID_X));
		coord.y = Math.floor((Math.random()*SIZE_GRID_Y));
		coord.direction = vDirection[Math.floor((Math.random()*vDirection.length))];
		return coord;
	}
	function placeLetters(){
		//Initialise Coord array to all -1 
		for (var i=0;i<SIZE_GRID_Y;i++) letterCoord[i]=[-1,-1,-1,-1,-1,-1,-1,-1,-1];
	    //loop through letters and try to find a spot for the game
	   for (wordIdx=0;wordIdx<randomisedArray.length;wordIdx++){
	   	var randCoord,numberOfLoops=0;
	   	do{
	   		randCoord = randomCoord();
	   		randCoord.length = randomisedArray[wordIdx].length;
	   		var foundEmptySpot = noWordHere(randCoord);
	   		numberOfLoops++;
	   	}while(!foundEmptySpot && numberOfLoops<1000)
	   	if (foundEmptySpot) {
	   		var lCoord ={};
	   		placeWordInArray(randomisedArray[wordIdx],randCoord)
	   	}
	   }
	   var alphabet = alphaArr[gameAssets.language_idx];
	    //fill the rest of the array with -1 from foreign alphabet
	    for (var i=0;i<SIZE_GRID_X;i++)
	    	for (var j=0;j<SIZE_GRID_Y;j++)
	    		if(letterCoord[i][j]==-1) letterCoord[i][j] = alphabet.charAt(Math.floor(Math.random() * alphabet.length));
	}
	function getWordDirection(l1c,l2c){
	     	if (l1c.y>l2c.y && l1c.x==l2c.x) return 'N';
	     	else if (l1c.y>l2c.y && l1c.x<l2c.x  &&  ((l1c.y-l2c.y) == (l2c.x-l1c.x)) ) return 'NE';
	     	else if (l1c.y>l2c.y && l1c.x>l2c.x  &&  ((l1c.y-l2c.y) == (l1c.x-l2c.x)) ) return 'NW';
	     	else if (l1c.y<l2c.y && l1c.x==l2c.x  ) return 'S';
	     	else if (l1c.y<l2c.y && l1c.x<l2c.x  &&  ((l2c.y-l1c.y) == (l2c.x-l1c.x)) ) return 'SE';
	     	else if (l1c.y<l2c.y && l1c.x>l2c.x  &&  ((l2c.y-l1c.y) == (l1c.x-l2c.x)) ) return 'SW';
	     	else if(l1c.x<l2c.x && l1c.y==l2c.y) return 'E';
	     	else if (l1c.x>l2c.x && l1c.y==l2c.y) return 'W';
	     	else return 'X';
	}
 function getWordLength(l1c,l2c){
 	var wordlength = 0;
 	if (l1c.x>l2c.x) wordlength = l1c.x - l2c.x;
 	else if(l1c.x<l2c.x) wordlength = l2c.x - l1c.x;
 	else if (l1c.y<l2c.y) wordlength = l2c.y - l1c.y;
 	else if (l1c.y>l2c.y) wordlength = l1c.y - l2c.y;
 	return  ++wordlength;
 }
 function foundallwords(){
 	for(var i=0;i<randomisedArray.length;i++)
 		if(randomisedArray[i]!=null) return false;
 	return true;
 }
 function checkAnswer(wordCoord){
 	for (var i=0;i<wordsCoord.length;i++){
 		var wordCell = wordsCoord[i];
 		if(wordCell.x==wordCoord.x && wordCell.y==wordCoord.y && wordCell.direction==wordCoord.direction && wordCell.length==wordCoord.length){
 			randomisedArray[i]=null;
 			return i;
 		}
 	}
 	return -1;
 }
 function shuffle(o){
 	for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
 		return o;
 }
	//Display background
	displayBG(false);
   	//Randomised array because the number of words entered can be greater than 6
   	randomisedArray = shuffle(gameAssets.hidden_words).slice(0,6);
  	//place all letters on the board
  	placeLetters();

//Make semi-transparent
  	Crafty.c("Letterbox",{
  		_tagx:0,
  		_tagy:0,
  		init: function() {
  			this.addComponent("2D, DOM, Mouse , Text");
  			this.attr({x:0 , y: 0, w: 320, h: 70})
  			.css({'border':'1px dashed white','display':'table','overflow':'hidden','padding':'5px;','text-align':'center','background-color':hex2rgb(gameAssets.banner.bgnd_color),'background':hex2rgb(gameAssets.banner.bgnd_color),'cursor':'pointer'})
  			.textFont({ size: gameAssets.text_size-7+'px',family:gameAssets.text_font})
  			.textColor(gameAssets.text_color)
  			.bind('Click', function() {
  				if(firstLetterSelected){
  					var secondLetterCoord={x:this.tagx,y:this.tagy};
  					var wordSelected={x:firstLetterCoord.x,y:firstLetterCoord.y};
  					wordSelected.length = getWordLength(firstLetterCoord,secondLetterCoord);
  					wordSelected.direction = getWordDirection(firstLetterCoord,secondLetterCoord);
  					//Ignore when the player clicks twice on the same letter
  					if(wordSelected.length>1 && wordSelected.direction!="X"){
  							firstLetterSelected=false;
		  					var idx = checkAnswer(wordSelected);
		  					if(idx>-1){
		  						foundWord = wordSignArr[idx];
		  						addSelectedBar(wordSelected);
		  						setTimeout(function(){
		  							foundWord.css({'opacity':'0.4','text-decoration':'line-through'});
		  							if(foundallwords()){
		  								successful_msg = gameAssets.successful_msg.text;
				                		G_outcome = 'Completed';
		  								Crafty.scene("finalScene");
		  							}
		  						},100);	
		  					}else{
		  						addSelectedBar(wordSelected,0);
		  						setTimeout(function(){addSelectedBar(wordSelected,1);},100);	
		  					}
  					}
  				}
  				else{
  					this.css({'background-color': darkenColor(gameAssets.banner.bgnd_color).toHexString() });
  					firstLetterSelected = true;
  					firstLetterCoord.x = this.tagx;
  					firstLetterCoord.y = this.tagy;
  				}
  			});
			},
			letterbox: function(tagX,tagY){
				this.tagx=tagX;
				this.tagy=tagY;
			}
		});

var wordobj={
	'border-top':'1px dashed white',
	'border-left':'1px dashed white',
	'border-bottom':'1px dashed white',
	'display':'table',
	'text-align':'center',
	'background-color': hex2rgb(gameAssets.banner.bgnd_color),
    'background-image': '-webkit-gradient(linear, left top, left bottom, from('+gameAssets.banner.bgnd_color+'), to('+lightenColor(gameAssets.banner.bgnd_color)+'))',
    'background-image': '-webkit-linear-gradient(top, '+gameAssets.banner.bgnd_color+', '+lightenColor(gameAssets.banner.bgnd_color)+')',
    'background-image': '-moz-linear-gradient(top, '+gameAssets.banner.bgnd_color+', '+lightenColor(gameAssets.banner.bgnd_color)+')',
    'background-image': '-ms-linear-gradient(top, '+gameAssets.banner.bgnd_color+', '+lightenColor(gameAssets.banner.bgnd_color)+')',
    'background-image': '-o-linear-gradient(top, '+gameAssets.banner.bgnd_color+', '+lightenColor(gameAssets.banner.bgnd_color)+')',
    'background-image': 'linear-gradient(to bottom, '+gameAssets.banner.bgnd_color+', '+lightenColor(gameAssets.banner.bgnd_color)+')',
    'filter:progid':'DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#a5b8da, endColorstr=#7089b3)'
}

for (var i=0;i<SIZE_GRID_X;i++){
	var coordRow=[];
	for (var j=0;j<SIZE_GRID_Y;j++){
		var letter = Crafty.e("Letterbox");
		letter.css({'opacity':'0.5'});
		letter.letterbox(j,i);
		letter.text(centerAlignStr(letterCoord[i][j].toUpperCase()));
		//letter.attr({x:42*j+10,y:10+i*42,w:42,h:42});
		letter.attr({x:44*j+1,y:1+i*44,w:44,h:44});
		coordRow[j]=letter;
	}	
	letterBox[i]=coordRow;
}
  	//Component to define the words menu on the right
  	Crafty.c("WordSign", {
  		init: function() {
  			this.addComponent("2D, DOM, Text");
          //display the color of the button
          this.attr({x:0 , y: 5, w: 250, h: 35})
          .textFont({ size: gameAssets.text_size-5+'px',family:gameAssets.text_font})
          .textColor(gameAssets.text_color)
          .css(wordobj)
         }
        });
  	//Place the word on the side of the board
// Bound Round	Landscape devices
		var xOffset=450, yOffset=10;
		setOrientation();
		if(!globalLandscape) xOffset=Math.floor((45*9-250)/2), yOffset=410;
  	
  	for(var i=0;i<randomisedArray.length;i++){
  		var wordSign = Crafty.e("WordSign").attr({x:xOffset, y: yOffset});
  		wordSign.text( centerAlignStr(randomisedArray[i].toUpperCase()));
  		wordSignArr.push(wordSign);
  		yOffset+=50;
  	}
  	

// Bound Round	Landscape devices
  	//Component to define the words menu on the right
  	Crafty.c("Instructions", {
  		init: function() {
  			this.addComponent("2D, DOM, Text");
          //display the color of the button
          this.attr({x:0 , y: 5, w: 250, h: 35})
          .textFont({ size: gameAssets.text_size-5+'px',family:gameAssets.text_font})
          .textColor(gameAssets.text_color)
          .css(wordobj)
         }
        });

		//Place the instructions at the bottom
  	var i = Crafty.e("Instructions")
    .attr({x:450, y: 315, w: 250, h: 75})
    .text(centerAlignStr(howto[gameAssets.language_idx]))
    .css(wordobj)
    .textFont({ size: '20px'})
    .textColor(gameAssets.text_color)

		if(!globalLandscape) i.attr({x:xOffset, y: yOffset+10, w: 250, h: 75});

		resizegates();
});	
