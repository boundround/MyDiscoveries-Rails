$("#pac-input").geocomplete({
  types: ['geocode', 'establishment'],
  map: ".map-canvas",
  details: "body",
  detailsAttribute: "data-geo"
});

$(document).ready(function() {
  if ($.cookie('modal_shown') == null) {
      $.cookie('modal_shown', 'yes');
      $('#navModal').modal('show');
  } else {
    $('#navModal').modal('hide');
  }
});
