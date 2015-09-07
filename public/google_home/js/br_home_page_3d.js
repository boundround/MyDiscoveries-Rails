$(document).ready(function() {

    $("#owl-demo").owlCarousel({

        autoPlay: 3000, //Set AutoPlay to 3 seconds

        items: 3,
        itemsDesktop: [1199, 3],
        itemsDesktopSmall: [979, 2],
        itemsTablet: [767, 3],
        itemsMobile: [480, 2]

    });

});

$(document).ready(function() {
    $(".navbar-toggle").on("click", function() {
        $(this).toggleClass("active");
    });

    $('.carousel').carousel({
        interval: 6000

    });

});

$('.btn-log').click(function() {


    $('.nav_button').children('ul').hide(0);
    setTimeout(function() {
        if ($('.left_login .dropdown').hasClass('open')) {

            $('.left_login').addClass('top100');
        }
        else {
            $('.left_login').removeClass('top100');
        }
    }, 5)


});
$('.nav_button button').click(function() {

    $('.nav_button').toggleClass('top100');
    $('.left_login').children('ul').hide(0);
    $('.left_login .login').css('z-index', '5');
    $('.left_login').removeClass('top100');

});
$('.left_login .dropdown-menu').on({
    "click": function(e) {
        e.stopPropagation();
    }
});


$('.selectpicker').selectpicker();


$(window).load(function() {
    setTimeout(function() {
        $('.loader-container').fadeOut(800);
    }, 1000);

})



$(document).ready(function() {
    $('#map-wrapper').click(function() {
        $('#map-wrapper').addClass('enabled').removeClass('blur');
    });
    $('.overlay').click(function() {
        $('#map-wrapper').addClass('enabled');
    });
    /*
        var mapOptions = {
            center: { lat: 0, lng: 0},
            disableDefaultUI: false,
            zoom: 2,
            minZoom: 2,
            maxZoom: 15,
            mapTypeId: google.maps.MapTypeId.ROADMAP,
            styles:[ 
                        { "featureType": "water", "stylers": [ { "color": "#73C7D1" } ] },
                        { "featureType": "landscape", "stylers": [ { "color": "#F1EEE7" } ] },
                        { } 
                    ]
        };
        map=new google.maps.Map(document.getElementById('map'), mapOptions);*/
    /*
        var ftlayer = new google.maps.FusionTablesLayer({
        query: {
          select: 'geometry',
          from: '1hFMStXgF-FO1dJRzPOyKZuugnKBQDyMOa9oB8_Z8'
        },
            styles: [{
              polygonOptions: {
                fillColor: '#00FF00',
                fillOpacity: 0.3
              }
            }
            ]
        });
        ftlayer.setMap(map);
        
        clayer = new google.maps.FusionTablesLayer({
            query: {
              select: 'location',
              from: '1CLE_PJq43PagTM7fA-DhTqE3BHQL-GUd1cXkz-hc',
              where: "'Status' = 'live'"
            },
            styles: [
    //                {where: "'bizCatSub' = 'Antique & Classic Motorcycle Dealers'", markerOptions:{ iconName:"star"}}, // other landmarks
              {where: "'bizCatSub' = 'Other moto business'", markerOptions:{ iconName:"wht_pushpin"}}, //businesses
              {where: "'bizCatSub' = 'Shop'", markerOptions:{iconName:"red_blank"}}, //town houses
              {where: "'bizCatSub' = '12'", markerOptions:{ iconName:"orange_blank"}}, //country homes
              {where: "'bizCatSub' = '15'", markerOptions:{ iconName:"target"}},
            ]

          });
          clayer.setMap(map);
    */

}); //end document ready

function processPoints(geometry, callback, thisArg) {
    if (geometry instanceof google.maps.LatLng) {
        callback.call(thisArg, geometry);
    }
    else if (geometry instanceof google.maps.Data.Point) {
        callback.call(thisArg, geometry.get());
    }
    else {
        geometry.getArray().forEach(function(g) {
            processPoints(g, callback, thisArg);
        });
    }
}
$('.open-btn').click(function(e) {
    e.preventDefault();
    $(this).hide(0);
    $('.story_area').stop().slideToggle(400);
    $('.close-btn').show(0);
});
$('.close-btn').click(function(e) {
    e.preventDefault();
    $(this).hide(0);
    $('.story_area').stop().slideToggle(400);
    $('.open-btn').show();
});

var br_animation_ease = 'swing';
var br_animation_time = 400;

$('.bg_slide_area,.cover,.top-middle,.login_bg').on('click', function(e) {
    if (e.target != this) {
        return;
    }
    if ($('.bg_slide_area,.cover,.top-middle,.login_bg').hasClass('running')) {
        return;
    }
    $('.bg_slide_area,.cover,.top-middle,.login_bg').addClass('running');
    //...do stuff..
    $('.owl_main,.top-middle h1').slideUp(br_animation_time, br_animation_ease);
    $(".bg_slide_area a[href='index_map.html']").slideUp(br_animation_time, br_animation_ease);
    $(".bg_slide_area").animate({
        'height': '165px',
        'max-width': '604px',
        'margin-left': 'auto',
        'margin-right': 'auto',
        'left': '0px',
        'right': '0px',
        'padding-top': '30px'
    }, br_animation_time, br_animation_ease);
    setTimeout(function() {
        $(".bg_slide_area").css('background', 'transparent')
    }, 1000);
    $('.login_bg + div').removeClass('container');
    $('.login_bg').slideUp();
    $('.bg_slide_area input').addClass('hidden_input');
    var windowHeight = $(window).height();
    if ($(window).width() > 767) {
        windowHeight = windowHeight - 80;
    }
    else {
        $('footer').slideUp();
    }
    $('#map-wrapper').removeClass('blur');
    $('.carousel-inner .item').attr('style', 'min-height:' + windowHeight + 'px');

    $('.hidden_input').click(function() {


        $('.carousel-inner .item').removeAttr('style');
        $('.login_bg').slideDown(br_animation_time, br_animation_ease);
        $(".owl_main,.top-middle h1,.login_bg,.bg_slide_area a[href='index_map.html'],footer").slideDown(br_animation_time, br_animation_ease);
        setTimeout(function() {
            $(".bg_slide_area").css('background', 'transparent');
            $(".bg_slide_area").removeAttr('style')
        }, 200);
        $(".bg_slide_area").stop().animate({
            'height': '100%',
            'max-width': '2500px',
            'left': '0px',
            'right': '0px',
            'padding-top': '0px'
        }, br_animation_time, br_animation_ease);
        $('#map-wrapper').addClass('blur');

        setTimeout(function() {

            $(".owl_main,.top-middle h1,.login_bg,.bg_slide_area a[href='index_map.html'],footer").removeAttr('style');
            $('.bg_slide_area,.cover,.top-middle,.login_bg').removeClass('running');
        }, 1000);


    });
});
