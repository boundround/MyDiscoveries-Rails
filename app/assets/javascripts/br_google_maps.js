/*
br_google_maps
*/

//Flags for c9.io to eliminate warnings on global variables not defined in the file
/*global google*/
/*global topojson*/
/*global MarkerClusterer*/

var br_dom_map_element = 'home-map';

var br_map = null;
var br_infoWindow = null;
var br_country_marker = null;

function brInfoWindowOptions(markerType) {
	if (markerType === 'place') return {
		pixelOffset: new google.maps.Size(0, 100)
	};
	if (markerType === 'area') return {
		pixelOffset: new google.maps.Size(0, 0)
	};
	if (markerType === 'country') return {
		pixelOffset: new google.maps.Size(0, 50)
	};
}

var br_infobox_place_options = null;
var br_infobox_area_options = null;
var br_infobox_country_options = null;


var br_infobox_content_type = null;

location.hash == '' ? location.hash = '#4/-31.722765997478323/142.06927500000006' : location.hash = location.hash;

//	var br_url_prefix = "https://app.boundround.com";
var br_google_url_prefix = ""; //"https://peaceful-bastion-2430.herokuapp.com";
var br_show_map_mode = false;

var brShowMapMode = null;

function brParseHash() {
	if(location.hash)
	{
		var loc = location.hash.replace('#', '').split('/');
		var my_loc = {};
		my_loc.zoom = loc[0]*1.;
		my_loc.center = new google.maps.LatLng(loc[1], loc[2]);
		/*			my_loc.center.lat = loc[1];
			my_loc.center.lng = loc[2];*/
		if (loc.length >= 4) my_loc.mode = loc[3];
		return my_loc;
	}
	else
	{
		return null;
	}
}

var parsedHash = brParseHash();
if (parsedHash && parsedHash.mode) br_show_map_mode = true;

var br_countrieslevel = 6; //Level after which country clicks no longer
var transitionzoomlevel = 6; //2d zoom level transition to globe
var br_areazoomin = 10; //Zoom level when user touches an area marker
var br_area_hide_level = 8; //zoom level at which area icons that have places are replaced with cluster icons

var br_area_markers = null;
var br_area_markerCluster = null;

function setMarkerVisibility(markers, visib) {
	for (var it in markers) {
		markers[it].setVisible(visib);
	}
}



var br_place_markers = null;
var br_place_markerCluster = null;
var br_showing_places = false;

function adjustInfoWindow() {
	//If this is a typical POI infoWindow from Google, offer the user a request to add to bound round 
	//We assume it's a typical POI infoWindow if the DOM tree for the InfoWindow doesn't include .card-category
	var set = google.maps.InfoWindow.prototype.set;
	google.maps.InfoWindow.prototype.set = function(key, val) {
		var self = this;
		if (key === "map") {
			if ($(this.content).children('.card-category').length <= 0) {
				var link = $("<br><a id='br_request' href='#'>Request for Bound Round</a><br>");
				link.click(function() {
					console.log("link clicked", self, self.getContent(), self.content);
				});
				var $ad = $(this.content).find("div.gm-rev");
				if ($ad.length > 0) {
					$ad.append($("<div style='float:left;  clear:both;'></div>").append(link))
				} else {
					$ad = $(this.content).find("div.transit-container");
					var $already = $ad.find('#br_request');
					if ($ad.length > 0 && $already.length <= 0) $ad.append($("<div style='float:left;  clear:both;'></div>").append(link))

				}
			}
		}
		set.apply(this, arguments);
	}
}

