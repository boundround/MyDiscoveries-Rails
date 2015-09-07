/*
br_google_maps_3d
*/

location.hash == '' ? location.hash = '#3/-33.865143/151.2099' : location.hash = location.hash;

function br_parseHash(location_hash) {
	var loc = location_hash.replace('#', '').split('/');
	my_loc = {};
	my_loc.zoom = loc[0];
	my_loc.center = new google.maps.LatLng(loc[1], loc[2]);
	/*			my_loc.center.lat = loc[1];
		my_loc.center.lng = loc[2];*/
	return my_loc;
}
window.parsedHash = br_parseHash(location.hash);
//Set initial values
window.previousZoom = window.parsedHash.zoom;
window.previousLocation = window.parsedHash.center;

var br_transitionzoomlevel = 6; //2d zoom level transition to globe
var br_areazoomin = 10; //Zoom level when user touches an area marker
var areahidelevel = 8; //zoom level at which area icons that have places are replaced with cluster icons
var areatouchmagnification = 3; //number of levels to zoom when touch area with places

var area_markers = null;
var area_markerCluster = null;

function setMarkerVisibility(markers, visib) {
	for (var it in markers) {
		markers[it].setVisible(visib);
	}
}

var place_markers = null;
var place_markerCluster = null;
var showingAreas = true;

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
				$ad = $(this.content).find("div.gm-rev");
				if ($ad.length > 0) {
					$ad.append($("<div style='float:left;  clear:both;'></div>").append(link))
				}
				else {
					$ad = $(this.content).find("div.transit-container");
					$already = $ad.find('#br_request');
					if ($ad.length > 0 && $already.length <= 0) $ad.append($("<div style='float:left;  clear:both;'></div>").append(link))

				}
			}
		}
		set.apply(this, arguments);
	}
}

var br_infoWindow = null;
var br_map = null;

var createMarkerInfoBoxContent = function(marker, markerType) {
	if (markerType === 'place') {
		var category = marker.icon.category;
		var categoryIcon = "<img src='https://d1w99recw67lvf.cloudfront.net/category_icons/" + category + "_icon.png' alt='" + category + " icon'>";
		var imageCountIcon = "<img src='https://d1w99recw67lvf.cloudfront.net/category_icons/photos_count.png' height='14px' alt='photo count'>";
		var gameCountIcon = "<img src='https://d1w99recw67lvf.cloudfront.net/category_icons/games_count.png' height='14px' alt='games count'>";
		var videoCountIcon = "<img src='https://d1w99recw67lvf.cloudfront.net/category_icons/videos_count.png' height='14px' alt='videos count'>";
		var categoryText = category;
		var url = "https://app.boundround.com" + marker.icon.target_url;
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
	}
	else {
		var url = "https://app.boundround.com" + marker.icon.target_url;
		var placeTitle = marker.icon.labelText;

		var content = '<div class="upper-card" style=""><div class="card-category">' +
			'</div></div><a class="no-anchor-decoration" href="' + url +
			'"><p class="place-title area">' + placeTitle + '</p><br></a>';

		var text = content;

		return text;

	}
}

//Generate marker arrays from Bound Round geojson feature set 
var createMarkerArray = function(geoJSON, markerType, showme) {
	var markerArray = [];

	for (var i = 0; i < geoJSON.features.length; i++) {
		var location = geoJSON.features[i];


		var icon = {
			area: function() {
				return {
					labelText: location.properties.title,
					url: 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png',
					labelClassName: 'area-icon-label' + ' ' + location.properties.places + ' ' + location.properties.id,
					target_url: location.properties.url,
					placeCount: location.properties.placeCount,
					country: location.properties.country,
					size: null,
					origin: null,
					anchor: null,
					scaledSize: new google.maps.Size(83 * .45, 53 * .45)
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

			marker.setVisible(showme);

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

					//"Id:" + data[i].Id + "<br /> Property Name/Number:" + data[i].Propertynanu + "<br /> Rooms:" + data[i].Rooms
					if(markerType === 'area' && br_map.getZoom() <= areahidelevel)
					{
						br_map.panTo(marker.getPosition());	
						br_map.setZoom(br_areazoomin);
					}
					else
					{
						br_infoWindow.setContent(createMarkerInfoBoxContent(marker, markerType));
						br_infoWindow.open(br_map, marker);
					}
				});


			})(marker, markerType);


			// Now we have all markers in a single array
			markerArray.push(marker);
		}
	}
	return markerArray;
};


function updateHash(zoom, center) {
	location.hash = '#' + zoom + '/' + center.lat() + '/' + center.lng();
}

function configureMarkers(newZoom) {
	if (newZoom < areahidelevel && !showingAreas) {
		showingAreas = true;
		//				  	setMarkerVisibility(area_markers,true);
		//				  	area_markerCluster.repaint();
		setMarkerVisibility(place_markers, false);
		place_markerCluster.repaint();
	}
	else if (newZoom >= areahidelevel && showingAreas) {
		showingAreas = false;
		//				  	setMarkerVisibility(area_markers,false);
		//				  	area_markerCluster.repaint();
		setMarkerVisibility(place_markers, true);
		place_markerCluster.repaint();
	}
}

