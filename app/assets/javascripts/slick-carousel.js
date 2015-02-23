$(document).ready(function () {
  console.log('initializing slick');
  $('.slick-carousel').slick({
    settings: "unslick",
    responsive: [
      {
        breakpoint: 4028,
        settings: "unslick"
      },
      {
        breakpoint: 1000,
        settings: {
          arrows: false,
          dots: false,
          slidesToShow: 1,
          slidesToScroll: 1,
          infinite: false
        }
      }
    ]
  });
});

var goToPlacesSlide = function(){
  if ($('.slick-carousel').slick('slickCurrentSlide') == 0){
    $('.slick-carousel').slick('slickGoTo', '1');
  }
}

var goToInfoSlide = function(){
  if ($('.slick-carousel').slick('slickCurrentSlide') == 1){
    $('.slick-carousel').slick('slickGoTo', '0');
  }
}
