map = L.mapbox.map('map', 'oztexan.map-m8oepi17');


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




$('#map').on('click', function() {
  $('#map-modal').modal('toggle')
});

