window.onload = function(){
  console.log('pac-input');
  $("#pac-input").geocomplete({
    types: ['geocode', 'establishment'],
    map: ".user-gen-map",
    markerOptions: {
      draggable: false
    },
    details: "body",
    detailsAttribute: "data-geo",
  });

  if ($('#place_address').length > 0) {
    var geoValue = $("#place_address").val();
  } else {
    var geoValue = $("#area_latitude").val() + ', ' + $("#area_longitude").val();
  }
  console.log('geovalue is: ' + geoValue);

  $("#pac-input").geocomplete("find", geoValue);

  // $("#pac-input")
  //   .geocomplete()
  //   .bind("geocode:dragged", function(event, result){
  //     // repopulate lat long and address fields on marker drag
  //     $("#pac-input").geocomplete("find", result.lat() + "," + result.lng());
  //   });
}
