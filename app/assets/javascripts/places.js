(function(){
  var owl;
  function sizer(n){
    n.each(function(){
      var w=$(this).width();
      var contw=$(this).parent().width();
        if(w>contw){
          var a= w-contw;
          var b=a/2;
          $(this).css('left',-b);
        }
        else{
               $(this).css('left','0');
        }

    });
  }
    $(function(){
      $('.br_info_mob').hide();
      $('.br_container_box a.br_Activity_btn.visible-xs').click(function(e){
          e.preventDefault();
          $('.br_info_mob').slideToggle(500);
          });

  owl=$(".br_container_box .owl-carousel").owlCarousel({
      autoPlay: 2000, //Set AutoPlay to 3 seconds
      items: 4,
      itemsDesktop: [1199, 3],
      itemsDesktopSmall: [979, 3],
      itemsTablet: [767, 2],
      itemsTabletSmall:[420,1],
      itemsMobile: [320, 1],
      stopOnHover:true,
      pagination:false,
      afterUpdate: update
  });
  $(".br_top_5_slider .owl-carousel").owlCarousel({
      autoPlay: 2000, //Set AutoPlay to 3 seconds
      items: 5,
      itemsDesktop: [1199, 4],
      itemsDesktopSmall: [980, 3],
      itemsTablet: [767, 3],
      itemsTabletSmall:[600,2],
      itemsMobile: [400, 1],
      stopOnHover:true,
      pagination:false,
      afterUpdate: update
  });
      function update(){

    $('.br_container_box .br_16').keepRatio({
        ratio: 16/9,
        calculate: 'height' // height or width
        });
       sizer($('.br_container_box .br_16>img'));
    }
    $(".owl_next").click(function(){
      owl.trigger('owl.next');
    });
    $(".owl_prev").click(function(){
      owl.trigger('owl.prev');
    });
    setTimeout(function(){
    sizer($('.br_container_box .br_16>img'));
   },500);
    $('.br_container_box .br_16').keepRatio({
        ratio: 16/9,
        calculate: 'height' // height or width
        });

    $('.br_games.selectpicker').selectpicker();
    $('a[data-target=#story]').click(function(e){
        e.preventDefault();
         setTimeout(function(){
          $('#story .img-cont').keepRatio({
              ratio: 16/6,
              calculate: 'height' // height or width
              });

        },300);
      });
    $('.br_top_right').click(function(e){
        e.preventDefault();
        $(this).toggleClass('active');
        });
    });
})();

$(document).ready(function(){
  var getPlaceDetails = function(place){
    var map = new google.maps.Map(document.getElementById('place-map-canvas'), {
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

  // fill game modal
  $('.game-icon').on('click', function(){
    console.log($(this).data('game-url'));
    var gameURL = $(this).data('game-url');
    var content = '<iframe class="place-game" src="' + gameURL + '" ></iframe>';
    console.log(content);
    $('#game-body').html(content);
  })

  $('.carousel-video').bind('click', function() {
    pauseAll();
  });

  var pauseAll = function(){
    $('iframe[src*="vimeo.com"]').each(function () {
       $f(this).api('pause');
     });
  };

});
