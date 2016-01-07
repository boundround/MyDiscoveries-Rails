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
                    $(newImage).css("height", "100%");
                    $("#content-modal-carousel").append(newImage);
            });
        }
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

function responsiveModalVideo(){
    
    var iframe = $("#video-modal iframe");
    // Extra Large Device
    if ($(window).width() >= 5000){
        iframe.prop("width", "100%");
        iframe.prop("height", "1950px");
    }
    else if ( ($(window).width() >= 3000) && ($(window).width() < 5000) ){
        iframe.prop("width", "100%");
        iframe.prop("height", "1550px");
    }
    // Large Device
    else if ( ($(window).width() >= 1920) && ($(window).width() < 3000) ) {
        iframe.prop("width", "100%");
        iframe.prop("height", "830px");
    }
    // Large Device
    else if ( ($(window).width() >= 1024) && ($(window).width() < 1920) ) {
        iframe.prop("width", "920px");
        iframe.prop("height", "525px");
    }
    // Large Device(tablets)
    else if ( ($(window).width() >= 500) && ($(window).width() < 1024) ) {
        iframe.prop("width", "400px");
        iframe.prop("height", "230px");
    } 
    // Small Device
    else if ( ($(window).width() > 415) && ($(window).width() < 500 ) ){
       iframe.prop("width", "320px");
       iframe.prop("height", "180px");
    }
    // Extra Small Device
    else if ($(window).width() <= 414){
       iframe.prop("width", "220px");
       iframe.prop("height", "130px");
    }
}

function modalVideo(){
   $(".close").click(function(){
    $("#video-modal iframe").prop("src","");
   });

  $(".embed-responsive.embed-responsive-16by9.for-video-modal").on('click', function(){
    data_src = $(this).data("src");
    $("#video-modal iframe").prop("src", data_src);
    $("#video-modal").modal("show");
  });
}

function vimeoLoadingThumb(id){    
    var url1 = "https://vimeo.com/api/oembed.json?url=https%3A//vimeo.com/"+id;

    $.getJSON( url1, function( data ) {
      $.each( data, function( key, val ) {
        if(key == "thumbnail_url"){
          $("#vimeo-" + id).attr("src", val);
        }
      });
    });
}
  
function getThumbnail(){
  var vimeo_id = $("img[for='thumb-vimeo']");
  $.each(vimeo_id, function(key, value){
    vimeoLoadingThumb($(value).prop("id").split("-")[1]);
  });
}


$(window).resize(function(){
  responsiveHomeVideo();
  responsiveModalVideo();
});

$(document).ready(function(){
  responsiveHomeVideo();
  setUpCarosul();
  modalCarosul();
  responsiveModalVideo();
  modalVideo();
  getThumbnail();
});