//List all languages
//English, French, Spanish, German, Russian, Arabic, Hebrew, Catalan

var clickArr = ['Click Here','Cliquez Ici','Haga Clic Aquí','Klicken Sie hier','Нажмите здесь','انقر هنا','לחץ כאן','Fes clic aquí','Πάτησε εδώ','Cliceáil Anseo','Clique aqui'];
var thksArr = ['Thank you!','Merci!','¡Gracias','Danke!','спасибо!','!شكرا','תודה לך!','Gràcies!','Ευχαριστώ!','Go raibh maith agat!',"Obrigado!"];
var loadingArr = ['Loading...','Chargement...','Cargando...','Laden...','загрузка...','...تحميل','טעינה','Carregant...','Φόρτωση…','Lódáil...','Carregando...'];
var emailVArr = ['This email address is not valid','Cette adresse email n\'est pas valide','Esta Dirección de Correo Electrónico no es válida','Diese E-Mail-Adresse ist nicht gültig.','Этот адрес электронной почты является недопустимым','عنوان البريد الإلكتروني هذا غير صالح','כתובת דוא"ל זו אינה חוקית','Aquesta adreça de correu electrònic no és vàlida','Αυτή η διεύθυνση ηλεκτρονικού ταχυδρομείου δεν είναι έγκυρη','Níl an seoladh r-phost seo bailí','Este e-mail não é válido'];
var alphaArr = ["ABCDEFGHIJKLMNOPQRSTUVWXYZ","ABCDEFGHIJKLMNOPQRSTUVWXYZ","ABCDEFGHIJKLMNOPQRSTUVWXYZ","ABCDEFGHIJKLMNOPQRSTUVWXYZ","АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ","غظضذخثتشرقصفعسنملكيطحزوهدجبا","אבגדהוזחטיכלמנסעפצקרשת","ABCÇDEFGHIJKLMNOPQRSTUVWXYZ",'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ','ABCDEFGHIJKLMNOPQRSTUVWXYZ','ABCDEFGHIJKLMNOPQRSTUVWXYZ'];
var buttonObj
var gameHasBeenWon=true;
var globalScale = 1;

//Use a standard size for landscape & protrait, controls laid out in these dimensions
//We'll css scale to fit the screen Bound Round
var sceneSize = { portrait: {w:400,h:900}, landscape: {w:700,h:400}};
globalLandscape = true;
globalWidth = 700;

var answersArr = [];
//var answersArr = {};
var resultMark;
var successful_msg;
var lead_id="";
var unsuccessful_msg;
var G_outcome="Not Completed";
var G_score=0;

function centerAlignStr(str){
	return '<div style="display:table-cell;vertical-align: middle; padding:0 10px">'+str+'</div>'
}

//***********************************************************
//         Get a color and darken to show on selected button
//***********************************************************
function darkenColor(col) {
  	return tinycolor(col).darken();
}
function lightenColor(col) {
    return tinycolor(col).lighten(25);
}

function postLead(data){
  var XHR = new XMLHttpRequest();
  XHR.open("POST", gameAssets.urlpost);
  XHR.setRequestHeader("Content-type","application/x-www-form-urlencoded");
  XHR.send(data);
}
//***********************************************************
//         Send Lead to server
//***********************************************************
function sendLead(form) {
		  //console.log(form.id);
          var urlEncodedDataPairs=[];
          //console.log(allfields);
          for(key in form) 
            urlEncodedDataPairs.push(encodeURIComponent(key) + '=' + encodeURIComponent(form[key]));
          var urlEncodedData = urlEncodedDataPairs.join('&').replace(/%20/g, '+');
          //console.log(urlEncodedData);
          postLead(urlEncodedData);
          
          //Redirect to link or result page
          //console.log(gameHasBeenWon)
          if (gameHasBeenWon && gameAssets.redirect_on_successful)
          	 window.open(gameAssets.successful_link);
          else if (gameHasBeenWon && gameAssets.retry_btn_successful)
            Crafty.scene("homeScene");
          else if (!gameHasBeenWon && gameAssets.redirect_on_unsuccessful)
          	 window.open(gameAssets.unsuccessful_link);
          else if (!gameHasBeenWon && gameAssets.retry_btn_unsuccessful)
            Crafty.scene("homeScene");
}

