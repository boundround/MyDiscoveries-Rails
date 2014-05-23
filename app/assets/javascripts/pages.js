map = L.mapbox.map('map', 'oztexan.map-m8oepi17', {
    // these options apply to the tile layer in the map
    tileLayer: {
        // this map option disables world wrapping. by default, it is false.
        continuousWorld: false,
        // this option disables loading tiles outside of the world bounds.
        noWrap: true
      },
    maxBounds: [[85,-180],[-85,180]],
    maxZoom: 2
    });

// gilupstream.i8lde4kj

$.ajax({
  dataType: 'text',
  url: '/areas.json',
  success: function(data) {
    var geojson;
    geojson = $.parseJSON(data);
    var featureLayer = L.mapbox.featureLayer(geojson)
    .addTo(map);
  }
});

