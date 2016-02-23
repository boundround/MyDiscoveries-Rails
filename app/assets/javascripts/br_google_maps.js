/*
br_google_maps
*/

//Flags for c9.io to eliminate warnings on global variables not defined in the file
/*global google*/
/*global topojson*/
/*global MarkerClusterer*/

var br_dom_map_element = 'br15_map';

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

//	var br_url_prefix = "https://app.boundround.com";
var br_google_url_prefix = ""; //"https://peaceful-bastion-2430.herokuapp.com";
var br_show_map_mode = false;

var brShowMapMode = null;

/* Disable URL Hash
function brUpdateHash(zoom, center) {
	if (br_show_map_mode)
		location.hash = '#' + zoom + '/' + center.lat() + '/' + center.lng() + '/map';
	else
		location.hash = '#' + zoom + '/' + center.lat() + '/' + center.lng();
}

function brParseHash() {
	if (location.hash) {
		var loc = location.hash.replace('#', '').split('/');
		var my_loc = {};
		my_loc.zoom = loc[0] * 1.;
		my_loc.center = new google.maps.LatLng(loc[1], loc[2]);
			// my_loc.center.lat = loc[1];
			// my_loc.center.lng = loc[2];
		if (loc.length >= 4) my_loc.mode = loc[3];
		return my_loc;
	} else {
		return null;
	}
}

location.hash == '' ? location.hash = '#2/-31.722765997478323/142.06927500000006' : location.hash = location.hash;
var parsedHash = brParseHash();
if (parsedHash && parsedHash.mode) br_show_map_mode = true;
*/


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



var br_place_markers = [];
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
						content: location.properties.placeCount > 0 ? "" + location.properties.placeCount : "",
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

//Generate marker arrays from Bound Round geojson feature set
/* example JSON object
[Log] s (localhost, line 882)
	_state: r {index: "place", query: "sydney", facets: [], disjunctiveFacets: [], hierarchicalFacets: [], …}
	disjunctiveFacets: [] (0)
	facets: [] (0)
	hierarchicalFacets: [] (0)
	hits: Array (6)
		0Object
		_highlightResult: Object
			description: {value: "Visit <em>Sydney</em> and be&nbsp;amazed by the unique blend...", matchLevel: "full", matchedWords: ["sydney"]}
			display_name: {value: "<em>Sydney</em>", matchLevel: "full", matchedWords: ["sydney"]}
		Object Prototype
			category: "area"
			country: "Australia"
			description: "Visit Sydney and be&nbsp;amazed by the unique blend..."
			display_name: "Sydney"
			latitude: -33.8674869
			locality: "Sydney"
			longitude: 151.2069902
			name: "Sydney, Sydney, Australia"
			objectID: "place_1064"
			photos: Array (42)
				0{url: "https://d1w99recw67lvf.cloudfront.net/photos/small_Sydney_hero.jpg", alt_tag: "The Coat Hanger, Sydney Harbour Bridge"}
				1{url: "https://d1w99recw67lvf.cloudfront.net/photos/small_small_SYD_DQP_4.jpg", alt_tag: "Kid whizzing through the air on the flying fox at the Darling Quarter Playground"}
			Array Prototype
			post_code: ""
			url: "/places/sydney"
		Object Prototype
		1{display_name: "Sydney Tower Eye & SKYWALK", latitude: -33.8703858, longitude: 151.2090761, locality: "Sydney", post_code: "2000", …}
		2{display_name: "Sydney Swans", latitude: -33.891645, longitude: 151.224771, locality: "Moore Park", post_code: "2021", …}
		3{display_name: "Sydney Opera House", latitude: -33.8571965, longitude: 151.2151398, locality: "Sydney", post_code: "2000", …}
		4{display_name: "Sydney Olympic Stadium", latitude: -33.8493172, longitude: 151.0621102, locality: "Sydney Olympic Park", post_code: "2127", …}
		5{display_name: "Sydney Fish Markets", latitude: -33.8730082, longitude: 151.192578, locality: "Pyrmont", post_code: "2009", …}
	Array Prototype
	hitsPerPage: 6
	index: "place"
	nbHits: 44
	nbPages: 8
	page: 0
	processingTimeMS: 1
	query: "sydney"
s Prototype
*/

var clearAlgoliaMarkers = function() {
	for (i = 0; i < br_place_markers.length; i++) {
		br_place_markers[i].setMap(null);
	}
}

var updateMapWithHoverResults = function(lat, lng){
    var myCenter = new google.maps.LatLng(lat, lng);

    function initialize() {
        var mapProp = {
            center: myCenter,
            zoom: 15,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };

        var map = new google.maps.Map(document.getElementById("br15_map"), mapProp);

        var marker = new google.maps.Marker({
            position: myCenter,
            animation: google.maps.Animation.BOUNCE
        });

        marker.setMap(map);
    }

    initialize();
}

