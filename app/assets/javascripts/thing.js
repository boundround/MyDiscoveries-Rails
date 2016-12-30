$(document).ready(function() {
  var mq = window.matchMedia('(max-width:767px');
  var mq991 = window.matchMedia('(max-width:991px');

  var mobileOwlCarouselsCreated = false;

  mq.addListener(function(changed) {
    if (!changed.matches && mobileOwlCarouselsCreated) {
      $(".thing-page .carousel").owlCarousel().trigger('destroy.owl.carousel');
      $(".thing-page .auto-height-carousel").owlCarousel().trigger('destroy.owl.carousel');
      mobileOwlCarouselsCreated = false;
    } else if (changed.matches && !mobileOwlCarouselsCreated) {
      createMobileOwlCarousels();
    }
  });

  mq991.addListener(function(changed) {
    if (!changed.matches) {
      $('#overview-copy').readmore('destroy');
    } else {
      initReadMore();
    }
    $(".mobile-nav-container").sticky('update');
    $(".desktop-sub-nav").sticky('update');
    $(".desktop-booking-container .booking-wrapper").sticky('update');
  });

  function initReadMore() {
    //read more for overview copy
    $('#overview-copy').readmore({
      moreLink: '<div class="hidden-md hidden-lg"><div class="load-more"><a href="#">READ MORE</a></div></div>',
      lessLink: '',
      collapsedHeight: 400
    });
  }

  var createMobileOwlCarousels = function() {
    $(".thing-page .carousel").owlCarousel({
      loop: false,
      items: 1,
      nav: true,
      navText: ["<div class='nav-prev orange'></div>", "<div class='nav-next orange'></div>"]
    });

    $(".thing-page .auto-height-carousel").owlCarousel({
      loop: false,
      items: 1,
      nav: true,
      navText: ["<div class='nav-prev orange'></div>", "<div class='nav-next orange'></div>"],
      autoHeight: true
    });

    mobileOwlCarouselsCreated = true;
  };

  if ($(window).width() < 767) {
    createMobileOwlCarousels();
  }

  if ($(window).width() < 991) {
    initReadMore();
  }

  //init sub nav smooth scrolling
  smoothScroll.init({ offset: 60 });

  $(".mobile-nav-container").sticky({ topSpacing: 0, zIndex: 200 });
  $(".desktop-sub-nav").sticky({ topSpacing: 0, zIndex: 200 });
  $(".desktop-booking-container .booking-wrapper").sticky({ topSpacing: 0, zIndex: 200 });

});
