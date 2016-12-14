$(document).ready(function() {
  $('.slick-carousel').slick({
    settings: "unslick",
    responsive: [{
      breakpoint: 4028,
      settings: "unslick"
    }, {
      breakpoint: 1000,
      settings: {
        arrows: false,
        dots: false,
        slidesToShow: 1,
        slidesToScroll: 1,
        infinite: false,
        swipe: false
      }
    }]
  });
});

var goToPlacesSlide = function() {
  if ($('.slick-carousel').slick('slickCurrentSlide') === 0) {
    $('.slick-carousel').slick('slickGoTo', '1');
  }
};

var goToInfoSlide = function() {
  if ($('.slick-carousel').slick('slickCurrentSlide') == 1) {
    $('.slick-carousel').slick('slickGoTo', '0');
  }
};

var highlightMobileMenu = function() {
  if ($('body').find('#map').hasClass('slick-active')) {
    $('.home-item').parent().css("background-color", "lightblue");
  } else if ($('body').find('.all-videos').length > 0) {
    $('.videos-item').parent().css("background-color", "lightblue");
  } else if ($('body').find('.all-games').length > 0) {
    $('.games-item').parent().css("background-color", "lightblue");
  } else if ($('body').find('.area-content').length > 0) {
    $('.cards-item').parent().css("background-color", "lightblue");
  }
};

highlightMobileMenu();
