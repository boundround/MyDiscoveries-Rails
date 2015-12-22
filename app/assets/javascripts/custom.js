function setUpGmaps(){
   // map = new GMaps({
   //          el: '#br15_map',
   //          lat: -33.7985209,
   //          lng: 151.2861201,
   //          zoomControl : true,
   //          zoomControlOpt: {
   //              style : 'SMALL',
   //              position: 'TOP_LEFT'
   //          },
   //          panControl : false,
   //          streetViewControl : true,
   //          mapTypeControl: false,
   //          overviewMapControl: false,

   //          click:function(){
   //              map.hideInfoWindows();
   //          },
   //          styles:[ { "featureType": "water", "stylers": [ { "color": "#ace1f6" } ] },{ "featureType": "landscape", "stylers": [ { "color": "#f9f5ed" } ] },{ } ]

   //      });
   //      map.removeMarkers();
   //      map.addMarker({
   //          lat: -33.7985209,
   //          lng: 151.2861201,
   //          icon: "/assets/pin.png",
   //          animation: google.maps.Animation.DROP,
   //          infoWindow: {
   //              content: "<div class='br15_marker'> <div class='br15_marker_round'><img src='/assets/insta.jpg' alt=''></div><h4>W<span>ater</span> P<span>ark</span><br><i class='fa fa-star'></i><i class='fa fa-star'></i><i class='fa fa-star'></i><i class='fa fa-star'></i><i class='fa fa-star'></i></h4><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse imperdiet interdum tortor et finibus. Maecenas in metus augue. Praesent maximus arcu tempus.</p></div>"
   //          },
   //          click: function(e){
   //              setTimeout(function(){
   //                  $("img[src='http://maps.gstatic.com/mapfiles/api-3/images/mapcnt6.png']").hide();
   //              },200);

   //          }
   //      });


}

function setUpCarosul(){
        $("#br15_owl_reviews,#br15_owl_fun_facts,#br15_owl_good").owlCarousel({
            items:1,
            itemsDesktopSmall:[1199,1],
            itemsTablet:[768,1],
            itemsMobile:[500,1],
            navigation:true,
            pagination:false,
            navigationText: [
                "<i class='fa fa-chevron-left'></i>",
                "<i class='fa fa-chevron-right'></i>"
            ]

        });
        $("#br15_owl_famous").owlCarousel({
            items:3,
            // itemsDesktopSmall:[1199,3],
            itemsDesktopSmall:[1199,3],
            itemsTablet:[992,2],
            itemsTabletSmall:[768,2],
            itemsMobile:[640,1],
            pagination:false,
            navigation : true,
            navigationText: [
                "<i class='fa fa-chevron-left'></i>",
                "<i class='fa fa-chevron-right'></i>"
            ]
        });

        $("#br15_owl_video,#br15_owl_nearby,#br15_owl_similar").owlCarousel({
            items:3,
            itemsDesktopSmall:[1199,3],
            itemsTablet:[768,2],
            itemsMobile:[500,1],
            navigation:true,
            pagination:false,
            navigationText: [
                "<i class='fa fa-chevron-left'></i>",
                "<i class='fa fa-chevron-right'></i>"
            ]

        });
        $("#br15_owl_photos").owlCarousel({
            items:3,
            itemsDesktopSmall:[1199,3],
            itemsTablet:[768,2],
            itemsMobile:[500,1],
            navigation:true,
            pagination:false,
            navigationText: [
                "<i class='fa fa-chevron-left'></i>",
                "<i class='fa fa-chevron-right'></i>"
            ]
        });
        $('.br15_instagram,.br15_leaderboard,.br15_reviews,.br15_blog .row .col-sm-6,.br15_about,.br15_about_sidebar ').matchHeight();
    }

function responsiveHomeVideo() {

_rowVideo   = $('#rowVideo');
_vdo        = $('#home-background-video');
_window     = $(window).width();
_videoWidth = _vdo.width();
_videoHeight = _vdo.height();

marginLR = 0;
marginTB = 0;

  if (_videoWidth > _window) {
      tmpmargin = _videoWidth -_window;
      marginLR = tmpmargin/2;
  }
  if (_videoHeight > 392) {
      tmpmarginheight = _videoHeight - 392;
      marginTB = tmpmarginheight/2;
  }

    // _vdo.css({"top":-marginTB})  

}
function modalCarosul(){

  $('.br15_img_round_cont.for-img-famous-modal').on('click', function(){

        var carouselItems = $('.carousel-item');
        $('.owl-controls').show();
        if ($("#content-modal-carousel").has(".carousel-item").length === 0) {
            $.each(carouselItems, function(index){
                var newImage = $(carouselItems[index]).clone()
                // if($(carouselItems[index]).hasClass("carousel-video")){
                //     newImage.removeAttr('id');
                //     var a = $(carouselItems[index]).parent().find('.overlay').find('.carousel-like-icon')[0];
                //     var b = $(a).clone();
                //     console.log(b);
                //     videoID = 'big-player-' + index;
                //     newImage.attr('id', videoID).addClass('carousel-big-video');
                //     $("#content-modal-carousel").append(newImage.css("height", "400px"));
                //     newImage.wrap("<div></div>").after(b.css("top", "20px"));
                // } else {
                    $(newImage).css("height", "100%");
                    // newImage.find('.carousel-like-icon').css("right", "auto");
                    // newImage.append("<h2>" + newImage.find("img").data("caption") + "</h2>");
                    // newImage.append("<div><a href='" + newImage.find("img").data("placeurl") + "'>Explore " + newImage.find("img").data("placename") + "</a></div>");
                    // newImage.append("<h4>"+ newImage.find("img").data("description") + "</h4>");
                    $("#content-modal-carousel").append(newImage);
                // }//ifelse
                // <h2 class="text-center"><%= famous_face.name %></h2>
                //             <h4><%= famous_face.description %></h4>
            });
        }
        // alert($(this+' img').data("slide-number"));
    $('#carousel-modal').modal("show");
        $("#content-modal-carousel").owlCarousel({
            items: 1,
            autoPlay: false,
            singleItem:true,
            stopOnHover:true,
            pagination:false,
            navigation: true
        });

        var owl = $("#content-modal-carousel").data('owlCarousel');
        owl.jumpTo($(this).data("slide-number"));
    });
}

function modalvideo(){

    $("#video-modal iframe").prop("src","")
    
    if ($(window).width() <= 320){
          $("#video-modal iframe").prop("height", "200")
        }
    
    
    $(".embed-responsive.embed-responsive-16by9.for-video-modal").on('click', function(){
    // console.log("klik")
    $("#video-modal iframe").prop("src","")
    data_src = $(this).data("src");
    $("#video-modal iframe").prop("src", data_src)
    $("#video-modal").modal("show");
    });

}

$(window).resize(function(){
  responsiveHomeVideo()
    if ($(window).width() <= 320){
       $("#video-modal iframe").prop("height", "200")
      }
})


$(document).ready(function(){
  responsiveHomeVideo()
  setUpCarosul()
  modalCarosul()
  modalvideo()
})