var updateMapWithAlgoliaSearchResults = function(content) {
	// size of icon on the map
	var scaleRatio = 1.0;
	var originalWidthOfIcon = window.thirdFloor.iconBuilder.CANVAS_DEFAULT_WIDTH;
	var originalHeightOfIcon = window.thirdFloor.iconBuilder.CANVAS_DEFAULT_HEIGHT;
	var scaledWidthOfIcon = originalWidthOfIcon * scaleRatio;
	var scaledHeightOfIcon = originalHeightOfIcon * scaleRatio;

	var anchorOfIcon = new google.maps.Point(scaledWidthOfIcon * 0.5, scaledHeightOfIcon + 0);
	var scaledSizeOfIcon = new google.maps.Size(scaledWidthOfIcon, scaledHeightOfIcon);

	clearAlgoliaMarkers();
	/*	br_place_markers = [];*/
	br_place_markers = createMarkerArrayFromAlgolia(content, "", true, scaledSizeOfIcon, anchorOfIcon);

	var bounds = new google.maps.LatLngBounds();
	for (i = 0; i < br_place_markers.length; i++) {
		bounds.extend(br_place_markers[i].getPosition());
		// console.log(br_place_markers[i].getPosition());
	}

	// make animate/move map
	br_map.fitBounds(bounds);

	/*	Probably not necessary
				br_place_markerCluster ? br_place_markerCluster.clearMarkers();

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
				setTimeout(function(){window.br_place_markerCluster.repaint();},3000);
*/

}

