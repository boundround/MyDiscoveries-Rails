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
          dots: true,
          slidesToShow: 1,
          slidesToScroll: 1,
          infinite: true
        }
      }
    ]
  });
});
