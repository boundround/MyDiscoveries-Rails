
map = L.mapbox.map('map', 'boundround.j0d79a3j', {

  	worldCopyJump: true,
    // these options apply to the tile layer in the map
    tileLayer: {
        // this map option disables world wrapping. by default, it is false.
        continuousWorld: false,
        // this option disables loading tiles outside of the world bounds.
        noWrap: true
      },
      zoomControl: false,
      maxBounds: [[85,-250],[-85,250]],
      minZoom: 2,
      maxZoom: 18
    });

L.control.zoomslider().addTo(map);

// Create leaflet hash object
var hash = L.hash(map);
var hasharray = window.location.hash.substr(1).split('/');

function setMapViewFromHash(){
  map.setView([hasharray[1], hasharray[2]], hasharray[0]);
  $('#svgdiv').fadeOut('fast');
};

map.on('zoomend', function() {
  if (map.getZoom() < transitionzoomlevel){
    $('#svgdiv').fadeIn("fast");
    var ll = window.previousLocation ? window.previousLocation : map.getCenter();
    if (typeof brglobe != 'undefined') {
 		  brglobe.setLocation(ll.lat,ll.lng);
       console.log("zoomend 1 fired");
    }
  }
});

var transitionzoomlevel = 4; //2d zoom level transition to globe
var areahidelevel = 7; //zoom level at which area icons that have places are replaced with cluster icons
var areatouchmagnification = 3; //number of levels to zoom when touch area with places

window.placeMarkers = new L.MarkerClusterGroup({showCoverageOnHover: false, maxClusterRadius: 20});
placeMarkers.addTo(map);
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

var getInboundCategories = function() {
  // Construct an empty object to keep track of onscreen markers.
  inboundCategories = {
    all: true,
    beach: false,
    park: false,
    animals: false,
    sport: false,
    museum: false,
    activity: false,
    theme_park: false,
    sights: false,
    place_to_eat: false,
    place_to_stay: false,
    shopping: false,
  };


  // Get the map bounds - the top-left and bottom-right locations.
  var bounds = map.getBounds();

  // Temporarily add all place markers.
  var tempMarkers = new L.MarkerClusterGroup();
  tempMarkers.addLayers(placeLayers['all']);

  // For each marker, consider whether it is currently visible by comparing
  // with the current map bounds.
  tempMarkers.eachLayer(function(marker) {
      if (bounds.contains(marker.getLatLng())) {
          inboundCategories[marker.options.category] = true;
      }
  });

  // Remove all place markers.
  tempMarkers.clearLayers();

  return inboundCategories;
};

var setFilterButtons = function(inboundCategories) {
  $('#no-places').remove();

  // Temporarily show all buttons.
  $('#menu-ui').find('a').show();

  // Hide filter menu buttons that don't relate to visible markers.
  var shownCategoryButtons = [];
  for (var category in inboundCategories) {
    if( inboundCategories.hasOwnProperty( category ) ) {
      if (inboundCategories[category]) {
        shownCategoryButtons.push(category);
      } else {
        $('a[data-category=' + category + ']').hide();
      }
    }
  }
  if (shownCategoryButtons.length <= 1 ) {
    $('#menu-ui').find('a').hide();
    $('#menu-ui').prepend("<a id='no-places'>No Places</a>");
  }
};

// Change filter menu based on markers visible in current view
map.on('moveend', function(event) {
  if (map.getZoom() >= transitionzoomlevel) {
    console.log('move end fired');
    setFilterButtons(getInboundCategories());
  }
});

$('#menu-ui').on('click', 'a', function(e) {
  category = $(this).data('category');
  $(this).siblings().removeClass('active');
  $(this).addClass('active');
  placeMarkers.clearLayers();
  placeMarkers.addLayers(placeLayers[category]);
});

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
                  iconSize: new L.Point(55, 55),
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
                                              url: location.properties.url
                                              });},
      place: function() {return new placeIcon({ labelText: location.properties.title,
                                              labelClassName: 'place-icon-label ' + location.properties.id,
                                              iconUrl: location.properties.icon.iconUrl,
                                              url: location.properties.url
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
        var placesArray = createMarkerArray(data, 'place');
        addMarkersClickEvent(placeMarkers);

        //switch between areas and places
        map.on('zoomstart', function() {
          window.previousZoom = map.getZoom();
					window.previousLocation = map.getCenter();
          console.log('zoomstart fired');
        });
        map.on('zoomend', function() {
          var newZoom = map.getZoom();
          if (previousZoom >= areahidelevel && newZoom < areahidelevel) {
            placeMarkers.removeLayers(placesArray);
            areaMarkers.addLayers(window.areaLayers.havePlaces)
            $('#menu-ui').css("visibility", "hidden");
          } else if (previousZoom < areahidelevel && newZoom >= areahidelevel){
            areaMarkers.removeLayers(window.areaLayers.havePlaces)
            placeMarkers.addLayers(placesArray);
            $('#menu-ui').css("visibility", "visible");
          }
          console.log('zoomend 2 fired');
        });
        if (window.location.hash && hasharray[0] > 3) {
          setMapViewFromHash();
          addMarkersClickEvent(placeMarkers);
          areaMarkers.removeLayers(window.areaLayers.havePlaces)
          placeMarkers.addLayers(placesArray);
          $('#menu-ui').css("visibility", "visible");
        }
      }
    });

  }
});

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
      } else {
          // setModalContent(markerType, markerID);
          window.location.href = url
        };
    } else { //if (map.getZoom() >= areahidelevel )
        if (markerType === 'area') {
          // setModalContent(markerType, markerID);
          window.location.href = url
        } else {
          // setModalContent(markerType, markerID);
          window.location.href = url
        };
      };
  });
};