function br_initialize() {

	adjustInfoWindow();


	//Sydney
	//        var center = new google.maps.LatLng(-33.8678500, 151.2073200);

	var mapOptions = {
		center: window.previousLocation,
		disableDefaultUI: false,
		zoom: window.previousZoom * 1.0,
		minZoom: 2,
		maxZoom: 20,
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
			/*							{ "featureType": "poi", "stylers": [ { "visibility": "off" } ] },*/
			{}
		]
	};
	console.log(window.previousZoom);
	map = new google.maps.Map(document.getElementById('googleMap'), mapOptions);


	map.addListener('zoom_changed', function() {
		if (map.getZoom() !== undefined) {
			var newZoom = map.getZoom();
			var center = map.getCenter();

			updateHash(newZoom, center);

			console.log("location.hash " + location.hash)
			window.parsedHash = br_parseHash(location.hash);
			console.log(window.parsedHash.zoom);

			configureMarkers(newZoom);
			
						//Are we zooming up to the globe?
			if (newZoom <= br_transitionzoomlevel) {
				$('#cesiumContainer').show();// css('visibility', 'visible');
//				$('#cesiumContainer').fadeIn("fast");
				$('#googleMap').hide();//css('visibility', 'hidden');
//				$('#googleMap').css('zIndex', -1);
				//				    var ll = window.previousLocation ? window.previousLocation : map.getCenter();
				// resetHomeScreen();
				if (typeof viewer != 'undefined') {
					var pc = Cesium.Cartographic.fromDegrees(center.lng(), center.lat(), BR_MIN_ZOOM + 2000000.);
					//							var pc = Cesium.Cartographic.fromDegrees(0, 0, BR_MIN_ZOOM+2000000.);
//					setTimeout(
						viewer.scene.camera.setView({
						positionCartographic: pc,
						heading: Cesium.Math.toRadians(0.0), // east, default value is 0.0 (north)
						pitch: Cesium.Math.toRadians(-90), // default value (looking down)
						roll: 0.0 // default value
					});
//					, 0);

				}

				/*				  if (window.previousZoom >= areahidelevel && newZoom < areahidelevel) {
								    placeMarkers.removeLayers(placesArray);
								    areaMarkers.addLayers(window.areaLayers.havePlaces);
								    showAreaCards();
								  }
									else if (window.previousZoom < areahidelevel && newZoom >= areahidelevel){
								    areaMarkers.removeLayers(window.areaLayers.havePlaces);
								    placeMarkers.addLayers(placesArray);
								    showAreaCards();
								    showPlaceCards();
								    postSearchCSS();
								  }
				*/
			}


		}
	});




	br_infoWindow = new google.maps.InfoWindow();
	br_map = map;

    $.getJSON("Source/countries30_na.topojson", function(data){
        geoJsonObject = topojson.feature(data, data.objects.countries_no_antarctica);
        map.data.addGeoJson(geoJsonObject); 
        // Set the stroke width, and fill color for each polygon
        var featureStyle = {
            fillColor: 'transparent',
            strokeWeight: 0
        }
        map.data.setStyle(featureStyle);

        // zoom to the clicked feature
        map.data.addListener('click', function (e) {
/*            document.getElementById('info-box').innerHTML = 
            "iso_a2 = "+ e.feature.getProperty('iso_a2') + "<BR>"
            + "name = "+ e.feature.getProperty('brk_name') + "<BR>"
            + "name = "+ e.feature.getProperty('brk_name') + "<BR>"
            + "population = "+ e.feature.getProperty('pop_est') + "<BR>"
            + "economy = "+ e.feature.getProperty('economy') + "<BR>"
            + "continent = "+ e.feature.getProperty('continent') + "<BR>"
            ;
*/
			var bounds = new google.maps.LatLngBounds();
            processPoints(e.feature.getGeometry(), bounds.extend, bounds);
            map.fitBounds(bounds);
            window.open("https://app.boundround.com/countries/"+e.feature.getProperty('iso_a2').toLowerCase()+".html");
        });
        
    });


	$.ajax({
		//Get all areas and add to map
		url: 'areas.json',
		success: function(data) {
			window.areasGeoJSON = data;

			area_markers = createMarkerArray(data, 'area', true);
			//	       	var area_markerCluster = new MarkerClusterer(map, area_markers); 

			area_markerCluster = new MarkerClusterer(map, area_markers, {
				maxZoom: areahidelevel - 1,
				ignoreHidden: true,
				gridSize: 10,
				styles: [{
					url: 'cluster28.png',
					height: 28,
					width: 28,
					anchor: [0, 0],
					textColor: '#ffffff',
					textSize: 10
				}]
			});


			//		    addMarkersClickEvent(areaMarkers);

			//Now get all places and add to map
			$.ajax({
				url: 'places.json',
				success: function(data) {
					window.placesGeoJSON = data;

					place_markers = createMarkerArray(data, 'place', false);
					place_markerCluster = new MarkerClusterer(map, place_markers, {
						maxZoom: 12,
						ignoreHidden: true,
						gridSize: 10,
						styles: [{
							url: 'cluster28yellow.png',
							height: 28,
							width: 28,
							anchor: [0, 0],
							textColor: '#000000',
							textSize: 10
						}]
					});

					//		        addMarkersClickEvent(placeMarkers);

					//		        areasPlacesSwitch();
					configureMarkers(map.getZoom());
				}
			});

		}
	});
}


$(document).ready(function() {
  br_initialize();
  $('#googleMap').hide();//css('visibility', 'hidden');
  $('#cesiumContainer').show();//css('visibility', 'hidden');
});