//***********************************************************
//         return the obj for button
//***********************************************************
function cssbutton(color){
  
  return{'text-shadow': '-1px -1px 0 rgba(0,0,0,0.3)',
         'display':'table','border': '1px solid #fff',
         'cursor':'pointer', 'border-radius':'5px',
          'text-align':'center',
          'background-color': color, 
          'background-image': '-webkit-gradient(linear, left top, left bottom, from('+color+'), to('+lightenColor(color)+'))',
          'background-image': '-webkit-linear-gradient(top, '+color+', '+lightenColor(color)+')',
          'background-image': '-moz-linear-gradient(top, '+color+', '+lightenColor(color)+')',
          'background-image': '-ms-linear-gradient(top, '+color+', '+lightenColor(color)+')',
          'background-image': '-o-linear-gradient(top, '+color+', '+lightenColor(color)+')',
          'background-image': 'linear-gradient(to bottom, '+color+', '+lightenColor(color)+')',
          'filter:progid':'DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#a5b8da, endColorstr=#7089b3)'
        }
}
function cssbuttonhover(color){
  
  return{'text-shadow': '-1px -1px 0 rgba(0,0,0,0.3)',
         'display':'table','border': '1px solid #fff',
         'cursor':'pointer', 'border-radius':'5px',
          'text-align':'center',
          'background-color': color, 
          'background-image': '-webkit-gradient(linear, left top, left bottom, from('+lightenColor(color)+'), to('+color+'))',
          'background-image': '-webkit-linear-gradient(top, '+lightenColor(color)+', '+color+')',
          'background-image': '-moz-linear-gradient(top, '+lightenColor(color)+', '+color+')',
          'background-image': '-ms-linear-gradient(top, '+lightenColor(color)+', '+color+')',
          'background-image': '-o-linear-gradient(top, '+lightenColor(color)+', '+color+')',
          'background-image': 'linear-gradient(to bottom, '+lightenColor(color)+', '+color+')',
          'filter:progid':'DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr=#a5b8da, endColorstr=#7089b3)'
        }
}
//***********************************************************
//         calculate hex to rgba 
//***********************************************************
function hex2rgb(hex,opa) {
	if (hex[0]=="#") hex=hex.substr(1);
	var rgbarr = hex.match(/.{1,2}/g),
	opacity=1.0;
	if(opa!=undefined) opacity=opa;
	return 'rgba('+parseInt(rgbarr[0],16)+','+parseInt(rgbarr[1],16)+','+parseInt(rgbarr[2],16)+','+opacity+')'
}

//***********************************************************
//         Display 
//***********************************************************
function displayResultIcon(corAns){
	resultMark.visible=true;
	if(corAns){
		resultMark.text('✔');
		resultMark.textColor('#00a000');
	}else{
		resultMark.text('✗');
		resultMark.textColor('#c73417');
	}
}

//***********************************************************
//         Validate email
//***********************************************************
function validateEmail(email) { 
	var re = /\S+@\S+\.\S+/;
	return re.test(email);
} 


