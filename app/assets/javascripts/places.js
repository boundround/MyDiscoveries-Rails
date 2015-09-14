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

  function fitToDiv(container, element){
    var conHeight = container.height();
    var imgHeight = element.height();
    var gap = (imgHeight - conHeight) / 2;
    element.css("margin-top", (gap/2));
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
    $('a[data-target=#storyModal]').click(function(e){
        e.preventDefault();
         setTimeout(function(){
          $('#storyModal .img-cont').keepRatio({
              ratio: 16/7,
              calculate: 'height' // height or width
              });

        },300);
        setTimeout(function(){
        //$('.mid-cont h1,#storyModal .slider-cont h4').editable();
        //$('#myedit,#editor1').attr('contenteditable','true');
        $('.img-cont').keepRatio({
          ratio: 16/7,
          calculate: 'height' // height or width
          });
           sizer($('.img-cont img'));
           $('.img-cont2').keepRatio({
          ratio: 4/3,
          calculate: 'height' // height or width
          });
           sizer($('.img-cont2 img'));
        },500);
      });

    $('.br_top_right').click(function(e){
        e.preventDefault();
        $(this).toggleClass('active');
        });
    });
})();

$(document).ready(function(){
  if(document.getElementById('place-map-canvas')){
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

    // fill game modal, dropdown for mobile
    $('#place_select_game').change(function() { 
      console.log(this.value);
		 if(this.value !=='ignore')
		 {
       var gameURL = this.value;
       var content = '<iframe width="' + Math.floor($(window).width()*.8) + '" height="' + Math.floor($(window).width()*.6) + '" src="' + gameURL + '" ></iframe>';
       console.log(content);
       $('#game-body').html(content);
			 $('#game-modal').modal('show');
			 $('#place_select_game').val('ignore');
			 $('#place_select_game').change();
		 }
	 });

    // fill game modal, button
    $('.game-icon').on('click', function(){
      console.log($(this).data('game-url'));
      var gameURL = $(this).data('game-url');
      var content = '<iframe width="' + Math.floor($(window).width()*.8) + '" height="' + Math.floor($(window).width()*.6) + '" src="' + gameURL + '" ></iframe>';
//      var content = '<iframe class="place-game" src="' + gameURL + '" ></iframe>';
      $('#game-body').html(content);
      console.log(content);
    })

    $('.carousel-video').bind('click', function() {
      pauseAll();
    });

    var pauseAll = function(){
      $('iframe[src*="vimeo.com"]').each(function () {
         $f(this).api('pause');
       });
    };

    // Add to Wishlist
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
        $('.add-to-wishlist').html('<a href="#" id="place-favorite" data-liked="true" data-place-id="' + placeId + '" data-user-id="' + userId + '">Remove from wishlist</a>');
      } else if ($(this).data("liked") === true) {
        $.ajax({
          type: "POST",
          _method: 'delete',
          url: '/places_users/destroy',
          data: data,
          success: console.log('LIKE DELETED')
        });
        $('.add-to-wishlist').html('<a href="#" id="place-favorite" data-liked="false" data-place-id="' + placeId + '" data-user-id="' + userId + '">Add to wishlist</a>');
      }
    });

    $('.review-radio').on('change', function(){
      $('textarea[name="review[content]"]').text($(this).context.defaultValue);

    });
  }

  $('.br_read_more').on('click', function(e){
      e.preventDefault();
      var title = $(this).data('title');
      var user = $(this).data('user');
      var content = $(this).data('content');
      var image1 = $(this).data('image-0');
      console.log(image1);
      var image2 = $(this).data('image-1');
      var image3 = $(this).data('image-2');
      $('#story-user').html("by " + user);
      $('#story-title').html(title);
      $('#story-content').html(content);
      if (image1)
        $('#storyHeroImage').prepend("<div id='image-1' class='img-cont share story-hero-container'><img src=" + image1 + " class='story-image'></div>");
      if (image2)
        $('#story-image-2a').prepend('<div id="image-2" class="pull-right side-img-cont share"><div class="share-btn"><img src=' + image2 + ' class="story-image"></div></div>');
      if (image3)
        $('#story-image-3a').html("<div id='image-3' class='img-cont2 share z-up'><div class='share-btn'><img src=" + image3 + " class='story-image'></div></div>");

    });

    $('#story-close').on('click', function(){
      $('#image-1').remove();
      $('#image-2').remove();
      $('#image-3').remove();
    });

    $('#story-publish-button').on('click', function(){
      $('#storyModal').modal("hide");
      $('.loader-bound-round').show();
    });

    if (document.getElementById('place-map-canvas')){
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
    }

    $('#email-share').on('click', function(){
      $('#share-form').slideToggle();
    });

    $('.share-this').on('click', function(){
      $('#shareModal').modal('show');
    });

});