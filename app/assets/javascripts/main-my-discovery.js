$(document).ready(function() {
    if ($('select').length) {
        $('select').select2();
    }

    //Mobile customization
    var isMobile = window.matchMedia("only screen and (max-width: 1200px)");

    if (isMobile.matches) {

        //Region page slider
        if ($('.slick-slider').length) {
            $('.slick-slider').slick();
        }

        //Filter accordion
        if ($('#accordion').length) {
            $("#accordion").accordion({
                collapsible: true,
                heightStyle: "content"
            });
        }
    }

    //Desktop screen customization
    var isScreen = window.matchMedia("only screen and (min-width: 1201px)");

    if (isScreen.matches) {

        //Product page Gallery slider
        if ($('.slider-for').length && $('.slider-nav').length) {
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
                arrows: false
            });
        }

    }

    //Product page accordion
    $("#product-accordion").accordion({
        collapsible: true,
        heightStyle: "content"
    });

    //Product page itinerary tabs

    if ($('#itinerary-tabs').length) {
        $("#itinerary-tabs").tabs({
            active: 0
        });
    }

    //Selection page datepicker
    if ($('#departure-date').length) {
        $("#departure-date").datepicker();
    }


    //User pages page datepicker
    if ($('#up-settings-dob').length) {
        $("#up-settings-dob").datepicker();
    }

    //User pages tabs
    if ($('#up-tabs').length) {
        $("#up-tabs").tabs();
    }

    if ($('#up-mc-tabs').length) {
        $("#up-mc-tabs").tabs();
    }
});