//***********************************************************
//                Create final Scene
//***********************************************************
Crafty.scene("finalScene", function () {
    var capture_leads = gameAssets.capture_leads_unsuccessful;
    var capture_email = capture_leads && gameAssets.collect_email_unsuccessful;
    var capture_address = capture_leads && gameAssets.collect_address_unsuccessful;
    var capture_phone = capture_leads && gameAssets.collect_phone_unsuccessful;
    var capture_name = capture_leads && gameAssets.collect_name_unsuccessful;
    var msg = gameAssets.unsuccessful_msg;
    var retry = gameAssets.retry_btn_unsuccessful;
    var redirect = gameAssets.redirect_on_unsuccessful;
    var link = gameAssets.unsuccessful_btn.link;
    if(gameHasBeenWon){
      msg = gameAssets.successful_msg;
      capture_leads = gameAssets.capture_leads_successful;
      capture_email = capture_leads && gameAssets.collect_email_successful;
      capture_address = capture_leads && gameAssets.collect_address_successful;
      capture_phone = capture_leads && gameAssets.collect_phone_successful;
      capture_name = capture_leads && gameAssets.collect_name_successful;
      retry = gameAssets.retry_btn_successful;
      redirect = gameAssets.redirect_on_successful;
      link = gameAssets.successful_btn.link;
    }
    var cssObj = {'display':'table','background-color':hex2rgb(msg.bgnd_color,msg.opacity),'text-align':'center','border-radius': '5px','padding-top':'10px','border':'1px solid white','text-shadow': '-1px -1px 0 rgba(0,0,0,0.3)'};
    if(gameAssets.language_idx==5 || gameAssets.language_idx==6){
		cssObj['direction']='rtl';
		cssObj['text-align']='right';
    }

    //Display Message
	  var endmsg = Crafty.e("2D, DOM, Text")
	  .textFont({ size: msg.text_size+'px',family: gameAssets.text_font})
	  .textColor(gameAssets.text_color)
	  .text(centerAlignStr(msg.text))
	  .css(cssObj)
	  .attr({x:msg.left, y:msg.top, w: msg.width, h:msg.height});
    
    //Display the warning message
    var warnmsg = Crafty.e("2D, DOM, Text")
    .textFont({size:14,family: gameAssets.text_font})
    .textColor("#ffffff")
    .css({'display':'table','text-align':'center','background-color':'red'})
    .text(centerAlignStr('At least one field is missing'))
    .attr({x:50, y:140, w: 595, h:30})

    warnmsg.visible=false;

	  if(capture_leads){
     endmsg.text(msg.text);
	  }else{
	   endmsg.text(centerAlignStr(msg.text));
	  }

    Crafty.c("txtInput",{
  		init: function() {
  		  this.addComponent("2D, DOM, HTML");  
  		  this.bind("Click",function(){
            	document.getElementById(name).value="";
        }); 
      },
			setOrientation:function(){},
      setname:function(name){
				this.replace('<input value="'+name+'" id="'+name+'" style="background-color:#FFFFFF;font-size:20px;width:250px;padding:10px 20px;">')
				document.getElementById(name).addEventListener("click", function(){
						var el = document.getElementById(name);
						if(el.value==name) el.value="";
					});
				document.getElementById(name).addEventListener("blur", function(){
					var el = document.getElementById(name);
					if(el.value=="") el.value=name;
				});
      }
    });
		
    if(capture_email){
    	var email = Crafty.e("txtInput");
			email.setname("email");
			email.setOrientation = function() {
				if(globalLandscape)
					email.attr({x:50 , y: 175, w:250})
				else
					email.attr({x:40 , y: 175, w:360});
			}
			email.setOrientation();			
    }
    if(capture_name){
	    var name  = Crafty.e("txtInput")
	    name.setname("name")
			name.setOrientation = function() {
				if(globalLandscape)
					name.attr({x:350 , y: 175, w:250})
				else
					name.attr({x:40 , y: 235, w:360});
			}
			name.setOrientation();			
	  }
	  if(capture_phone){
    	var phone = Crafty.e("txtInput")
    	phone.setname("phone")
			phone.setOrientation = function() {
				if(globalLandscape)
					phone.attr({x:50 , y: 230, w:250})
				else
					phone.attr({x:40 , y: 295, w:360});
			}
			phone.setOrientation();			
   	}
   	if(capture_address){
    	var address = Crafty.e("txtInput")
    	address.setname("address")
			address.setOrientation = function() {
				if(globalLandscape)
					address.attr({x:350 , y: 230, w:250})
				else
					address.attr({x:40 , y: 255, w:360});
			}
			address.setOrientation();			
    }
		
		Crafty.c("endbtn",{
  		init: function() {
  		  this.addComponent("2D, DOM, Text, Mouse");
  		  this.css(cssbutton(gameAssets.successful_send_btn.bgnd_color))
		  this.textFont({ size: gameAssets.successful_send_btn.text_size+'px',family: gameAssets.text_font})
		  this.textColor(gameAssets.text_color)
		  this.attr({x:gameAssets.successful_send_btn.left, y:gameAssets.successful_send_btn.top, w: gameAssets.successful_send_btn.width, h: gameAssets.successful_send_btn.height})
      this.bind('MouseOver',function(){
       this.css(cssbuttonhover(gameAssets.successful_send_btn.bgnd_color));
      })
      this .bind('MouseOut',function(){
        this.css(cssbutton(gameAssets.successful_send_btn.bgnd_color));
      });
      }
	});
    if(capture_leads){
    	Crafty.e("endbtn")
      .text(centerAlignStr("Send"))
      .bind("Click",function(){
          var allfields={};
          if(capture_email){
            var email = document.getElementById('email').value;
            if(email!="" && email!="email") allfields.email = email;
            else {warnmsg.visible=true; return}
          }
          if(capture_name){
            var name = document.getElementById('name').value;
            if(name!="" && name!="name") allfields.name = name;
            else {warnmsg.visible=true; return}
          }
          if(capture_address){
            var address = document.getElementById('address').value;
            if(address!="" && address!="address") allfields.address = address;
            else {warnmsg.visible=true; return}
          }
          if(capture_phone){
            var phone = document.getElementById('phone').value;
            if(phone!="" && phone!="phone") allfields.phone = phone;
            else {warnmsg.visible=true; return}
          }
          sendLead(allfields) 
          Crafty("txtInput").destroy();
          Crafty("endbtn").destroy();
          warnmsg.destroy();
          endmsg.text('Thank you!')
          //console.log(allfields);
      });
    }else{
    	if(redirect)
    		Crafty.e("endbtn")
    		.text(centerAlignStr("Click Here"))
    		.bind("Click",function(){
					window.history.back();
//    			window.open(link);
    		});
    	else if(retry)
    		Crafty.e("endbtn")
    	    .text(centerAlignStr("Retry"))
    	    .bind("Click",function(){
    			Crafty.scene("homeScene");
    		});
    }

		resizegates();
});