var createMarkerInfoBoxContent = function(marker, markerType) {
	if (markerType === 'place') {
		br_infobox_content_type = 'place';
		var category = marker.icon.category;
		var categoryIcon = "<img src='https://d1w99recw67lvf.cloudfront.net/category_icons/" + category + "_icon.png' alt='" + category + " icon'>";
		var imageCountIcon = "<img src='https://d1w99recw67lvf.cloudfront.net/category_icons/photos_count.png' height='14px' alt='photo count'>";
		var gameCountIcon = "<img src='https://d1w99recw67lvf.cloudfront.net/category_icons/games_count.png' height='14px' alt='games count'>";
		var videoCountIcon = "<img src='https://d1w99recw67lvf.cloudfront.net/category_icons/videos_count.png' height='14px' alt='videos count'>";
		var categoryText = category;
		var url = br_google_url_prefix + marker.icon.target_url;
		var heroImage = marker.icon.heroImage;
		var imageCount = marker.icon.imageCount;
		var videoCount = marker.icon.videoCount;
		var gameCount = marker.icon.gameCount;
		var placeTitle = marker.icon.title;
		var placeId = marker.icon.placeId;

		var content = '<div class="upper-card" style="background-image: url(' + heroImage + ')"><div class="card-category">' +
			categoryIcon + categoryText + '</div></div><a class="no-anchor-decoration" href="' + url +
			'"><p class="place-title ' + category + '">' + placeTitle + '</p><br></a>';

		var text = '<div class="place-card" id="' + placeId + '">' + content + '<div class="card-footer"><div class="image-count">' +
			imageCountIcon + '&nbsp;&nbsp;' + imageCount + '</div><div class="video-count">' +
			videoCountIcon + '&nbsp;&nbsp;' + videoCount + '</div><div class="game-count">' +
			gameCountIcon + '&nbsp;&nbsp;' + gameCount + '</div></div></div>';

		return text;
	} else {
		br_infobox_content_type = 'area';
		var url = br_google_url_prefix + marker.icon.target_url;
		var placeTitle = marker.icon.labelText;

		var content = '<div class="upper-card" style="height:40px;width:100px;background:white"><a class="no-anchor-decoration" href="' + url +
			'"><p class="place-title">' + placeTitle + '</p><br></a></div>';


		//		var content = '<div class="upper-card"></div><a class="no-anchor-decoration" href="' + url +
		//			'"><p class="place-title">' + placeTitle + '</p><br></a>';

		var text = '<div class="place-card">' + content + '</div>';

		var text = content;

		return text;

	}
}

	function brBlankIcon() {
		return {
			labelText: '',
			url: '',
			labelClassName: '',
			target_url: '',
			placeCount: '',
			country: '',
			size: null,
			origin: null,
			anchor: null,
			scaledSize: new google.maps.Size(83 * .45, 53 * .45)
		}
	}


	//Generate marker arrays from Bound Round geojson feature set 
