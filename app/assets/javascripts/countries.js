var slider;

$(function() {
  $(".owl-carousel").owlCarousel({
    autoPlay: 2000, //Set AutoPlay to 3 seconds
    items: 3,
    itemsDesktop: [1199, 3],
    itemsDesktopSmall: [979, 2],
    itemsTablet: [767, 3],
    itemsTabletSmall:[540,2],
    itemsMobile: [480, 1],
    stopOnHover:true,
    pagination:false
});
slider= $('.bxslider').bxSlider({
  auto:true,
  pager: false,
  controls:false
});
$('#slider-prev').click(function(e){
        e.preventDefault();
        slider.goToPrevSlide();
    });
$('#slider-next').click(function(e){
        e.preventDefault();
        slider.goToNextSlide();
    });

});


$(function() {
    $('.br_main_content,.br_sidebar').matchHeight();
    $('.selectpicker').selectpicker();


    $(".br_sounds i").click(function(){

      $(this).parent().parent().parent().addClass('br_active');
      $(this).parent().parent().parent().siblings().removeClass('br_active');
    });
    var i=1;
    $('.br_mob_links a').click(function(e){
        e.preventDefault();

        if ($('.br_sidebar').hasClass('hidden-xs')) {
            $('.br_sidebar').removeClass('hidden-xs');
            $('.br_main_content').addClass('hidden-xs');
            $(this).addClass('hidden-xs');
            $(this).siblings().removeClass('hidden-xs');
        }
        else{
            $('.br_sidebar').addClass('hidden-xs');
            $('.br_main_content').removeClass('hidden-xs');
            $(this).addClass('hidden-xs');
            $(this).siblings().removeClass('hidden-xs');
        }
       slider.reloadSlider();

    });
});