//***********************************************************
//                Create homepage over scene Facebook
//***********************************************************	
Crafty.scene("homeScene", function () {

	//------------------Display the BG------------------//
	displayBG();
	//------------------Display the instructions------------------//
	var cssObj = {'display':'table','border-bottom':'1px solid white','background-color':hex2rgb(gameAssets.game_instructions.bgnd_color,gameAssets.game_instructions.opacity),'text-align':'center','text-shadow': '-1px -1px 0 rgba(0,0,0,0.3)'};
	if(gameAssets.language_idx==5 || gameAssets.language_idx==6){
		cssObj['direction']='rtl';
		cssObj['text-align']='right';
	}
	var ce = Crafty.e("2D, DOM, Text")
	.textFont({ size: gameAssets.game_instructions.text_size+'px',family: gameAssets.text_font})
	.textColor(gameAssets.text_color)
	.text(centerAlignStr(gameAssets.game_instructions.text))
	.css(cssObj);

/*	if(!globalLandscape)
		ce.attr({x:0, y:0, w: 360, h: 300})
	else*/
		ce.attr({x:gameAssets.game_instructions.left, y:gameAssets.game_instructions.top, w: gameAssets.game_instructions.width, h: gameAssets.game_instructions.height});

	//------------------Display the start button------------------//
	var ce = Crafty.e("2D, DOM, Text, Mouse")
	.text(centerAlignStr(gameAssets.start_btn.text))
	.css(cssbutton(gameAssets.start_btn.bgnd_color))
	.textFont({ size: gameAssets.start_btn.text_size+'px',family: gameAssets.text_font})
	.textColor(gameAssets.text_color)
	.bind('Click',function(){
				Crafty.scene("gameScene");
		//Crafty.scene("finalScene");
	})
  .bind('MouseOver',function(){
    this.css(cssbuttonhover(gameAssets.start_btn.bgnd_color));
  })
  .bind('MouseOut',function(){
    this.css(cssbutton(gameAssets.start_btn.bgnd_color));
    //Crafty.scene("finalScene");
  });

	if(!globalLandscape)
		ce.attr({x:20, y:gameAssets.start_btn.top, w: 360, h: 100})
	else
		ce.attr({x:gameAssets.start_btn.left, y:gameAssets.start_btn.top, w: gameAssets.start_btn.width, h: gameAssets.start_btn.height});

//  window.addEventListener("resize", resizegates, false);
//  window.addEventListener("orientationchange", resizegates, false);

	resizegates();
});


