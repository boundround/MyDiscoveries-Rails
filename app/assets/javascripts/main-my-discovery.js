$(document).ready(function() {
    if ($('select').length) {
        // $('select').select2();
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
                arrows: true,
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

    $('#change-location, #change-location2').click(function(){
        $('#up-my-settings').attr('aria-hidden', false).css('display','block');
        $('#up-my-dashboard').attr('aria-hidden', true).css('display','none');

        $('.ui-state-default').removeClass('ui-tabs-active ui-state-active');
        $('.up-my-settings-link').addClass('ui-tabs-active ui-state-active');
    })

    $('.up-my-content-link, .up-bucket-list-link, .up-my-bookings-link, .up-my-dashboard-link').click(function(){
        $('#up-my-settings').attr('aria-hidden', true).css('display','none');

        if($(this).hasClass("up-my-dashboard-link")){
            $('#up-my-dashboard').attr('aria-hidden', false).css('display','block');
            $('.ui-state-default').removeClass('ui-tabs-active ui-state-active');
            $('.up-my-dashboard-link').addClass('ui-tabs-active ui-state-active');
        }

        if($('#up-my-settings').attr('aria-hidden') == "false"){
            $('.ui-state-default').removeClass('ui-tabs-active ui-state-active');
            $('.up-my-settings-link').addClass('ui-tabs-active ui-state-active');
        }else{
            $('.up-my-settings-link').removeClass('ui-tabs-active ui-state-active');
        }
    })
});
