$(document).ready(function() {
	br_disableAllInput();  //Defined in Cesium code app.js
	/*		    $('#map-wrapper').click(function(){$('#map-wrapper').addClass('enabled').removeClass('blur'); br_enableAllInput(); });*/
	$('.overlay').click(function() {
		$('#map-wrapper').addClass('enabled').removeClass('blur');
		br_enableAllInput(); //Defined in Cesium code app.js
	});
	/*		    $('.overlay').click(function(){$('#map-wrapper').addClass('enabled') });*/
	var mapOptions = {
		center: {
			lat: 0,
			lng: 0
		},
		disableDefaultUI: false,
		zoom: 2,
		minZoom: 2,
		maxZoom: 15,
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
			"featureType": "poi",
			"stylers": [{
				"visibility": "off"
			}]
		}, {}]
	};
	map = new google.maps.Map(document.getElementById('googleMap'), mapOptions);

	map.addListener('zoom_changed', function() {
		if (map.getZoom() !== undefined) {
			var newZoom = map.getZoom();

			console.log("this mapzoom: " + newZoom)
			window.parsedHash = br_parseHash(location.hash);
			console.log(window.parsedHash.zoom);

			//Are we zooming up to the globe?
			if (newZoom <= transitionzoomlevel) {
				$('#cesiumContainer').css('visibility', 'visible');
				$('#cesiumContainer').fadeIn("fast");
				$('#googleMap').css('zIndex', -1);
				//				    var ll = window.previousLocation ? window.previousLocation : map.getCenter();
				var ll = map.getCenter();
				// resetHomeScreen();
				if (typeof viewer != 'undefined') {
					var pc = Cesium.Cartographic.fromDegrees(ll.lng(), ll.lat(), BR_MIN_ZOOM + 2000000.);
					//							var pc = Cesium.Cartographic.fromDegrees(0, 0, BR_MIN_ZOOM+2000000.);
					setTimeout(viewer.scene.camera.setView({
						positionCartographic: pc,
						heading: Cesium.Math.toRadians(0.0), // east, default value is 0.0 (north)
						pitch: Cesium.Math.toRadians(-90), // default value (looking down)
						roll: 0.0 // default value
					}), 0);

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


	//Create marker cluster for places
	var mcOptions = {
		gridSize: 50,
		maxZoom: 15
	};
	window.placeMarkers = new MarkerClusterer(map, [], mcOptions);
	//		placeMarkers.addTo(map);


	//Mouse over and mouseout events
	placeMarkers.on('mouseover', function(e) {
		var cardId = $('#' + e.layer.options.icon.options.placeId);
		var backgroundColor = hoverBackground[e.layer.options.category];
		cardId.css('background-color', backgroundColor);
		cardId.find('.card-footer').css('background-color', cardId.find('.place-title').css('color'));
		cardId.find('.card-footer').css('color', 'white');
		e.layer.openPopup();
		console.log(e.layer.options.icon.options);
	});

	if (window.innerWidth > 1000) {
		placeMarkers.on('mouseout', function(e) {
			var cardId = $('#' + e.layer.options.icon.options.placeId);
			cardId.css('background-color', 'white');
			cardId.find('.card-footer').css('background-color', '#f7f7f7');
			cardId.find('.card-footer').css('color', '#aaaaaa');
			e.layer.closePopup();
		});
	}

	//Create marker cluster for areas
	window.areaMarkers = new L.MarkerClusterGroup({
		showCoverageOnHover: false,
		maxClusterRadius: 20
	});
	areaMarkers.addTo(map);

	window.placeLayers = {
		all: [],
		beach: [],
		park: [],
		animals: [],
		sport: [],
		museum: [],
		activity: [],
		theme_park: [],
		sights: [],
		place_to_eat: [],
		place_to_stay: [],
		shopping: [],
	};

	window.areaLayers = {
		havePlaces: [],
		noPlaces: []
	}

	var image = {
		url: place.icon,
		size: new google.maps.Size(71, 71),
		origin: new google.maps.Point(0, 0),
		anchor: new google.maps.Point(17, 34),
		scaledSize: new google.maps.Size(25, 25)
	};

	//Create the map icon class templates for areas and places 
	var areaIcon = {
		url: 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png',
		size: new google.maps.Size(43, 26),
		origin: new google.maps.Point(0, 0),
		anchor: new google.maps.Point(0, 0),
		scaledSize: new google.maps.Size(25, 25)
	};

	var placeIcon = {
		url: 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png',
		size: new google.maps.Size(25, 38),
		origin: new google.maps.Point(0, 0),
		anchor: new google.maps.Point(0, 0),
		scaledSize: new google.maps.Size(25, 25)
	};

	//Generate marker arrays from Bound Round geojson feature set 
	var createMarkerArray = function(geoJSON, markerType) {
		var markerArray = []; 

		for (var i = 0; i < geoJSON.features.length; i++) {
			var location = geoJSON.features[i];

			var icon = {
				area: function() {
					return new areaIcon({
						labelText: location.properties.title,
						labelClassName: 'area-icon-label' + ' ' + location.properties.places + ' ' + location.properties.id,
						url: location.properties.url,
						placeCount: location.properties.placeCount,
						country: location.properties.country
					});
				},
				place: function() {
					return new placeIcon({ // labelText: location.properties.title,
						labelClassName: 'place-icon-label ' + location.properties.id,
						iconUrl: location.properties.icon.iconUrl,
						url: location.properties.url,
						imageCount: location.properties.imageCount,
						videoCount: location.properties.videoCount,
						gameCount: location.properties.gameCount,
						heroImage: location.properties.heroImage,
						placeId: location.properties.placeId,
						area: location.properties.area,
						title: location.properties.title
					});
				}
			}

			// Only create marker if it has lat and long
			/* Google Way		    
					    function addMarker(feature) {
						  var marker = new google.maps.Marker({
						    position: feature.position,
						    icon: icons[feature.type].icon,
						    map: map
						  });
						};
			*/
			if (location.geometry.coordinates[1] && location.geometry.coordinates[0]) {
				var marker = L.marker(new L.LatLng(location.geometry.coordinates[1], location.geometry.coordinates[0]), {
					icon: areaIcon,
					riseOnHover: true,
					riseOffset: 500,
					category: location.properties.category
				})

				// Now we have all markers in a single array
				markerArray.push(marker);

				//Fill the place layers array based on the category type
				if (markerType == 'place') {
					if (placeLayers[location.properties.category]) {
						window.placeLayers[location.properties.category].push(marker);
					}
				}

				//Fill the area array based on whether the area has places or not
				if (markerType == 'area') {
					location.properties.places ? window.areaLayers.havePlaces.push(marker) : window.areaLayers.noPlaces.push(marker);
				}
			};
		};

		//This is dodgy
		if (markerType == 'place') {
			window.placeLayers.all = markerArray;
		}
		return markerArray;
	};

	$.ajax({
		//Get all areas and add to map
		url: '/areas/mapdata.json',
		success: function(data) {
			window.areasGeoJSON = data;
			var areasArray = createMarkerArray(data, 'area');

			areaMarkers.addLayers(window.areaLayers.havePlaces);
			areaMarkers.addLayers(window.areaLayers.noPlaces);

			addMarkersClickEvent(areaMarkers);

			//Now get all places and add to map
			$.ajax({
				url: '/places/mapdata.json',
				success: function(data) {
					window.placesGeoJSON = data;
					window.placesArray = createMarkerArray(data, 'place');
					addMarkersClickEvent(placeMarkers);

					areasPlacesSwitch();

					//        location.hash == "#3/-33.87/102.48" ? location.hash = '#3/-33.865143/151.2099' : location.hash;
					//        brglobe.setLocation(-33.865, 151.209);
				}
			});

		}
	});

	var showAreaCards = function() {
		var bounds = map.getBounds();
		var text = '';
		var areas = [];

		//Get areas that fit within the map bounds
		areaMarkers.eachLayer(function(marker) {
			if (bounds.contains(marker.getLatLng())) {
				areas.push(marker.options.icon.options);
			}
		});
		//Get areas that have places that fit within the map bounds
		placeMarkers.eachLayer(function(marker) {
			if (bounds.contains(marker.getLatLng())) {
				areas.push(marker.options.icon.options.area)
			}
		});
		//Then you have to remove duplicates
		areas = removeDuplicateAreaObjects(areas);

		//Now add area cards to DOM
		for (var i = 0; i < areas.length; i++) {
			var url = areas[i].url;
			var areaTitle = '';
			if (areas[i].hasOwnProperty('labelText')) {
				areaTitle += areas[i].labelText;
			}
			else {
				areaTitle += areas[i].title
			}
			if (areas[i].country != areaTitle) {
				areaTitle += ', ' + areas[i].country;
			}
			if (areas[i].placeCount > 0) {
				var placeCountText = areas[i].placeCount + ' places';
			}
			else {
				var placeCountText = '&nbsp;';
			}

			var pin = '<div class="area-card-pin"><img src="https://d1w99recw67lvf.cloudfront.net/category_icons/place-pin.png" class="area-pin" alt="map pin"></div>';

			text += '<div class="area-card">' + pin + '<a class="no-anchor-decoration" href="' + url + '"><div class="area-title">' + areaTitle +
				'</a><br><span class="place-count">' + placeCountText + '</span></div></div>';
		}
		$('#areas').html(text);
	}

	var showPlaceCards = function() {
		var inBoundsMarkers = [];
		var bounds = map.getBounds();
		var text = "";
		placeMarkers.eachLayer(function(marker) {
			if (bounds.contains(marker.getLatLng())) {

				eachPlaceMarker[marker.options.icon.options.placeId] = marker;

				inBoundsMarkers.push(marker.options.icon.options.placeId);
				var category = marker.options.category;
				var categoryIcon = "<img src='https://d1w99recw67lvf.cloudfront.net/category_icons/" + marker.options.category + "_icon.png' alt='" + marker.options.category + " icon'>";
				var imageCountIcon = "<img src='https://d1w99recw67lvf.cloudfront.net/category_icons/photos_count.png' height='14px' alt='photo count'>";
				var gameCountIcon = "<img src='https://d1w99recw67lvf.cloudfront.net/category_icons/games_count.png' height='14px' alt='games count'>";
				var videoCountIcon = "<img src='https://d1w99recw67lvf.cloudfront.net/category_icons/videos_count.png' height='14px' alt='videos count'>";
				var categoryText = formatCategory(category);
				var url = marker.options.icon.options.url;
				var heroImage = marker.options.icon.options.heroImage;
				var imageCount = marker.options.icon.options.imageCount;
				var videoCount = marker.options.icon.options.videoCount;
				var gameCount = marker.options.icon.options.gameCount;
				var placeTitle = marker.options.icon.options.title;
				var placeId = marker.options.icon.options.placeId;

				var content = '<div class="upper-card" style="background-image: url(' + heroImage + ')"><div class="card-category">' +
					categoryIcon + categoryText + '</div></div><a class="no-anchor-decoration" href="' + url +
					'"><p class="place-title ' + category + '">' + placeTitle + '</p><br></a>' + "</div></div>";

				/*		
						      text += '<div class="place-card" id="' + placeId + '">' + content + '<div class="card-footer"><div class="image-count">' +
						      imageCountIcon + '&nbsp;&nbsp;' + imageCount + '</div><div class="video-count">' +
						      videoCountIcon + '&nbsp;&nbsp;' + videoCount + '</div><div class="game-count">' +
						      gameCountIcon + '&nbsp;&nbsp;' + gameCount + '</div></div></div>';
				*/
				//Google way?
				marker.bindPopup(content);

				//Google way?
				/*
				google.maps.event.addListener(marker, 'mouseover', function() {
				  this.setAnimation(google.maps.Animation.BOUNCE);
				});
				
				google.maps.event.addListener(marker, 'mouseout', function() {
				  this.setAnimation(null);
				});
*/
				$('.leaflet-marker-icon')
					.mouseenter(function() {
						$(this).css('height', '45px').css('width', '30px');
					})
					.mouseleave(function() {
						$(this).css('height', '38px').css('width', '25px');
					});
			}
		});
		$('#places').html(text);
		if (typeof(resultCard) !== 'undefined') {
			var removeCard = $('#' + $(resultCard).attr('id'));
			removeCard.remove();
			$('#places').prepend(resultCard);
		}
		$.ajax({
			url: "/places/liked_places",
			data: {
				placeIds: inBoundsMarkers
			},
			success: function(data) {
				console.log(data);
				$.each(data, function(key, value) {
					$('#' + key).append(value);
				});
				likeUnlike();
			}
		});
	}

	// Redirect to areas or places on click
	var addMarkersClickEvent = function(markers) {
		markers.on('click', function(e) {
			var markerProps = e.layer.options.icon.options.labelClassName.split(" ");
			var url = e.layer.options.icon.options.url;
			var markerType = '';
			markerProps.shift().match(/area/) ? markerType = 'area' : markerType = 'place';
			var markerID = markerProps.pop();
			var hasPlaces = markerProps.slice(-2)[0] === 'true';
			if (map.getZoom() < areahidelevel) {
				if (hasPlaces) {
					map.setView([e.latlng.lat, e.latlng.lng], areahidelevel + areatouchmagnification);
					showAreaCards();
					showPlaceCards();
					postSearchCSS();
				}
				else {
					window.location.href = url
				};
			}
			else { //if (map.getZoom() >= areahidelevel )
				if (markerType === 'area') {
					window.location.href = url
				}
				else {
					if (window.innerWidth < 1000) {
						e.layer.openPopup();
					}
					else {
						window.location.href = url;
					}
				}
			}
		});
	};


	/*
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
	//				  {where: "'bizCatSub' = 'Antique & Classic Motorcycle Dealers'", markerOptions:{ iconName:"star"}}, // other landmarks
					  {where: "'bizCatSub' = 'Other moto business'", markerOptions:{ iconName:"wht_pushpin"}}, //businesses
					  {where: "'bizCatSub' = 'Shop'", markerOptions:{iconName:"red_blank"}}, //town houses
					  {where: "'bizCatSub' = '12'", markerOptions:{ iconName:"orange_blank"}}, //country homes
					  {where: "'bizCatSub' = '15'", markerOptions:{ iconName:"target"}},
					]

				  });
				  clayer.setMap(map);
	*/
	$.getJSON("Source/countries30_na.topojson", function(data) {
		geoJsonObject = topojson.feature(data, data.objects.countries_no_antarctica);
		map.data.addGeoJson(geoJsonObject);
		// Set the stroke width, and fill color for each polygon
		var featureStyle = {
			fillColor: 'transparent',
			strokeWeight: 0
		}
		map.data.setStyle(featureStyle);

		// zoom to the clicked feature
		map.data.addListener('click', function(e) {

			var contentString = '<a href="/places/placeprograms?id=<%=place.id%>"<div id="content">' +
				'<div id="siteNotice">' +
				'</div>' +
				//      '<h1 id="firstHeading" class="firstHeading">Uluru</h1>'+
				'<div class="popup_img" content: "<%=place.categories[0].name%>" style="background: transparent url("<%=first_category_icon(place)%>")"><img src="<%=asset_path(place.photos[0].path_url(:small))%>"/></div>' +
				'<div id="bodyContent">' +
				'<p><b><%=place.display_name%></b> <h6><%=place.area.display_name%></h6>' +
				'</p>' +
				'</div>' +
				'<p class="popup-bottom"><%=place_yearlevels(place)%><span class="fa"><!--IMPLEMENT WITH RATINGS&#xf004; &#xf004; &#xf004; <i>&#xf004; &#xf004;--></i>  </span></p>' +
				'</div></a>';

			document.getElementById('info-box').innerHTML =
				"iso_a2 = " + e.feature.getProperty('iso_a2') + "<BR>" + "name = " + e.feature.getProperty('brk_name') + "<BR>" + "name = " + e.feature.getProperty('brk_name') + "<BR>" + "population = " + e.feature.getProperty('pop_est') + "<BR>" + "economy = " + e.feature.getProperty('economy') + "<BR>" + "continent = " + e.feature.getProperty('continent') + "<BR>";
			var bounds = new google.maps.LatLngBounds();
			processPoints(e.feature.getGeometry(), bounds.extend, bounds);
			map.fitBounds(bounds);
			//				    window.open("https://www.cia.gov/library/publications/the-world-factbook/geos/"+e.feature.getProperty('iso_a2').toLowerCase()+".html");
		});

	});

}); //end document ready

function processPoints(geometry, callback, thisArg) {
	if (geometry instanceof google.maps.LatLng) {
		callback.call(thisArg, geometry);
	}
	else if (geometry instanceof google.maps.Data.Point) {
		callback.call(thisArg, geometry.get());
	}
	else {
		geometry.getArray().forEach(function(g) {
			processPoints(g, callback, thisArg);
		});
	}
}

location.hash == '' ? location.hash = '#3/-33.865143/151.2099' : location.hash = location.hash;

function br_parseHash(location_hash) {
	var loc = location_hash.replace('#', '').split('/');
	my_loc = {};
	my_loc.zoom = loc[0];
	my_loc.center = {};
	my_loc.center.lat = loc[1];
	my_loc.center.lng = loc[2];
	return my_loc;
}
window.parsedHash = br_parseHash(location.hash);
//Set initial values
window.previousZoom = window.parsedHash.zoom;
window.previousLocation = window.parsedHash.center;

window.eachPlaceMarker = {};

var transitionzoomlevel = 6; //2d zoom level transition to globe
var areahidelevel = 7; //zoom level at which area icons that have places are replaced with cluster icons
var areatouchmagnification = 3; //number of levels to zoom when touch area with places

if (window.parsedHash.zoom < 4) {
	$('#cesiumContainer').css('visibility', 'visible');

	if (typeof viewer != 'undefined') {
		var pc = Cesium.Cartographic.fromDegrees(window.parsedHash.center.lng, window.parsedHash.center.lat, BR_MAX_ZOOM);
		viewer.scene.camera.setView({
			positionCartographic: pc,
			heading: Cesium.Math.toRadians(0.0), // east, default value is 0.0 (north)
			pitch: Cesium.Math.toRadians(-90), // default value (looking down)
			roll: 0.0 // default value
		});
	}

	/*			if(typeof brglobe != 'undefined')
					brglobe.setLocation(window.parsedHash.center.lat, window.parsedHash.center.lng);
	*/
	// resetHomeScreen();
}
else {
	$('#cesiumContainer').css('visibility', 'hidden');
	$('#googleMap').css("zIndex", 1);
}