//***********************************************************
//                Display Background for all Games
//***********************************************************

function displayBG(){
	//Display the background image
	if(gameAssets.bgnd_img!="" && gameAssets.bgnd_img!=undefined){
//		 Crafty.background("url('"+gameAssets.bgnd_img+"') no-repeat cover");
		 Crafty.background("url('"+gameAssets.bgnd_img+"') repeat");
//		 Crafty.stage.elem.style.backgroundSize = "contain";
	}
	else{
		if (gameAssets.bgnd_color!=undefined && gameAssets.bgnd_color!="") Crafty.background(gameAssets.bgnd_color);
		else Crafty.background("#2d3d4b");
	}

	//Display the result mark if
	resultMark = Crafty.e("2D, DOM, Text, Mouse")
		.attr({x: Crafty.viewport.width/2-50, y: Crafty.viewport.height*0.45, w: 100, h: 150,z:10})
		.textFont({ size: '150px'})
		.css({'font-family':'Lato'});
	resultMark.visible=false; 
}
//***********************************************************
//                Create Loading scene
//***********************************************************
//the loading screen that will display while our assets load
Crafty.scene("loadingScene", function () {

	Crafty.background("#ffffff");
	var progressBar = Crafty.e("2D, DOM, Color")
	.attr({x: 0, y: Crafty.viewport.height-10, w: 10, h: 10})
	.color("#883b90");

	if(gameAssets.bgnd_image!=undefined && gameAssets.bgnd_image!=""){
		Crafty.load({"images": [gameAssets.bgnd_image]},
			function() {
				Crafty.scene("homeScene");
			},
			function(e) {
				progressBar.attr({w:e.percent/100*Crafty.viewport.width});
			},
			function(e) {
				console.log('there was an error');
			}
			);
	}else{
		progressBar.attr({w:400});
		Crafty.scene("homeScene");
	}
});

