
location.hash == '' ? location.hash = '#3/-33.865143/151.2099' : location.hash = location.hash;
window.parsedHash = L.Hash.parseHash(location.hash);
//Set initial values
window.previousZoom = window.parsedHash.zoom;
window.previousLocation = window.parsedHash.center;

var hoverBackground = {
  park: '#9ff1ab',
  animals: '#ff9280',
  activity: '#fa8383',
  beach: '#ffcf7b',
  museum: '#7994b1',
  place_to_eat: '#76a15a',
  place_to_stay: '#a0dcda',
  shopping: '#aab7f4',
  sights: '#f2a1bc',
  sport: '#d6abe8',
  theme_park: '#9dd0f0'
}

var formatCategory = function(string) {
  string = string.replace(/\_/g, " ");
  return string = string.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
}


var setViewForGooglePlace = function(place, city, country){
  geocoder = new google.maps.Geocoder();
  geocoder.geocode({ address: place }, function(results, status){
    if (status == google.maps.GeocoderStatus.OK) {
      var location = [results[0].geometry.location.k, results[0].geometry.location.D];
      $('#svgdiv').fadeOut("fast");
        map.setView( location, 9 );

      var popup = L.popup()
        .setLatLng(location)
        .setContent('<h3>' + place + '</h3><br><button type="button" class="want-button" class="btn btn-default btn-md"><span class="glyphicon glyphicon-thumbs-up"></span> I Want This in Bound Round</button>')
        .openOn(map);
      var placeCard = place + '-card';
      var areas = $('#areas');
      var content = '<div class="want-card"><div class="area-title">'
                   + place + '<br><button type="button" class="want-button" class="btn btn-default btn-md"><span class="glyphicon glyphicon-thumbs-up"></span> I Want This in Bound Round</button></div></div>';
      areas.append(content);
      $('#places').empty();

      $('.want-button').on('click', function(e) {
      $('.want-button').hide();
      $('.leaflet-popup-content').append("Thanks we're on it!");
      areas.find('.area-card').html("<br><h3 style='text-align:center'>Thanks, we're on it!</h3>");

      $.ajax({
        type: "POST",
        url: '/notification',
        data: {place: place,
              city: city,
              country: country
        },
        success: console.log('sent: ' + place),
      });
    });
    } else {
      console.log(status);
    }
  });
};


var postSearchCSS = function() {
  $('.br-logo-home').addClass('br-logo-home-post-search');
  $('.search-wrapper').addClass('search-wrapper-post-search');
  $('.home-text').hide();
  $('.ui-select').show();
  $('#places').show();
  $('#areas').show();
}

var resetHomeScreen = function() {
  $('.br-logo-home').removeClass('br-logo-home-post-search');
  $('.search-wrapper').removeClass('search-wrapper-post-search');
  $('.home-text').show();
  $('.ui-select').hide();
  $('#places').hide();
  $('#areas').hide();
  console.log('resetting home screen');
}

var removeDuplicateAreaObjects = function(array) {
  var out = [];
  var temp = {};
  for (var i = 0; i < array.length; i++) {
    temp[array[i].title] = array[i];
  }

  for (var key in temp) {
    if (temp.hasOwnProperty(key)) {
      out.push(temp[key])
    }
  }
  return out;
}

var areasPlacesSwitch = function() {
  //switch between areas and places
  if (window.parsedHash && window.parsedHash.zoom > 3) {
    areaMarkers.removeLayers(window.areaLayers.havePlaces)
    placeMarkers.addLayers(placesArray);
    showAreaCards();
    showPlaceCards();
    postSearchCSS();
  }
};

var transitionzoomlevel = 4; //2d zoom level transition to globe
var areahidelevel = 7; //zoom level at which area icons that have places are replaced with cluster icons
var areatouchmagnification = 3; //number of levels to zoom when touch area with places