var createMarkerArrayFromAlgolia = function(alJSON, markerType, showme, scaledSizeOfIcon, anchorOfIcon) {
	var markerArray = [];

	//Check interface
	alJSON.hits = ('hits' in alJSON) ? alJSON.hits : [];

	for (var i = 0; i < alJSON.hits.length; i++) {
		var location = alJSON.hits[i];
		if (location.objectID.indexOf("place") != -1) {
			//Check interface, fix if missing
			location.place_count = ('place_count' in location) ? location.place_count : 0;
			location.display_name = ('display_name' in location) ? location.display_name : "";
			location.latitude = ('latitude' in location) ? location.latitude : 0.0;
			location.longitude = ('longitude' in location) ? location.longitude : 0.0;
			location.category = ('category' in location) ? location.category : "";
			location.id = ('objectID' in location) ? location.objectID : "";
			location.url = ('url' in location) ? location.url : "";
			location.country = ('country' in location) ? location.country : "";
			location.image_count = ('photos' in location) ? location.photos.length : 0;
			location.video_count = ('videos' in location) ? location.videos.length : 0;
			location.game_count = ('games' in location) ? location.games.length : 0;
			location.hero_image = ('hero_image' in location) ? location.hero_image : (location.image_count > 0) ? location.photos[0].url : "";

			markerType = (location.category == 'area') ? 'area' : 'place';

			var icon = {
				area: function() {

					// config for icon
					var iconCfg = {
						innerText: {
							content: location.place_count > 0 ? "" + location.place_count : "",
							style: {
								fontFamily: 'Signika'
							}
						},
						outerText: {
							content: location.display_name,
							arc: 320,
							style: {
								fontFamily: 'Signika'
							}
						}
					};


					return {
						labelText: location.display_name,
						//					url: 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png',
						labelClassName: 'area-icon-label' + ' ' + location.place_count + ' ' + location.id,
						target_url: location.url,
						placeCount: location.place_count,
						country: location.country,
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
						labelClassName: 'place-icon-label ' + location.id,
						url: 'https://d1w99recw67lvf.cloudfront.net/category_icons/' + location.category + '_pin.png',
						target_url: location.url,
						imageCount: location.image_count,
						videoCount: location.video_count,
						gameCount: location.game_count,
						heroImage: location.hero_image,
						placeId: location.id,
						area: "",
						title: location.display_name,
						size: null,
						origin: null,
						anchor: null,
						category: location.category,
						scaledSize: new google.maps.Size(25, 38)
					}
				}
			}

			// Only create marker if it has lat and long
			if (location.latitude && location.longitude) {

				var myLatLng = {
					lat: location.latitude,
					lng: location.longitude
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
						if (markerType == 'area' && br_map.getZoom() <= br_area_hide_level) {
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
	}

	return markerArray;
};

//Change the Hash based on user navigation of page & map

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
	var init_zoom = 2;
	var init_center = new google.maps.LatLng(-31.722765997478323, 142.06927500000006);

/* Disable HASH URL
	var init_loc = brParseHash();

	if (init_loc) {
		init_zoom = init_loc.zoom;
		init_center = init_loc.center;
	}
*/

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
		backgroundColor: '#a6c6ff',
	  zoomControl: true,
	  mapTypeControl: true,
	  scaleControl: false,
	  streetViewControl: false,
	  rotateControl: false,
    mapTypeControlOptions: {
        style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
        position: google.maps.ControlPosition.RIGHT_BOTTOM
    },
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

	$.ajax({
				url: '/places/mapdata.json',
				success: function(data) {
					window.placesGeoJSON = data;

					br_place_markers = createMarkerArray(data, 'place', true);
					br_place_markerCluster = new MarkerClusterer(br_map, br_place_markers, {
						maxZoom: 10,
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
	/* Won't need this with new search
	br_map.addListener("dragend", function() {
		brUpdateMap(false);
	});
	br_map.addListener('zoom_changed', function() {
		brUpdateMapAndConfigureMarkers(false);
	});
*/

	//

/* Disable URL Hash
	function brUpdateMap(fromHash) {
		if (fromHash) {
			var page_loc = brParseHash();
			if (page_loc) {
				br_map.setZoom(page_loc.zoom);
				br_map.setCenter(page_loc.center);
			}
		} else if (br_map.getZoom() !== undefined) {
			brUpdateHash(br_map.getZoom(), br_map.getCenter());
		}
	};

	brShowMapMode = function(mm) {
		br_show_map_mode = mm;
		brUpdateMap(false);
	}

	function brUpdateMapAndConfigureMarkers(fromHash) {
		brUpdateMap(fromHash);
		configureMarkers(br_map.getZoom());
	};

	brUpdateMap(true);
*/

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

	// $(window).on('hashchange', function() {
	// 	brUpdateMapAndConfigureMarkers(true);
	// });

	/* This is very slow
	$.ajax({
		//Get all areas and add to map
		url: '/places/placeareasmapdata.json',
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



			// br_area_markerCluster = new MarkerClusterer(br_map, br_area_markers, {
			// 	maxZoom: 14,
			// 	ignoreHidden: false,
			// 	gridSize: 10,
			// 	styles: [{
			// 		url: '../google_home/cluster28.png',
			// 		height: 28,
			// 		width: 28,
			// 		anchor: [0, 0],
			// 		textColor: '#ffffff',
			// 		textSize: 10
			// 	}]
			// });
			//

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
*/

	$.getJSON("../google_home/js/countries30_na.topojson", function(data) {
		//var geoJsonObject = topojson.feature(data, data.objects.countries_no_antarctica);
		//br_map.data.addGeoJson(geoJsonObject);
		// Set the stroke width, and fill color for each polygon
		var featureStyle = {
			fillColor: 'transparent',
			strokeWeight: 0
		}
		br_map.data.setStyle(featureStyle);

		// zoom to the clicked feature
		br_map.data.addListener('click', function(e) {
			if (br_map.getZoom() <= br_countrieslevel) {
				br_infobox_content_type = 'country';

				br_country_marker.setMap(br_map);
				br_country_marker.setPosition(e.latLng);

				var bounds = new google.maps.LatLngBounds();
				processPoints(e.feature.getGeometry(), bounds.extend, bounds);
				br_map.fitBounds(bounds);
				//				brUpdateMap();

				// <script>
				// 	//Trick to get the correct asset path for flags, used in br_google_maps.js
				// 	window.br_auf = '<%= asset_path('flags/au.png') %>';
				// </script>
				//!!br_auf uses above erb assignment trick in containing html.erb file!!
				var pf = br_auf.replace('au', e.feature.getProperty('iso_a2').toLowerCase());

				var content = '<div class="upper-card" style="background-position:center center;background-size:contain;background-repeat:no-repeat;background-image: url(' + pf + ')"></div>' +
					'<div class="lower-card" style="position:relative;top:-29px;height:20px;width:100px;background:white;"><a class="no-anchor-decoration" href="' + br_google_url_prefix + "/countries/" + e.feature.getProperty('iso_a2').toLowerCase() + ".html" +
					'"><p class="place-title area">' + e.feature.getProperty('brk_name') + '</p><br></a></div>';

				br_infoWindow.setContent(content);
				br_infoWindow.setOptions(brInfoWindowOptions('country'));

				br_infoWindow.open(br_map, br_country_marker);

				//window.location.href = br_google_url_prefix+"/countries/"+e.feature.getProperty('iso_a2').toLowerCase()+".html";
			}
		});
	});
}

google.maps.event.addDomListener(window, 'DOMContentLoaded', initialize);

// first we need preload the webfonts which we will use in icons
window.WebFont.load({
	google: {
		families: [
			'Signika:600'
		]
	},
	active: function() {

		//Wait for the DOM tree to be ready
//		google.maps.event.addDomListener(window, 'DOMContentLoaded', initialize);

		//Wait for entire page to load (longer)
		//google.maps.event.addDomListener(window, 'load', initialize);

		//    start();
	}
});
