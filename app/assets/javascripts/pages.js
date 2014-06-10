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

// gilupstream.i8lde4kj

var areaLayer = L.mapbox.featureLayer().addTo(map);

areaLayer.on('layeradd', function(e) {
    var marker = e.layer,
        feature = marker.feature;

    marker.setIcon(L.icon(feature.properties.icon));
});

var addMarkers = function(geojson, layer) {
  layer.setGeoJSON(window.geojson);
};

$.ajax({
  url: '/areas.json',
  success: function(data) {
    window.geojson = data;
    // addMarkers(data, window.areaLayer);
    markClust(data);
  }
});


var lastLoaded = 0

areaLayer.on('click', function(e) {
  if (e.layer.feature.properties.id !== lastLoaded) {
    $('.area-content').empty();
    $.ajax({
      url: '/areas/' + e.layer.feature.properties.id + ".html",
      success: function(data) {
        $('.area-content').html(data);
        setTimeout(function(){fakewaffle.responsiveTabs()}, 200);

      }
    });
  }
  window.lastLoaded = e.layer.feature.properties.id;
  $('#showAreaModal').length < 1 ? $('#areaModal').modal() : $('#showAreaModal').modal();
});

// markecluster code
var markers = new L.MarkerClusterGroup();

var markerArray = [];

var markClust = function (geojson) {
  for (var i = 0; i < geojson.length; i++) {
    var area = geojson[i];
    var marker = L.marker(new L.LatLng(area.geometry.coordinates[1], area.geometry.coordinates[0]), {
        icon: L.icon({iconUrl: 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png', iconSize: [43, 26], popupAnchor: [-3, -76]})
    });
    marker.bindLabel(area.properties.title, { noHide: true })
    markerArray.push(marker);
  };
  markers.addLayers(markerArray);
  map.addLayer(markers);
};