map = L.mapbox.map('map', 'boundround.j0d6j474', {
		center: window.parsedHash.center,
		zoom: window.parsedHash.zoom,
  	worldCopyJump: true,
    // these options apply to the tile layer in the map
    tileLayer: {
        // this map option disables world wrapping. by default, it is false.
        continuousWorld: false,
        // this option disables loading tiles outside of the world bounds.
        noWrap: false
      },
      zoomControl: false,
      maxBounds: [[85,-250],[-85,250]],
      minZoom: 2,
      maxZoom: 18
});

L.control.zoomslider().addTo(map);

if (window.parsedHash.zoom < 4) {
  $('#svgdiv').css('visibility', 'visible');
	if(typeof brglobe != 'undefined')
		brglobe.setLocation(window.parsedHash.center.lat, window.parsedHash.center.lng);

  // resetHomeScreen();
}

// Create leaflet hash object
var hash = L.hash(map);

//This event fires when the map's initial position is set
/*map.on('load', function() {
  /// Switch globe display on

  if (window.parsedHash.zoom < 4) {
    $('#svgdiv').css('visibility', 'visible');
    // resetHomeScreen();
  }
});
*/

// Change filter menu based on markers visible in current view
map.on('moveend', function(event) {
  if (map.getZoom() >= areahidelevel) {
    // areaMarkers.addLayers(window.areaLayers.havePlaces);
    showAreaCards();
    showPlaceCards();
    postSearchCSS();
  } else {
    if (window.innerWidth > 1000){
      resetHomeScreen();
    }
  }
});

map.on('zoomstart', function() {
	/*
  if (map.getZoom() === undefined) {
    var mapSet = L.Hash.parseHash('#3/-33.865143/151.2099');
    map.setView(mapSet.center, mapSet.zoom);
    console.log('Setting Map View');
  }
  window.previousZoom = map.getZoom();
  console.log('previousZoom ' + window.previousZoom);
  window.previousLocation = map.getCenter();
*/
  if (map.getZoom() !== undefined) {
	  window.previousZoom = map.getZoom();
	  console.log('previousZoom ' + window.previousZoom);
	  window.previousLocation = map.getCenter();
	}
});

