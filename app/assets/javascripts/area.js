$("#pac-input").geocomplete({
  types: ['geocode', 'establishment'],
  map: ".map-canvas",
  markerOptions: {
    draggable: true
  },
  details: "body",
  detailsAttribute: "data-geo",
});

var geoValue = $("#place_address").val();

$("#pac-input").geocomplete("find", geoValue);