var createMarkerArray = function(geoJSON, markerType, showme, scaledSizeOfIcon, anchorOfIcon) {
	var markerArray = [];

	for (var i = 0; i < geoJSON.features.length; i++) {
		var location = geoJSON.features[i];


		var icon = {
			area: function() {
				
        // config for icon
        var iconCfg = {
          innerText: {
            content: ""+location.properties.placeCount,
            style: {
              fontFamily: 'Signika'
            }
          },
          outerText: {
            content: location.properties.title,
            arc: 320,
            style: {
              fontFamily: 'Signika'
            }
          }
        };
  
				
				return {
					labelText: location.properties.title,
//					url: 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png',
					labelClassName: 'area-icon-label' + ' ' + location.properties.places + ' ' + location.properties.id,
					target_url: location.properties.url,
					placeCount: location.properties.placeCount,
					country: location.properties.country,
					size: null,
					origin: null,
          url: window.thirdFloor.iconBuilder.build(iconCfg),
          scaledSize: scaledSizeOfIcon,
          anchor: anchorOfIcon
//					anchor: null,
//					scaledSize: new google.maps.Size(83 * .45, 53 * .45)
				}
			},
			place: function() {
				return { // labelText: location.properties.title,
					labelClassName: 'place-icon-label ' + location.properties.id,
					url: location.properties.icon.iconUrl,
					target_url: location.properties.url,
					imageCount: location.properties.imageCount,
					videoCount: location.properties.videoCount,
					gameCount: location.properties.gameCount,
					heroImage: location.properties.heroImage,
					placeId: location.properties.placeId,
					area: location.properties.area,
					title: location.properties.title,
					size: null,
					origin: null,
					anchor: null,
					category: location.properties.category,
					scaledSize: new google.maps.Size(25, 38)
				}
			}
		}

		// Only create marker if it has lat and long
		if (location.geometry.coordinates[1] && location.geometry.coordinates[0]) {

			var myLatLng = {
				lat: location.geometry.coordinates[1],
				lng: location.geometry.coordinates[0]
			};

			var marker = new google.maps.Marker({
				position: myLatLng,
				icon: icon[markerType](),
				map: br_map
			});

//			marker.setVisible(showme);

			/*				google.maps.event.addListener(marker, 'mouseover', function() {
					  this.setAnimation(google.maps.Animation.BOUNCE);
					});
					
					google.maps.event.addListener(marker, 'mouseout', function() {
					  this.setAnimation(null);
					});
			*/

			(function(marker, markerType) {

				// Attaching a click event to the current marker
				google.maps.event.addListener(marker, "click", function(e) {

					br_map.panTo(marker.getPosition());
					//"Id:" + data[i].Id + "<br /> Property Name/Number:" + data[i].Propertynanu + "<br /> Rooms:" + data[i].Rooms
					if (markerType === 'area' && br_map.getZoom() <= br_area_hide_level) {
						//						br_map.panTo(marker.getPosition());	
						br_map.setZoom(br_areazoomin);
					}
					br_infoWindow.setContent(createMarkerInfoBoxContent(marker, markerType));
					br_infoWindow.setOptions(brInfoWindowOptions(markerType));
					br_infoWindow.open(br_map, marker);
				});


			})(marker, markerType);


			// Now we have all markers in a single array
			markerArray.push(marker);
		}
	}
	return markerArray;
};

//Change the Hash based on user navigation of page & map
function brUpdateHash(zoom, center) {

	if (br_show_map_mode)
		location.hash = '#' + zoom + '/' + center.lat() + '/' + center.lng() + '/map';
	else
		location.hash = '#' + zoom + '/' + center.lat() + '/' + center.lng();
}

function configureMarkers(newZoom) {

	br_area_markerCluster && br_area_markerCluster.repaint();
	br_place_markerCluster && br_place_markerCluster.repaint();

/*
		if (newZoom < br_area_hide_level && br_showing_places) {
		br_showing_places = false;
		//				  	setMarkerVisibility(area_markers,true);
		//				  	area_markerCluster.repaint();
		//		br_area_markers && setMarkerVisibility(br_area_markers,true);
		br_place_markers && setMarkerVisibility(br_place_markers, false);
		br_area_markerCluster && br_area_markerCluster.repaint();
		br_place_markerCluster && br_place_markerCluster.repaint();
	} else if (newZoom >= br_area_hide_level && !br_showing_places) {
		br_showing_places = true;
		//				  	setMarkerVisibility(area_markers,false);
		//				  	area_markerCluster.repaint();
		//		br_area_markers && setMarkerVisibility(br_area_markers, true);
		br_place_markers && setMarkerVisibility(br_place_markers, true);
		//		br_area_markerCluster && br_area_markerCluster.repaint();
		br_place_markerCluster && br_place_markerCluster.repaint();
	}
	*/
}

