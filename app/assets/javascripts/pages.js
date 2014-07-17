map = L.mapbox.map('map', 'oztexan.ik2lcloh', {
    // these options apply to the tile layer in the map
    tileLayer: {
        // this map option disables world wrapping. by default, it is false.
        continuousWorld: false,
        // this option disables loading tiles outside of the world bounds.
        noWrap: true
      },
      zoomControl: false,
      maxBounds: [[85,-250],[-85,250]],
      minZoom: 3,
      maxZoom: 17
    });

window.initialCenter = $('.modal-content').data();
if (window.initialCenter.lat) {
  map.setView([initialCenter.lat, initialCenter.long], 6);
};

L.control.zoomslider().addTo(map);

map.on('zoomend', function() {
    if (map.getZoom() < 4){
      $('#svgdiv').show("medium");
    };
});

window.placeMarkers = new L.MarkerClusterGroup({showCoverageOnHover: false, maxClusterRadius: 20});
placeMarkers.addTo(map);
window.areaMarkers = new L.MarkerClusterGroup({showCoverageOnHover: false, maxClusterRadius: 20});
areaMarkers.addTo(map);

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
           riseOffset: 500}
      );
      markerArray.push(marker);
    };
  };

  return markerArray;
};


//Get all areas and add to map
$.ajax({
  url: '/areas.json',
  success: function(data) {
    window.areasGeoJSON = data;
    var areasArray = createMarkerArray(data, 'area');

    areaMarkers.addLayers(areasArray);
    addMarkersClickEvent(areaMarkers);

    //Get all places and add to map
    $.ajax({
      url: '/places.json',
      success: function(data) {
        window.placesGeoJSON = data;
        var placesArray = createMarkerArray(data, 'place');
        addMarkersClickEvent(placeMarkers);

        //switch between areas and places
        map.on('zoomend', function() {
            map.getZoom() < 7 ? placeMarkers.removeLayers(placesArray) : placeMarkers.addLayers(placesArray);
        });
      }
    });

  }
});

//


var lastLoaded = 0

// Launch modals on clicks
var addMarkersClickEvent = function(markers) {
  markers.on('click', function(e) {
    var markerProps = e.layer.options.icon.options.labelClassName.split(" ");
    var markerType = '';
    markerProps.shift().match(/area/) ? markerType = 'area' :  markerType = 'place';
    var markerID = markerProps.pop();
    var hasPlaces = markerProps.slice(-2)[0] === 'true';
    if (map.getZoom() < 7 ) {
      if (hasPlaces) {
        map.setView([e.latlng.lat, e.latlng.lng], 7);
      } else {
          $('.area-content').empty();
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
          $('#showAreaModal').length < 1 ? $('#areaModal').modal() : $('#showAreaModal').modal();
        };
      } else {
        if (markerType === 'area') {
          $('.area-content').empty();
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
          $('#showAreaModal').length < 1 ? $('#areaModal').modal() : $('#showAreaModal').modal();
        } else {
          $('.area-content').empty();
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
          $('#showAreaModal').length < 1 ? $('#areaModal').modal() : $('#showAreaModal').modal();
        }
      }
  });
};
