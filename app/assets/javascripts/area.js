$("#pac-input").geocomplete({
  types: ['geocode', 'establishment'],
  map: ".map-canvas",
  details: "body",
  detailsAttribute: "data-geo"
});
