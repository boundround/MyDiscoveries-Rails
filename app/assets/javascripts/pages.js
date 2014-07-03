map = L.mapbox.map('map', 'oztexan.map-m8oepi17', {
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
      maxZoom: 15
    });

window.initialCenter = $('.modal-content').data();
if (window.initialCenter.lat) {
  map.setView([initialCenter.lat, initialCenter.long], 6);
};

L.control.zoomslider().addTo(map);

window.markers = new L.MarkerClusterGroup({showCoverageOnHover: false, maxClusterRadius: 20});
markers.addTo(map);

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
                  iconSize: new L.Point(30, 26),
                  iconAnchor: new L.Point(0, 0),
                  labelAnchor: new L.Point(34, 0),
                  wrapperAnchor: new L.Point(21, 13),
                  labelClassName: 'place-icon-label'
                }
              });

//new marker array
var createMarkerArray = function(geoJSON, markerType) {
  var markerArray = [];   

  for (var i = 0; i < geoJSON.length; i++) {
    var location = geoJSON[i];

    var icon = {
      area: function() {return new areaIcon({ labelText: location.properties.title,
                                              labelClassName: 'area-icon-label' + ' '
                                              + location.properties.places + ' '
                                              + location.properties.id
                                              });},
      place: function() {return new placeIcon({ labelText: location.properties.title,
                                              labelClassName: 'place-icon-label ' + location.properties.id
                                              });}
    }

    var marker = L.marker(new L.LatLng(location.geometry.coordinates[1], location.geometry.coordinates[0]),
        {icon: icon[markerType]() }
    );
    markerArray.push(marker);
  };

  return markerArray;
};


//Get all areas and add to map
$.ajax({
  url: '/areas.json',
  success: function(data) {
    window.areasGeoJSON = data;
    var areasArray = createMarkerArray(data, 'area');

    markers.addLayers(areasArray);
    addMarkersClickEvent();

    //Get all places and add to map
    $.ajax({
      url: '/places.json',
      success: function(data) {
        window.placesGeoJSON = data;
        var placesArray = createMarkerArray(data, 'place');
        addMarkersClickEvent();

        //switch between areas and places
        map.on('zoomend', function() {
            map.getZoom() < 7 ? markers.removeLayers(placesArray) : markers.addLayers(placesArray);
        });
      }
    });

  }
});

//


var lastLoaded = 0

// Launch modals on clicks
var addMarkersClickEvent = function() {
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

$('#areaModal').on('shown.bs.modal', function (e) {
  var $container = $('#photos-masonry');
  // init
  $container.imagesLoaded( function() {
    $container.isotope({
      layoutMode: 'masonry',
      itemSelector: '.item ',
      masonry: {
        columnWidth: $container.find('.grid-sizer')[0]
      }
    });

    $container.on( 'click', '.photo-card', function() {
      //close expanded photo card
      $( this ).siblings('.photo-card-expanded').toggleClass('photo-card-expanded')
        .find('.fun-fact').toggle();

      //expand clicked photo card
      $(this).find('.fun-fact').toggle();
      $( this ).toggleClass('photo-card-expanded');
      $container.isotope({ layoutMode : 'masonry' });
    });

    $container.on( 'click', '.game-card', function() {
      //close expanded game card
      $( this ).siblings('.game-card-expanded').toggleClass('game-card-expanded')
      .find('.game-thumbnail').toggle();

      $( this ).siblings('.game-card').find('.game-divider').empty();

      //expand clicked game card
      $(this).find('.game-thumbnail').toggle();
      $( this ).toggleClass('game-card-expanded');
      $(this).find('.game-divider').append('<iframe class="game-frame" src="http://09f1be2b4e79305414d1-e02ea5f9f7cbf68a786b2624900f7447.r95.cf4.rackcdn.com/games/Jigsaw/fiji.html"></iframe>');
      $container.isotope({ layoutMode : 'masonry' });
    });

  });

  $('#menu').on( 'click', 'a', function() {
    var filterValue = $(this).attr('data-filter');
    $container.isotope({ filter: filterValue });
  });

  var hash = $('.title').text();
  window.location.hash = hash;
  // window.onhashchange = function() {
  //   if (!location.hash){
  //     $(modal).modal('hide');
  //   }
  // }

  $('#areaModal').on('hide.bs.modal', function (e) {
    $container.isotope({ filter: '' });
    var hash = this.id;
    history.pushState('', document.title, window.location.pathname);
  });
})

$('#showAreaModal').modal('show');

$('#showAreaModal').on('shown.bs.modal', function (e) {
  var $container = $('#photos-masonry');
  // init
  $container.imagesLoaded( function() {
    $container.isotope({
      layoutMode: 'masonry',
      itemSelector: '.item ',
      masonry: {
        columnWidth: $container.find('.grid-sizer')[0]
      }
    });
    $container.on( 'click', '.photo-card', function() {

      $(this).find('.fun-fact').toggle();
      $( this ).toggleClass('photo-card-expanded');
      $container.isotope({ layoutMode : 'masonry' });
    });

    $container.on( 'click', '.game-card', function() {
      //close expanded game card
      $( this ).siblings('.game-card-expanded').toggleClass('game-card-expanded')
      .find('.game-thumbnail').toggle();

      $( this ).siblings('.game-card').find('.game-divider').empty();

      //expand clicked game card
      $(this).find('.game-thumbnail').toggle();
      $( this ).toggleClass('game-card-expanded');
      $(this).find('.game-divider').append('<iframe class="game-frame" src="http://09f1be2b4e79305414d1-e02ea5f9f7cbf68a786b2624900f7447.r95.cf4.rackcdn.com/games/Jigsaw/fiji.html"></iframe>');
      $container.isotope({ layoutMode : 'masonry' });
    });
    
  });

  $('#menu').on( 'click', 'a', function() {
    var filterValue = $(this).attr('data-filter');
    $container.isotope({ filter: filterValue });
  });
});
