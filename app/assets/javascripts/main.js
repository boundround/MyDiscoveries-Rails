$(document).ready(function() {
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
});