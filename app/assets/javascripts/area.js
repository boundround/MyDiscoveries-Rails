window.onload = function(){
  $("#pac-input").geocomplete({
    types: ['geocode', 'establishment'],
    map: ".map-canvas",
    markerOptions: {
      draggable: true
    },
    details: "body",
    detailsAttribute: "data-geo",
  });


  $("#pac-input")
    .geocomplete()
    .bind("geocode:dragged", function(event, result){
      // repopulate lat long and address fields on marker drag
      $("#pac-input").geocomplete("find", result.lat() + "," + result.lng());
    });
}