map.on('zoomend', function() {
  if (map.getZoom() !== undefined) {
	  var newZoom = map.getZoom();

	  console.log("this mapzoom: " + newZoom)
	  window.parsedHash = L.Hash.parseHash(location.hash);
	  console.log(window.parsedHash.zoom);

		//Are we zooming up to the globe?
	  if (newZoom < transitionzoomlevel){
	    $('#svgdiv').css('visibility', 'visible');
	    $('#svgdiv').fadeIn("fast");
	    var ll = window.previousLocation ? window.previousLocation : map.getCenter();
	    // resetHomeScreen();
	    if (typeof brglobe != 'undefined') {
	      brglobe.setLocationZ(ll.lat,ll.lng,newZoom);
	      console.log("zoomend 1 fired");
	    }
			else
			{
		    console.log("Error: brglobe global variable is undefined");
			}
	  }

	  if (window.previousZoom >= areahidelevel && newZoom < areahidelevel) {
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
	}
});

window.placeMarkers = new L.MarkerClusterGroup({showCoverageOnHover: false, maxClusterRadius: 20});
placeMarkers.addTo(map);
placeMarkers.on('mouseover', function(e) {
  var cardId = $('#' + e.layer.options.icon.options.placeId);
  var backgroundColor = hoverBackground[e.layer.options.category];
  cardId.css('background-color', backgroundColor);
  cardId.find('.card-footer').css('background-color', cardId.find('.place-title').css('color'));
  cardId.find('.card-footer').css('color', 'white');
  e.layer.openPopup();
  console.log(e.layer.options.icon.options.iconSize.x);
  console.log(e.layer.options.icon.options.iconSize.y);
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

window.areaMarkers = new L.MarkerClusterGroup({showCoverageOnHover: false, maxClusterRadius: 20});
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

var areaIcon = L.Icon.Label.extend({
                options: {
                  iconUrl: 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png',
                  shadowUrl: null,
                  iconSize: new L.Point(43, 26),
                  iconAnchor: new L.Point(0, 0),
                  labelAnchor: new L.Point(47, 0),
                  wrapperAnchor: new L.Point(21, 13),
                }
              });

var placeIcon = L.Icon.Label.extend({
                options: {
                  iconUrl: 'http://09f1be2b4e79305414d1-e02ea5f9f7cbf68a786b2624900f7447.r95.cf4.rackcdn.com/icons20140522/Do_generic_yellow_m.png',
                  shadowUrl: null,
                  iconSize: new L.Point(25, 38),
                  iconAnchor: new L.Point(0, 0),
                  labelAnchor: new L.Point(0, 55),
                  wrapperAnchor: new L.Point(0, 0),
                  labelClassName: 'place-icon-label'
                }
              });

//new marker array
var createMarkerArray = function(geoJSON, markerType) {
  var markerArray = [];   

  for (var i = 0; i < geoJSON.features.length; i++) {
    var location = geoJSON.features[i];

    var icon = {
      area: function() {return new areaIcon({ labelText: location.properties.title,
                                              labelClassName: 'area-icon-label' + ' '
                                              + location.properties.places + ' '
                                              + location.properties.id,
                                              url: location.properties.url,
                                              placeCount: location.properties.placeCount,
                                              country: location.properties.country
                                              });},
      place: function() {return new placeIcon({ // labelText: location.properties.title,
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
                                              });}
    }

    // Only create marker if it has lat and long
    if (location.geometry.coordinates[1] && location.geometry.coordinates[0]) {
      var marker = L.marker(new L.LatLng(location.geometry.coordinates[1], location.geometry.coordinates[0]),
          {icon: icon[markerType](),
           riseOnHover: true,
           riseOffset: 500,
           category: location.properties.category }
      )
      markerArray.push(marker);
      if (markerType == 'place') {
        if (placeLayers[location.properties.category]) {
          window.placeLayers[location.properties.category].push(marker);
        }
      }
      if (markerType == 'area') {
        location.properties.places ? window.areaLayers.havePlaces.push(marker) : window.areaLayers.noPlaces.push(marker);
      }
    };
  };
  if (markerType == 'place') {
    window.placeLayers.all = markerArray;
  }
  return markerArray;
};

//Get all areas and add to map
$.ajax({
  url: '/areas/mapdata.json',
  success: function(data) {
    window.areasGeoJSON = data;
    var areasArray = createMarkerArray(data, 'area');

    areaMarkers.addLayers(window.areaLayers.havePlaces);
    areaMarkers.addLayers(window.areaLayers.noPlaces);

    addMarkersClickEvent(areaMarkers);

    //Get all places and add to map
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

var showAreaCards = function(){
  var bounds = map.getBounds();
  var text = '';
  var areas = [];
  areaMarkers.eachLayer(function(marker){
    if (bounds.contains(marker.getLatLng())) {
      areas.push(marker.options.icon.options);
    }
  });
  placeMarkers.eachLayer(function(marker) {
    if (bounds.contains(marker.getLatLng())) {
      areas.push(marker.options.icon.options.area)
    }
  });
  areas = removeDuplicateAreaObjects(areas);
  for (var i = 0; i < areas.length; i++) {
    var url = areas[i].url;
    var areaTitle = '';
    if (areas[i].hasOwnProperty('labelText')) {
      areaTitle += areas[i].labelText;
    } else {
      areaTitle += areas[i].title
    }
    if (areas[i].country != areaTitle){
      areaTitle += ', ' + areas[i].country;
    }
    if (areas[i].placeCount > 0) {
      var placeCountText = areas[i].placeCount + ' places';
    } else {
      var placeCountText = '&nbsp;';
    }

    var pin = '<div class="area-card-pin"><img src="http://d1w99recw67lvf.cloudfront.net/category_icons/place-pin.png" class="area-pin" alt="map pin"></div>';

    text += '<div class="area-card">' + pin + '<a class="no-anchor-decoration" href="' + url + '"><div class="area-title">' + areaTitle +
      '</a><br><span class="place-count">' + placeCountText + '</span></div></div>';
  }
  $('#areas').html(text);
}

var showPlaceCards = function(){
  var inBoundsMarkers = [];
  var bounds = map.getBounds();
  var text = "";
  placeMarkers.eachLayer(function(marker) {
    if (bounds.contains(marker.getLatLng())) {
      inBoundsMarkers.push(marker.options.icon.options.placeId);
      var category = marker.options.category;
      var categoryIcon = "<img src='http://d1w99recw67lvf.cloudfront.net/category_icons/" + marker.options.category + "_icon.png' alt='" + marker.options.category + " icon'>";
      var imageCountIcon = "<img src='http://d1w99recw67lvf.cloudfront.net/category_icons/photos_count.png' height='12px' alt='photo count'>";
      var gameCountIcon = "<img src='http://d1w99recw67lvf.cloudfront.net/category_icons/games_count.png' height='12px' alt='games count'>";
      var videoCountIcon = "<img src='http://d1w99recw67lvf.cloudfront.net/category_icons/videos_count.png' height='12px' alt='videos count'>";
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
      '"><p class="place-title ' + category + '">' + placeTitle + '</p><br></a>'

      text += '<div class="place-card" id="' + placeId + '">' + content + '<div class="card-footer"><div class="image-count">' +
      imageCountIcon + '&nbsp;&nbsp;' + imageCount + '</div><div class="video-count">' +
      videoCountIcon + '&nbsp;&nbsp;' + videoCount + '</div><div class="game-count">' +
      gameCountIcon + '&nbsp;&nbsp;' + gameCount + '</div></div></div>';

      marker.bindPopup(content);

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
    data: {placeIds: inBoundsMarkers},
    success: function(data){
      console.log(data);
      $.each(data, function(key, value){
        $('#' + key).append(value);
      });
    }
  });
}

// Redirect to areas or places on click
var addMarkersClickEvent = function(markers) {
  markers.on('click', function(e) {
    var markerProps = e.layer.options.icon.options.labelClassName.split(" ");
    var url = e.layer.options.icon.options.url;
    var markerType = '';
    markerProps.shift().match(/area/) ? markerType = 'area' :  markerType = 'place';
    var markerID = markerProps.pop();
    var hasPlaces = markerProps.slice(-2)[0] === 'true';
    if (map.getZoom() < areahidelevel ) {
      if (hasPlaces) {
        map.setView([e.latlng.lat, e.latlng.lng], areahidelevel+areatouchmagnification);
        showAreaCards();
        showPlaceCards();
        postSearchCSS();
      } else {
          window.location.href = url
        };
    } else { //if (map.getZoom() >= areahidelevel )
        if (markerType === 'area') {
          window.location.href = url
        } else {
          if (window.innerWidth < 1000){
            e.layer.openPopup();
          } else {
            window.location.href = url;
          }
        }
      }
  });
};

$('.dude-help').on('click', function () {
  $(this).find('.balloon-wrapper').toggleClass('balloon-wrapper-show');
  $(this).toggleClass('dude-help-out');
});


// Search Box

// Save User Location

window.onload = function() {
  var userIP = $('#user-ip').data('ip');
  var userCity = '';
  var userCountry = '';

  var iOS = ( navigator.userAgent.match(/(iPad|iPhone|iPod)/g) ? true : false );

  // $.ajax({
  //   url: 'http://freegeoip.net/json/' + userIP,
  //   success: function(data) {
  //     userCity = data.city;
  //     userCountry = data.country_name;
  //   }
  // });

  $('.search-box').autocomplete({
    autoFocus: true,
    //source: "/search_suggestions.json?term=" + request.term
    source: function( request, response ) {
      $.ajax({
        url: '/sm/search?types[]=place&types[]=area&limit=100&term=' + request.term,
        success: function( data ) {
          var data = $.map(data.results.area.concat(data.results.place), function( item ) {
            var areaDisplay = null;
            if (item.hasOwnProperty('area')) {
              if (item.area.display_name == item.area.country) {
                areaDisplay = item.area.display_name;
              } else {
                areaDisplay = item.area.display_name + ", " + item.area.country;
              };
            };

            if (item.hasOwnProperty('country')) {
              areaDisplay = item.country ? item.country : "";
            }

            return {
              label: item.display_name + (areaDisplay ? ", " + areaDisplay : ""),
              value: item.display_name,
              lat: item.latitude,
              lng: item.longitude,
              resultType: item.placeType,
              place_id: item.slug
            }
          });

          if ( data.length >= 1 ) {
            response(data);
          } else {
            googlePlaceSearch(request, response);
          }

          $('.search-sidebar').on('click', function(){
            $('#search-box').data('ui-autocomplete')._trigger('select', 'autocompleteselect', {item: data[0]});
          });
        }
      });

      // var geoNamesSearch = function(request, response) {
      //   $.ajax({
      //     url: "http://ws.geonames.org/searchJSON?username=boundround",
      //     dataType: "jsonp",
      //     data: {
      //       featureClass: "S",
      //       style: "full",
      //       maxRows: 12,
      //       name_startsWith: request.term
      //     },
      //     success: function( data ) {
      //       response( $.map( data.geonames, function( item ) {
      //         return {
      //           label: item.name + (item.adminName1 ? ", " + item.adminName1 : "") + ", " + item.countryName,
      //           value: item.name,
      //           lat: item.lat,
      //           lng: item.lng,
      //           resultType: 'geoNames'
      //         }
      //       }));
      //     }
      //   });
      // }

      var googlePlaceSearch = function(request, response) {
        function initialize() {
          var service = new google.maps.places.AutocompleteService();
          service.getQueryPredictions({ input: request.term }, callback);
        }

        function callback(predictions, status) {
          if (status != google.maps.places.PlacesServiceStatus.OK) {
            alert(status);
            return;
          }
          response( $.map( predictions, function( item ) {
            return {
              label: item.description,
              value: item.description,
              lat: -33.865143,
              lng: 151.2099,
              resultType: 'Google',
              placeId: item.place_id
            }
          }));
        }
        initialize();
      }

    },
    minLength: 2,
    select: function( event, ui ) {
      $.ajax({
        type: "POST",
        url: '/searchqueries/create',
        data: {search_query: {
          term: this.value,
          source: ui.item.resultType,
          city: userCity,
          country: userCountry
        }},
        success: console.log('saved: ' + ui.item.label)
      });

      var newZoom = 9;
      if (ui.item.resultType === 'place' || ui.item.resultType === 'area') {
        newZoom = 13;
        $('#svgdiv').fadeOut("fast");
        console.log(ui.item.lat + ', ' + ui.item.lng + ' ' + ui.item.resultType);
        map.setView( [ui.item.lat, ui.item.lng], newZoom );
        window.resultCard = $('#' + ui.item.place_id);
        console.log("saving result card");
        showAreaCards();
        showPlaceCards();
      }

      if (ui.item.resultType === 'Google') {
        setViewForGooglePlace(ui.item.label, userCity, userCountry);
      }

      if (typeof brglobe != 'undefined') {
         brglobe.setLocation(ui.item.lat, ui.item.lng);
      }

      document.activeElement.blur();

    },
    open: function() {
      $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
    },
    close: function() {
      $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
    }
  });
}

var filters = document.getElementById('filters');
var checkboxes = document.getElementsByClassName('filter');

var changeFilters = function () {
    // Find all checkboxes that are checked and build a list of their values
    var on = [];
    for (var i = 0; i < checkboxes.length; i++) {
        if (checkboxes[i].checked) on.push(checkboxes[i].value);
    }

    placeMarkers.clearLayers();
    for (var j = 0; j < checkboxes.length; j++) {
      placeMarkers.addLayers(placeLayers[on[j]]);
    }
    return false;
}

// When the form is touched, re-filter markers
filters.onchange = changeFilters;
// Initially filter the markers
changeFilters();
