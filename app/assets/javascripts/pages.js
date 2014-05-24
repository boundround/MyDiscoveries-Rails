map = L.mapbox.map('map', 'oztexan.map-m8oepi17', {
    // these options apply to the tile layer in the map
    tileLayer: {
        // this map option disables world wrapping. by default, it is false.
        continuousWorld: false,
        // this option disables loading tiles outside of the world bounds.
        noWrap: true
      },
    zoomControl: false,
    maxBounds: [[85,-180],[-85,180]],
    minZoom: 2,
    maxZoom: 15
    });

L.control.zoomslider().addTo(map);

// gilupstream.i8lde4kj

var areaLayer = L.mapbox.featureLayer().addTo(map);

var addMarkers = function(geojson, layer) {
  layer.setGeoJSON(window.geojson);
};

$.ajax({
  url: '/areas.json',
  success: function(data) {
    window.geojson = data;
    // addMarkers(data, areaLayer);
    markClust(data);
  }
});

areaLayer.on('click', function(e) {
    $('#myModal').modal({remote: '/areas/1.html', show: 'true'});
});


// markecluster code


var markers = new L.MarkerClusterGroup();

var markClust = function (geojson) {
  for (var i = 0; i < geojson.length; i++) {
    var a = geojson[i];
    var marker = L.marker(new L.LatLng(a.geometry.coordinates[1], a.geometry.coordinates[0]), {
        icon: L.icon({iconUrl: 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png', iconSize: [43, 26]})
    });
    markers.addLayer(marker);
}

map.addLayer(markers);

};