function initialize() {

	//Make it so the default google location window includes "Request for Bound Round"
	adjustInfoWindow();

	//Center of Australia
	var init_zoom = 4;
	var init_center = new google.maps.LatLng(-31.722765997478323, 142.06927500000006);
	
	var init_loc = brParseHash();
	
	if( init_loc )
	{
		init_zoom = init_loc.zoom;
		init_center = init_loc.center;
	}

	//Sydney
	//        var center = new google.maps.LatLng(-33.8678500, 151.2073200);
	var mapOptions = {
		//		#4/-31.722765997478323/142.06927500000006
		center: init_center,
		zoom: init_zoom,
		disableDoubleClickZoom: true, // <---
		disableDefaultUI: false,
		minZoom: 2,
		maxZoom: 16,
    backgroundColor: '#a6c6ff'
		
/*
		mapTypeId: google.maps.MapTypeId.ROADMAP,
		styles: [{
				"featureType": "water",
				"stylers": [{
					"color": "#73C7D1"
				}]
			}, {
				"featureType": "landscape",
				"stylers": [{
					"color": "#F1EEE7"
				}]
			}, {
				featureType: "administrative",
				elementType: "labels",
				stylers: [{
					visibility: "on"
				}]
			}, {
				featureType: "road",
				elementType: "labels",
				stylers: [{
					visibility: "off"
				}]
			},
			//							{ "featureType": "poi", "stylers": [ { "visibility": "off" } ] },
			{}
		]
		*/
	};
	br_map = new google.maps.Map(document.getElementById(br_dom_map_element), mapOptions);
	br_map.addListener("dragend", function(){ brUpdateMap(false);} );
	br_map.addListener('zoom_changed', function() {brUpdateMapAndConfigureMarkers(false);} );


	//
	function brUpdateMap(fromHash) {
		if (fromHash) {
			var page_loc = brParseHash();
			if( page_loc )
			{
				br_map.setZoom(page_loc.zoom);
				br_map.setCenter(page_loc.center);
			}
		} else if (br_map.getZoom() !== undefined) {
			brUpdateHash(br_map.getZoom(), br_map.getCenter());			
		}
	};

	brShowMapMode = function(mm)
	{
		br_show_map_mode = mm;
		brUpdateMap(false);
	}

	function brUpdateMapAndConfigureMarkers(fromHash) {
		brUpdateMap(fromHash);
		configureMarkers(br_map.getZoom());
	};
	
	brUpdateMap(true);

	br_infoWindow = new google.maps.InfoWindow(brInfoWindowOptions('place'));

	br_infoWindow.addListener('closeclick', function() {
		br_country_marker.setMap(null); //removes the marker
		//		br_country_marker = null;
	});
	/*
	 * The google.maps.event.addListener() event waits for
	 * the creation of the infowindow HTML structure 'domready'
	 * and before the opening of the infowindow defined styles
	 * are applied.
	 */
	br_infoWindow.addListener('domready', function() {
		// Reference to the DIV which receives the contents of the infowindow using jQuery
		var iwOuter = $('.gm-style-iw');

		/* The DIV we want to change is above the .gm-style-iw DIV.
		 * So, we use jQuery and create a iwBackground variable,
		 * and took advantage of the existing reference to .gm-style-iw for the previous DIV with .prev().
		 */
		var iwBackground = iwOuter.prev();
		iwBackground.css({
			'display': 'none'
		});

		/*
	   // Remove the background shadow DIV
	   iwBackground.children(':nth-child(2)').css({'display' : 'none'});

	   // Remove the white background DIV
	   iwBackground.children(':nth-child(4)').css({'display' : 'none'});
*/
		// Taking advantage of the already established reference to
		// div .gm-style-iw with iwOuter variable.
		// You must set a new variable iwCloseBtn.
		// Using the .next() method of JQuery you reference the following div to .gm-style-iw.
		// Is this div that groups the close button elements.
		var iwCloseBtn = iwOuter.next();

		// Apply the desired effect to the close button
		iwCloseBtn.css({
			opacity: '1', // by default the close button has an opacity of 0.7
			right: '38px',
			top: '10px' // button repositioning
		});

		// The API automatically applies 0.7 opacity to the button after the mouseout event.
		// This function reverses this event to the desired value.
		iwCloseBtn.mouseout(function() {
			$(this).css({
				opacity: '1'
			});

		});
	});

	br_country_marker = new google.maps.Marker({
		position: br_map.getCenter(),
		map: br_map,
		icon: brBlankIcon(),
	});

	function processPoints(geometry, callback, thisArg) {
		if (geometry instanceof google.maps.LatLng) {
			callback.call(thisArg, geometry);
		} else if (geometry instanceof google.maps.Data.Point) {
			callback.call(thisArg, geometry.get());
		} else {
			geometry.getArray().forEach(function(g) {
				processPoints(g, callback, thisArg);
			});
		}
	}

	$(window).on('hashchange',function(){ 
		brUpdateMapAndConfigureMarkers(true);
	});
	
	$.getJSON("../google_home/js/countries30_na.topojson", function(data) {
		var geoJsonObject = topojson.feature(data, data.objects.countries_no_antarctica);
		br_map.data.addGeoJson(geoJsonObject);
		// Set the stroke width, and fill color for each polygon
		var featureStyle = {
			fillColor: 'transparent',
			strokeWeight: 0
		}
		br_map.data.setStyle(featureStyle);

		// zoom to the clicked feature
		br_map.data.addListener('click', function(e) {

			/*
		content = 
            "iso_a2 = "+ e.feature.getProperty('iso_a2') + "<BR>"
            + "name = "+ e.feature.getProperty('brk_name') + "<BR>"
            + "name = "+ e.feature.getProperty('brk_name') + "<BR>"
            + "population = "+ e.feature.getProperty('pop_est') + "<BR>"
            + "economy = "+ e.feature.getProperty('economy') + "<BR>"
            + "continent = "+ e.feature.getProperty('continent') + "<BR>"
            ;
*/

			if (br_map.getZoom() <= br_countrieslevel) {
				br_infobox_content_type = 'country';

				br_country_marker.setMap(br_map);
				br_country_marker.setPosition(e.latLng);

				var bounds = new google.maps.LatLngBounds();
				processPoints(e.feature.getGeometry(), bounds.extend, bounds);
				br_map.fitBounds(bounds);
				//				brUpdateMap();

				var pf = br_auf.replace('au.png', e.feature.getProperty('iso_a2').toLowerCase() + '.png');

				var content = '<div class="upper-card" style="background-image: url(' + pf + ')"></div>' +
					'<div class="lower-card" style="height:20px;width:100px;background:white;"><a class="no-anchor-decoration" href="' + br_google_url_prefix + "/countries/" + e.feature.getProperty('iso_a2').toLowerCase() + ".html" +
					'"><p class="place-title area">' + e.feature.getProperty('brk_name') + '</p><br></a></div>';

				br_infoWindow.setContent(content);
				br_infoWindow.setOptions(brInfoWindowOptions('country'));

				br_infoWindow.open(br_map, br_country_marker);

				//window.location.href = br_google_url_prefix+"/countries/"+e.feature.getProperty('iso_a2').toLowerCase()+".html";
			}
		});

	});


	$.ajax({
		//Get all areas and add to map
		url: '/areas/mapdata.json',
		success: function(data) {
			window.areasGeoJSON = data;

	    var latLng;
	    var icon;
	    var iconCfg;
	    var marker;

	    // size of icon on the map
	    var scaleRatio = 1.0;
	    var originalWidthOfIcon = window.thirdFloor.iconBuilder.CANVAS_DEFAULT_WIDTH;
	    var originalHeightOfIcon = window.thirdFloor.iconBuilder.CANVAS_DEFAULT_HEIGHT;
	    var scaledWidthOfIcon = originalWidthOfIcon * scaleRatio;
	    var scaledHeightOfIcon = originalHeightOfIcon * scaleRatio;

	    var anchorOfIcon = new google.maps.Point(scaledWidthOfIcon * 0.5, scaledHeightOfIcon + 0);
	    var scaledSizeOfIcon = new google.maps.Size(scaledWidthOfIcon, scaledHeightOfIcon);

			br_area_markers = createMarkerArray(data, 'area', true, scaledSizeOfIcon, anchorOfIcon);
			//	       	var area_markerCluster = new MarkerClusterer(map, area_markers); 


	    // config for icon
	    var emptyIconCfg = {
	      innerCircle: {
	        backgroundColor: '#a6c6ff'
	      },
	      innerText: {
	        content: "",
	            style: {
	              fontFamily: 'Signika'
	            }
	      },
	      outerText: {
	        content: "Group",
	        arc: 320,
	            style: {
	              fontFamily: 'Signika'
	            }
	      }
	    };
    
	    var br_area_markers;
	    var br_area_markerCluster;

			var empty_marker = window.thirdFloor.iconBuilder.build(emptyIconCfg);

			br_area_markerCluster = new MarkerClusterer(br_map, br_area_markers, {
				maxZoom: 14,
				ignoreHidden: false,
				gridSize: 30,
				  styles: [{
						url: empty_marker,
						height: window.thirdFloor.iconBuilder.CANVAS_DEFAULT_HEIGHT,
						width: window.thirdFloor.iconBuilder.CANVAS_DEFAULT_WIDTH,
						anchor: [0, 0],
						textColor: '#ffffff',
						textSize: 20
					}]
			});
			
			
			/*
			br_area_markerCluster = new MarkerClusterer(br_map, br_area_markers, {
				maxZoom: 14,
				ignoreHidden: false,
				gridSize: 10,
				styles: [{
					url: '../google_home/cluster28.png',
					height: 28,
					width: 28,
					anchor: [0, 0],
					textColor: '#ffffff',
					textSize: 10
				}]
			});
			*/
			
			setTimeout(function(){br_area_markerCluster.repaint()},3000);

			//Now get all places and add to map
			$.ajax({
				url: '/places/mapdata.json',
				success: function(data) {
					window.placesGeoJSON = data;

					br_place_markers = createMarkerArray(data, 'place', true);
					br_place_markerCluster = new MarkerClusterer(br_map, br_place_markers, {
						maxZoom: 14,
						ignoreHidden: false,
						gridSize: 10,
						styles: [{
							url: '../google_home/cluster28yellow.png',
							height: 28,
							width: 28,
							anchor: [0, 0],
							textColor: '#000000',
							textSize: 10
						}]
					});
					setTimeout(function(){br_place_markerCluster.repaint();},3000);

					//Kludge to get the markers to show on initial high zoom
					//					setTimeout(function(){brUpdateMap(true);},1000);
//					configureMarkers(br_map.getZoom());
				}
			});

		}
	});
}


