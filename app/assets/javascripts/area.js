$("#pac-input").geocomplete({
  types: ['geocode', 'establishment'],
  map: ".map-canvas",
  details: "body",
  detailsAttribute: "data-geo"
});


$(document).ready(function(){
  $('.fun-fact-icon').on('click', function() {
    $(this).next('.fun-fact').toggle("slow");
  });
});
