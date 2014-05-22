map = L.mapbox.map('map', 'gilupstream.i8lde4kj', {
    // these options apply to the tile layer in the map
    tileLayer: {
        // this map option disables world wrapping. by default, it is false.
        continuousWorld: false,
        // this option disables loading tiles outside of the world bounds.
        noWrap: true
      }
    });

// oztexan.map-m8oepi17

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

