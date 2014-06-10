$("#pac-input").geocomplete({
  types: ['geocode', 'establishment'],
  map: ".map-canvas",
  details: "body",
  detailsAttribute: "data-geo"
});

$('#showAreaModal').modal();


$(document).ready(function(){
  $('.fun-fact-icon').on('click', function() {
    $(this).next('.fun-fact').toggle("slow");
  });
});


