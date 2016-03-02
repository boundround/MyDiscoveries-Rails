// Add to Wishlist
function addToFav(){
  $('#place-favorite').on('click', function(e){
    e.preventDefault();
    e.stopPropagation();
    var userId = $(this).data("user-id");
    var placeId = $(this).data("place-id");
    data = {};
    data["places_user"] = { user_id: userId, place_id: placeId };
    if(userId === "no-user"){
      alert("You must be logged in to add to your wishlist!");
    } else if ($(this).data("liked") === false) {
      $.ajax({
        type: "POST",
        url: '/places_users/create',
        data: data,
        success: console.log('LIKE SAVED')
      });
      $(this).text("Remove from wishlist");
      $(this).data("liked", true);
    } else if ($(this).data("liked") === true) {
      $.ajax({
        type: "POST",
        _method: 'delete',
        url: '/places_users/destroy',
        data: data,
        success: console.log('LIKE DELETED')
      });
      $(this).text("Add to wishlist");
      $(this).data("liked", false);
    }
  });
}

function placeMap(){
  if(document.getElementById('map')){
    var getPlaceDetails = function(place){
      var map = new google.maps.Map(document.getElementById('map'), {
        center: new google.maps.LatLng($('.area-content').data('lat'), $('.area-content').data('long')),
        zoom: 13

      });

      var location = {
              "lat" : $('.area-content').data('lat'),
              "lng" : $('.area-content').data('long')
           };

      var marker = new google.maps.Marker({
        map: map,
        position: location
      });

      var service = new google.maps.places.PlacesService(map);
      var request = {
        placeId: place
      };
      service.getDetails(request, function(place, status) {
        if (status == google.maps.places.PlacesServiceStatus.OK) {
          console.log(place);
          var i;
          var day = new Date();
          if (place.opening_hours){
            var openingHours = place.opening_hours.weekday_text;
          }
          if (openingHours){
            $('#hours').html("Hours:  ")
            var placeInfo = "";
            for(i = 0; i < openingHours.length; i++) {
              if (day.getDay() === i && place.opening_hours.open_now === true) {
                placeInfo += openingHours[i] + "<span id='open-now'>&nbsp;&nbsp;Open Now</span><br>"
              } else {
                placeInfo += openingHours[i] + "<br>";
              }
            }
          }

          if (placeInfo){
            $('#operating-hours').html(placeInfo);
          }

        }
      });
    };

    getPlaceDetails($('#place-id').data("place"));

  }
}

function setUpLoadMore() {
    
      var sec_card = $("section.cards")

      $.each(sec_card, function(index, val) {
        
        var  cards = $(val).find(".card")
             btn = $(val).find(".load-more")
      
        if (cards.length > 3) {
            cards.slice(-3).hide();
            btn.click(function() {
                cards.slice(-3).show();
                btn.remove();
              });
        }else{
            btn.remove();
        }
    });
      var content = $(".review-content");
      content.css("cursor","pointer");
      $.each(content, function(index, val){
           $(val).click(function() {
            $(this).find(".full-text").show();
            $(this).find(".some-text").hide();
            // alert("asd");
          });
      });

}

$(document).ready(function() {
   placeMap();
   addToFav();
   setUpLoadMore(); 
});