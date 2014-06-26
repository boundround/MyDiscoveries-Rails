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

//Get all areas and add to map
$.ajax({
  url: '/areas.json',
  success: function(data) {
    window.geoJSON = data;
    window.markers = createMarkerCluster(data);

    map.addLayer(markers);
    addMarkersClickEvent();
    //switch between areas and places
    map.on('zoomend', function() {
        map.getZoom() < 7 ? map.addLayer(markers): map.removeLayer(markers) ;
    });
  }
});

//Get all places and add to map
$.ajax({
  url: '/places.json',
  success: function(data) {
    window.placesGeoJSON = data;
    window.placesLayer = createMarkerCluster(data);

    addPlacesMarkersClickEvent();
    //switch between areas and places
    map.on('zoomend', function() {
        map.getZoom() < 7 ? map.removeLayer(placesLayer) : map.addLayer(placesLayer) ;
    });
  }
});


//new markercluster
var createMarkerCluster = function(geoJSON) {
  var markerCluster = new L.MarkerClusterGroup({showCoverageOnHover: false, maxClusterRadius: 20});
  var markerArray = [];

  for (var i = 0; i < geoJSON.length; i++) {
    var location = geoJSON[i];
    var marker = L.marker(new L.LatLng(location.geometry.coordinates[1], location.geometry.coordinates[0]), {
        icon: L.icon({iconUrl: 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png', iconSize: [43, 26], className: location.properties.id, popupAnchor: [-3, -76]})
    });

    marker.bindLabel(location.properties.title, { noHide: true })
    markerArray.push(marker);
  };

markerCluster.addLayers(markerArray);
return markerCluster;
};

var lastLoaded = 0

// Launch place modals on clicks
var addPlacesMarkersClickEvent = function() {
  placesLayer.on('click', function(e) {
    if (e.layer._icon.classList[1] !== lastLoaded) {
      $('.area-content').empty();
      $.ajax({
        url: '/places/' + e.layer._icon.classList[1] + ".html",
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
    }
    window.lastLoaded = e.layer._icon.classList[1];



    $('#showAreaModal').length < 1 ? $('#areaModal').modal() : $('#showAreaModal').modal();


  });
};




// Launch modals on clicks
var addMarkersClickEvent = function() {
  markers.on('click', function(e) {
    if (e.layer._icon.classList[1] !== lastLoaded) {
      $('.area-content').empty();
      $.ajax({
        url: '/areas/' + e.layer._icon.classList[1] + ".html",
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
    }
    window.lastLoaded = e.layer._icon.classList[1];



    $('#showAreaModal').length < 1 ? $('#areaModal').modal() : $('#showAreaModal').modal();


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
  });

  $('#menu').on( 'click', 'a', function() {
    var filterValue = $(this).attr('data-filter');
    $container.isotope({ filter: filterValue });
  });
});