function fbextend() {
    var options, name, src, copy, copyIsArray, clone, target = arguments[0] || {},
        i = 1,
        length = arguments.length,
        deep = false,
        toString = Object.prototype.toString,
        hasOwn = Object.prototype.hasOwnProperty,
        push = Array.prototype.push,
        slice = Array.prototype.slice,
        trim = String.prototype.trim,
        indexOf = Array.prototype.indexOf,
        class2type = {
          "[object Boolean]": "boolean",
          "[object Number]": "number",
          "[object String]": "string",
          "[object Function]": "function",
          "[object Array]": "array",
          "[object Date]": "date",
          "[object RegExp]": "regexp",
          "[object Object]": "object"
        },
        jQuery = {
          isFunction: function (obj) {
            return jQuery.type(obj) === "function"
          },
          isArray: Array.isArray ||
          function (obj) {
            return jQuery.type(obj) === "array"
          },
          isWindow: function (obj) {
            return obj != null && obj == obj.window
          },
          isNumeric: function (obj) {
            return !isNaN(parseFloat(obj)) && isFinite(obj)
          },
          type: function (obj) {
            return obj == null ? String(obj) : class2type[toString.call(obj)] || "object"
          },
          isPlainObject: function (obj) {
            if (!obj || jQuery.type(obj) !== "object" || obj.nodeType) {
              return false
            }
            try {
              if (obj.constructor && !hasOwn.call(obj, "constructor") && !hasOwn.call(obj.constructor.prototype, "isPrototypeOf")) {
                return false
              }
            } catch (e) {
              return false
            }
            var key;
            for (key in obj) {}
            return key === undefined || hasOwn.call(obj, key)
          }
        };
      if (typeof target === "boolean") {
        deep = target;
        target = arguments[1] || {};
        i = 2;
      }
      if (typeof target !== "object" && !jQuery.isFunction(target)) {
        target = {}
      }
      if (length === i) {
        target = this;
        --i;
      }
      for (i; i < length; i++) {
        if ((options = arguments[i]) != null) {
          for (name in options) {
            src = target[name];
            copy = options[name];
            if (target === copy) {
              continue
            }
            if (deep && copy && (jQuery.isPlainObject(copy) || (copyIsArray = jQuery.isArray(copy)))) {
              if (copyIsArray) {
                copyIsArray = false;
                clone = src && jQuery.isArray(src) ? src : []
              } else {
                clone = src && jQuery.isPlainObject(src) ? src : {};
              }
              // WARNING: RECURSION
              target[name] = fbextend(deep, clone, copy);
            } else if (copy !== undefined) {
              target[name] = copy;
            }
          }
        }
      }
      return target;
    }
		
		function setOrientation() {
			
			if(window.innerWidth>=window.innerHeight)
			{
				globalWidth = sceneSize.landscape.w;
				globalLandscape = true;
			} 
			else	
			{
				globalWidth = sceneSize.portrait.w;
				globalLandscape = false;
			} 	
		}

		function resizegates(){

			setOrientation();

			//Bound Round
			//  globalScale = window.innerWidth / 700;
			globalScale = window.innerWidth/globalWidth;

			xOffset=Math.floor((45*9-250)/2), yOffset=sceneSize.landscape.h+10;
	
			if(globalLandscape && Crafty.viewport.width < sceneSize.landscape.w)
			{
				Crafty.viewport.width = globalWidth;
				Crafty.viewport.height = sceneSize.landscape.h;
			}
			else if(!globalLandscape && Crafty.viewport.width > sceneSize.portrait.w)
			{
				Crafty.viewport.width = globalWidth;
				Crafty.viewport.height = sceneSize.portrait.h;
			}	

			//For game scene
			Crafty("WordSign, Instructions").each(function() {
					if(globalLandscape && this.x < sceneSize.portrait.w)
					{
						this.x = 450;
						this.y = this.y - sceneSize.landscape.h;
//						this.tween({x: 450, y: (this.y - sceneSize.landscape.h)},1000);
					}
					else if(!globalLandscape && this.x > sceneSize.portrait.w)
					{
						this.x = xOffset;
						this.y = this.y + sceneSize.landscape.h;			
//						this.tween({x: xOffset, y: (this.y + sceneSize.landscape.h)},1000);
					}	
			});
			
			Crafty("txtInput").each(function() {
				this.setOrientation && this.setOrientation();
			});
			
		  //make sure it's not bigger than the height
		//  if (globalScale  > 1)globalScale = 1; 
		  var stageStyle = Crafty.stage.elem.style;
		  stageStyle.transformOrigin = stageStyle.webkitTransformOrigin = stageStyle.mozTransformOrigin = "0 0";
		  stageStyle.transform = stageStyle.webkitTransform = stageStyle.mozTransform = "scale("+globalScale+")";
		  //console.log(globalScale);
		  Crafty.viewport.reload();
		};
		
		window.addEventListener("resize", resizegates, false);
		window.addEventListener("orientationchange", resizegates, false);


		var fyrebox = function(){	
			setOrientation();
			if(globalLandscape)
				Crafty.init(sceneSize.landscape.w,sceneSize.landscape.h)
			else
				Crafty.init(sceneSize.portrait.w,sceneSize.portrait.h);
			
		//	setOrientation();
//		  Crafty.scene("loadingScene");
		  Crafty.scene("gameScene");
		}