$('.dude-help').on('click', function () {
  $(this).find('.balloon-wrapper').toggleClass('balloon-wrapper-show');
  $(this).toggleClass('dude-help-out');
});


// Search Box

// Save User Location
var userIP = $('#user-ip').data('ip');
var userCity = '';
var userCountry = '';

var resultSource = '';

$.ajax({
  url: 'http://freegeoip.net/json/' + userIP,
  success: function(data) {
    console.log(data.city);
    userCity = data.city;
    userCountry = data.country_name;
  }
});

$('.search-box').autocomplete({
  source: function( request, response ) {
    console.log(request);
    $.ajax({
      url: '/places/search.json?term=' + request.term,
      success: function( data ) {
        console.log(data);
        if ( data.length >= 1 ) {
          response( $.map( data, function( item ) {
            return {
              label: item.display_name + (item.area.display_name ? ", " + item.area.display_name : "") + ", " + item.area.country,
              value: item.display_name,
              lat: item.latitude,
              lng: item.longitude,
              resultType: 'place'
            }
          }));
        } else {
          autoCompleteAreaSearch(request, response);
        }
      }
    });

    var autoCompleteAreaSearch = function(request, response) {
      $.ajax({
        url: '/areas/search.json?term=' + request.term,
        success: function( data ) {
          console.log(data);
          if ( data.length >= 1 ) {
            response( $.map( data, function( item ) {
              return {
                label: item.display_name + (item.country ? ", " + item.country : ""),
                value: item.display_name,
                lat: item.latitude,
                lng: item.longitude,
                resultType: 'area'
              }
            }));
          } else {
            geoNamesSearch(request, response);
            // googlePlaceSearch(request, response);
          }
        }
      });
    };

    // var googlePlaceSearch = function(request, response) {
    //   function initialize() {
    //     var service = new google.maps.places.AutocompleteService();
    //     service.getQueryPredictions({ input: request.term }, callback);
    //   }
    //
    //   function callback(predictions, status) {
    //     if (status != google.maps.places.PlacesServiceStatus.OK) {
    //       alert(status);
    //       return;
    //     }
    //     response( $.map( predictions, function( item ) {
    //       return {
    //         label: item.description,
    //         value: item.description,
    //         lat: 0,
    //         lng: 0,
    //         resultType: 'Google'
    //       }
    //     }));
    //     // var results = document.getElementById();
    //     //
    //     // for (var i = 0, prediction; prediction = predictions[i]; i++) {
    //     //   results.innerHTML += '<li>' + prediction.description + '</li>';
    //     // }
    //     console.log(status);
    //     console.log(predictions);
    //
    //
    //   }
    //
    //   initialize();
    // }


    var geoNamesSearch = function(request, response) {
      $.ajax({
        url: "http://ws.geonames.org/searchJSON?username=boundround",
        dataType: "jsonp",
        data: {
          featureClass: "S",
          style: "full",
          maxRows: 12,
          name_startsWith: request.term
        },
        success: function( data ) {
          console.log(data);
          response( $.map( data.geonames, function( item ) {
            return {
              label: item.name + (item.adminName1 ? ", " + item.adminName1 : "") + ", " + item.countryName,
              value: item.name,
              lat: item.lat,
              lng: item.lng,
              resultType: 'geoNames'
            }
          }));
        }
      });
    }

  },
  minLength: 2,
  select: function( event, ui ) {
    console.log(event);
    console.log(ui);
    $.ajax({
      type: "POST",
      url: '/searchqueries/create',
      data: {search_query: {
        term: this.value,
        source: ui.item.resultType,
        city: userCity,
        country: userCountry
      }},
      success: console.log('saved: ' + ui.item.label),
    });
    console.log(this);
    console.log( ui.item ?
      "Selected: " + ui.item.label :
      "Nothing selected, input was " + this.value);
    var newZoom = 7;
    if (ui.item.resultType === 'place') {
      newZoom = 13;
    }
    console.log('new zoom' + newZoom);
    $('#svgdiv').fadeOut("fast");
    map.setView( [ui.item.lat, ui.item.lng], newZoom );
    if (typeof brglobe != 'undefined') {
       brglobe.setLocation(ui.item.lat, ui.item.lng);
    }
  },
  open: function() {
    $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
  },
  close: function() {
    $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
  }
});