/* EXPERIMENTAL CODE, MIGHT WANT TO TRY MARKER FUSION TABLE LAYERS LATER, VERY FAST

    var ftlayer = new google.maps.FusionTablesLayer({
    query: {
      select: 'geometry',
      from: '1hFMStXgF-FO1dJRzPOyKZuugnKBQDyMOa9oB8_Z8'
    },
        styles: [{
          polygonOptions: {
            fillColor: '#00FF00',
            fillOpacity: 0.3
          }
        }
        ]
    });
    ftlayer.setMap(map);
    
    clayer = new google.maps.FusionTablesLayer({
        query: {
          select: 'location',
          from: '1CLE_PJq43PagTM7fA-DhTqE3BHQL-GUd1cXkz-hc',
          where: "'Status' = 'live'"
        },
        styles: [
//                {where: "'bizCatSub' = 'Antique & Classic Motorcycle Dealers'", markerOptions:{ iconName:"star"}}, // other landmarks
          {where: "'bizCatSub' = 'Other moto business'", markerOptions:{ iconName:"wht_pushpin"}}, //businesses
          {where: "'bizCatSub' = 'Shop'", markerOptions:{iconName:"red_blank"}}, //town houses
          {where: "'bizCatSub' = '12'", markerOptions:{ iconName:"orange_blank"}}, //country homes
          {where: "'bizCatSub' = '15'", markerOptions:{ iconName:"target"}},
        ]

      });
      clayer.setMap(map);
*/

// first we need preload the webfonts which we will use in icons
window.WebFont.load({
  google: {
    families: [
      'Signika:600'
    ]
  },
  active: function() {
    // start everything when all fonts loaded
		google.maps.event.addDomListener(window, 'load', initialize);

//    start();
  }
});
