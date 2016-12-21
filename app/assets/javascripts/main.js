﻿$(document).ready(function() {
  var injectSvgs = document.querySelectorAll("img.svg-inject");
  SVGInjector(injectSvgs);

  var placesToGo = $(".places-to-go");
  var placesToGoLink = $("#places-to-go-link");
  var placesToGoCaretActive = placesToGoLink.find("img.active");
  var placesToGoCaretInactive = placesToGoLink.find("img.inactive");

  function showPlacesToGo() {
    placesToGo.removeClass("hide");
    placesToGoLink.parent().addClass("active");
    placesToGoCaretActive.removeClass("hide");
    placesToGoCaretInactive.addClass("hide");
  }

  function hidePlacesToGo() {
    placesToGo.addClass("hide");
    placesToGoLink.parent().removeClass("active");
    placesToGoCaretActive.addClass("hide");
    placesToGoCaretInactive.removeClass("hide");
  }

  placesToGoLink.click(function(event) {
    var parent = $(this).parent();
    if (parent.hasClass("active")) {
      hidePlacesToGo();
    } else {
      showPlacesToGo();
    }
  });

  var searchToggle = $("#search-toggle");
  var searchContainer = $(".search-container");
  var menuSearchResults = $(".mega-menu .search-results");

  function showSearchBox() {
    searchContainer.addClass("show");
  }

  function hideSearchBox() {
    searchContainer.removeClass("show");
    menuSearchResults.addClass("hide");
  }

  searchToggle.click(function(event) {
    if (searchContainer.hasClass("show")) {
      hideSearchBox();
    } else {
      showSearchBox();
    }
  });


  var menuToggle = $(".menu-toggle");
  var menuClosedImg = $("#menu-closed");
  var menuOpenedImg = $("#menu-opened");
  var mobileMenu = $(".mobile-menu");
  var menuDarkBackground = $(".menu-dark-background");

  function closeMenu() {
    menuToggle.removeClass("active");
    menuOpenedImg.addClass("hide");
    menuClosedImg.removeClass("hide");
    mobileMenu.addClass("hide");
    menuDarkBackground.addClass("hide");
  }

  function openMenu() {
    menuToggle.addClass("active");
    menuOpenedImg.removeClass("hide");
    menuClosedImg.addClass("hide");
    mobileMenu.removeClass("hide");
    menuDarkBackground.removeClass("hide");
  }

  menuToggle.click(function(event) {
    if (menuToggle.hasClass("active")) {
      closeMenu();
    } else {
      openMenu();
    }
  });
  var mq = window.matchMedia('(max-width:991px)');

  mq.addListener(function(changed){
    if (!changed.matches) {
      $('.mega-menu .owl-carousel').owlCarousel().trigger('destroy.owl.carousel').removeClass("owl-hidden");
    } else {
      createOwlCarousel();
    }
  });

  var createOwlCarousel = function() {
    $(".mega-menu .owl-carousel").owlCarousel({
      loop:false,
      items: 2,
      nav: true,
      navText: ["<div class='nav-prev'></div>","<div class='nav-next'></div>"],
      autoWidth: true
    });
  };

  if ($(window).width() < 992) {
    createOwlCarousel();
  }
        if($('select').length){
            $('select').select2();
        }

         //Desktop screen customization
        var isScreen = window.matchMedia("only screen and (min-width: 1201px)");

        if(isScreen.matches) {

            //Product page Gallery slider
            if($('.slider-for').length && $('.slider-nav').length) {
                $('.slider-for').slick({
                    slidesToShow: 1,
                    slidesToScroll: 1,
                    arrows: false,
                    fade: true,
                    asNavFor: '.slider-nav'
                });
                $('.slider-nav').slick({
                    slidesToShow: 5,
                    slidesToScroll: 1,
                    asNavFor: '.slider-for',
                    centerMode: true,
                    focusOnSelect: true,
                    centerPadding: 0,
                    arrows:false
                });
            }

        }
        console.log($('.slider-for'));
        
        //Product page accordion
        $( "#product-accordion" ).accordion({
            collapsible: true,
            heightStyle: "content"
        });

        //Product page itinerary tabs

        if($('#itinerary-tabs').length){
            $( "#itinerary-tabs" ).tabs({
                active: 0
            });
        }

        //Selection page datepicker
        if($('#departure-date').length) {
            $( "#departure-date" ).datepicker();
        }


        //User pages page datepicker
        if($('#up-settings-dob').length) {
            $( "#up-settings-dob" ).datepicker();
        }

        //User pages tabs
        if($('#up-tabs').length) {
            $( "#up-tabs" ).tabs();
        }

        if($('#up-mc-tabs').length) {
            $( "#up-mc-tabs" ).tabs();
        }
});