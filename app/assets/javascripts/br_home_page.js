/* Search & Map Blur Animation code from Xyrin */


//Flags for c9.io to eliminate warnings on global variables not defined in the file
/*global br_show_map_mode */
/*global google */
/*global br_show_map_mode*/
/*global brShowMapMode*/

var br_animation_ease = 'swing'; //'linear' is only other option, 'swing' a little better
var br_animation_time = 400; //400ms seems snappier, not too fast

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
		} else {
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
	$('#home-map-wrapper').click(function() {
		$('#home-map-wrapper').addClass('enabled').removeClass('blur');
	});
	$('.overlay').click(function() {
		$('#home-map-wrapper').addClass('enabled');
	});
	$('.hidden_input').click(brSetSearchView);

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

	function brSetSearchView() {
		$('.carousel-inner .item').removeAttr('style');
		$('.login_bg').slideDown(br_animation_time, br_animation_ease);
		$(".owl_main,.top-middle h1,.login_bg,.bg_slide_area .main_logo_link,footer").slideDown(br_animation_time, br_animation_ease);
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
		$('#home-map-wrapper').addClass('blur');

		setTimeout(function() {

			$(".owl_main,.top-middle h1,.login_bg,.bg_slide_area .main_logo_link,footer").removeAttr('style');
			$('.bg_slide_area,.cover,.top-middle,.login_bg').removeClass('running');
		}, 1000);

		brShowMapMode(false);

		$('.bg_slide_area,.cover,.top-middle,.login_bg').on('click', function(e) {
			brSetMapView(e, this);
		});
	}

	function brSetMapView(e, mycontext) {
		if (e && e.target != mycontext) {
			return;
		}
		if ($('.bg_slide_area,.cover,.top-middle,.login_bg').hasClass('running')) {
			return;
		}
		$('.bg_slide_area,.cover,.top-middle,.login_bg').addClass('running');
		//...do stuff..
		$('.owl_main,.top-middle h1').slideUp(br_animation_time, br_animation_ease);
		$(".bg_slide_area .main_logo_link").slideUp(br_animation_time, br_animation_ease);
		$(".bg_slide_area").animate({
			'height': '100px',
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
		//    $('.bg_slide_area input').addClass('hidden_input');
		var windowHeight = $(window).height();
		if ($(window).width() > 767) {
			windowHeight = windowHeight - 80;
		} else {
			$('footer').slideUp();
		}
		$('#home-map-wrapper').removeClass('blur');
		$('.carousel-inner .item').attr('style', 'min-height:' + windowHeight + 'px');
		brShowMapMode(true);

		$('.bg_slide_area,.cover,.top-middle,.login_bg').off('click');
	}

	$('.bg_slide_area,.cover,.top-middle,.login_bg').on('click', function(e) {
		brSetMapView(e, this);
	});

	if (br_show_map_mode) brSetMapView();
}); //end document ready
