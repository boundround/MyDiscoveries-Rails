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

window.initialCenter = $('.modal-content').data();
if (window.initialCenter.lat) {
  map.setView([initialCenter.lat, initialCenter.long], transitionzoomlevel);
};

L.control.zoomslider().addTo(map);


map.on('zoomend', function() {
    if (map.getZoom() < transitionzoomlevel){
      $('#svgdiv').fadeIn("fast");
      var ll = window.previousLocation ? window.previousLocation : map.getCenter();
      if (typeof brglobe != 'undefined') {
   		  brglobe.setLocation(ll.lat,ll.lng);
      };
    };
});

//var transitionzoomlevel = 7;
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
      };
    };
  };
  if (shownCategoryButtons.length <= 1 ) {
    $('#menu-ui').find('a').hide();
    $('#menu-ui').prepend("<a id='no-places'>No Places</a>");
  };
};

// Change filter menu based on markers visible in current view
map.on('moveend', function(event) {
  if (map.getZoom() >= transitionzoomlevel) {
    console.log(event);
    console.log('move end fired');
    setFilterButtons(getInboundCategories());
  };
});

// map.on('zoom', function() {
//   if (map.getZoom() > transitionzoomlevel) {
//     console.log('zoom end fired');
//
//     setFilterButtons(getInboundCategories());
//   };
// });



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
                                              + location.properties.id
                                              });},
      place: function() {return new placeIcon({ labelText: location.properties.title,
                                              labelClassName: 'place-icon-label ' + location.properties.id,
                                              iconUrl: location.properties.icon.iconUrl.replace(/svg/, 'png') //temporary replace instead of svg
                                              });}
    }

    // Only create marker if it has lat and long
    if (location.geometry.coordinates[1] && location.geometry.coordinates[0]) {
      var marker = L.marker(new L.LatLng(location.geometry.coordinates[1], location.geometry.coordinates[0]),
          {icon: icon[markerType](),
           riseOnHover: true,
           riseOffset: 500,
           category: location.properties.category }
      );
      markerArray.push(marker);
      if (markerType == 'place') {
        if (placeLayers[location.properties.category]) {
          window.placeLayers[location.properties.category].push(marker);
        };
      };
      if (markerType == 'area') {
        location.properties.places ? window.areaLayers.havePlaces.push(marker) : window.areaLayers.noPlaces.push(marker);
      };
    };
  };
  if (markerType == 'place') {
    window.placeLayers.all = markerArray;
  }
  return markerArray;
};


//Get all areas and add to map
$.ajax({
  url: '/areas.json',
  success: function(data) {
    window.areasGeoJSON = data;
    var areasArray = createMarkerArray(data, 'area');

    areaMarkers.addLayers(window.areaLayers.havePlaces);
    areaMarkers.addLayers(window.areaLayers.noPlaces);

    addMarkersClickEvent(areaMarkers);

    //Get all places and add to map
    $.ajax({
      url: '/places.json',
      success: function(data) {
        window.placesGeoJSON = data;
        var placesArray = createMarkerArray(data, 'place');
        addMarkersClickEvent(placeMarkers);

        //switch between areas and places
        map.on('zoomstart', function() {
          window.previousZoom = map.getZoom();
					window.previousLocation = map.getCenter();
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
            };
        });
      }
    });

  }
});

//


var lastLoaded = 0;

// Launch modals on clicks
var addMarkersClickEvent = function(markers) {
  markers.on('click', function(e) {
    var markerProps = e.layer.options.icon.options.labelClassName.split(" ");
    var markerType = '';
    markerProps.shift().match(/area/) ? markerType = 'area' :  markerType = 'place';
    var markerID = markerProps.pop();
    var hasPlaces = markerProps.slice(-2)[0] === 'true';
    if (map.getZoom() < areahidelevel ) {
      if (hasPlaces) {
        map.setView([e.latlng.lat, e.latlng.lng], areahidelevel+areatouchmagnification);
      } else {
          $('.area-content').empty();
          $('#areaModal').modal()
          $.ajax({
            url: '/' + markerType + 's/' + markerID + ".html",
            success: function(data) {
              $('.area-content').html(data);
              //Vimeo api code
              var iframe = $('.hero-video')[0];
              player = $f(iframe);

              // When the player is ready, add listeners for pause, finish, and playProgress
              player.addEvent('ready', function() {
              });

              // Call the API when a button is pressed
              $('#dropdownMenu1').bind('click', function() {
                  player.api('pause');
              });


              //Stop  area video on modal close
              $('#areaModal').on('hidden.bs.modal', function (e) {
                player.api('pause');
              });
            }
          });
          window.lastLoaded = markerID;
          // $('#showAreaModal').length < 1 ? $('#areaModal').modal() : $('#showAreaModal').modal();
        };
    }
		else//      if (map.getZoom() >= areahidelevel )
		{
        if (markerType === 'area') {
          $('.area-content').empty();
          $('#areaModal').modal()
          $.ajax({
            url: '/' + markerType + 's/' + markerID + ".html",
            success: function(data) {
              $('.area-content').html(data);

              //Vimeo api code
              var iframe = $('.hero-video')[0];
              player = $f(iframe);

              // When the player is ready, add listeners for pause, finish, and playProgress
              player.addEvent('ready', function() {
              });

              // Call the API when a button is pressed
              $('#dropdownMenu1').bind('click', function() {
                  player.api('pause');
              });


              //Stop  area video on modal close
              $('#areaModal').on('hidden.bs.modal', function (e) {
                player.api('pause');
              });
            }
          });
          window.lastLoaded = markerID;
          // $('#showAreaModal').length < 1 ? $('#areaModal').modal() : $('#showAreaModal').modal();
        } else {
          $('.area-content').empty();
          $('#areaModal').modal()
          $.ajax({
            url: '/' + markerType + 's/' + markerID + ".html",
            success: function(data) {
              $('.area-content').html(data);

              //Vimeo api code
              var iframe = $('.hero-video')[0];
              player = $f(iframe);

              // When the player is ready, add listeners for pause, finish, and playProgress
              player.addEvent('ready', function() {
              });

              // Call the API when a button is pressed
              $('#dropdownMenu1').bind('click', function() {
                  player.api('pause');
              });


              //Stop  area video on modal close
              $('#areaModal').on('hidden.bs.modal', function (e) {
                player.api('pause');
              });
            }
          });
          window.lastLoaded = markerID;
          // $('#showAreaModal').length < 1 ? $('#areaModal').modal() : $('#showAreaModal').modal();
        };
      };
  });
};

$('.dude-help').on('click', function () {
  $(this).find('.balloon-wrapper').toggleClass('balloon-wrapper-show');
  $(this).toggleClass('dude-help-out');
});
