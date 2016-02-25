console.log("init.js");
$(document).ready(function(){

	"use strict";





	// Preloader
    $( window ).load(function() {
	    $(".preloader-wrap").fadeOut(4200);
   		$("#preloader").delay(3000).fadeOut(1600);
    });





	// Initialise MailChimp
	$('#mc-form').ajaxChimp({

    	language: 'en',

    	callback: mailChimpResponse,

    	// ADD YOUR MAILCHIMP URL BELOW HERE!
	    url: 'http://boundround.us2.list-manage.com/subscribe/post?u=6051712f456110a147312e3c9&amp;id=d9ce55c051'

	});
	function mailChimpResponse(resp) {

	    if (resp.result === 'success') {
	    	$('.mailchimp-success').html('' + resp.msg).fadeIn(900);
	        $('.mailchimp-error').fadeOut(400);

	    } else if(resp.result === 'error') {
	        $('.mailchimp-error').html('' + resp.msg).fadeIn(900);
	    }
	}
	// Mailchimp end





	// Create launch date for ticker
    $(function () {

	    "use strict";

	    // Date below denotes 23 April, 2015
	    var launchDay = new Date(2015, 4-1, 23);
	    $('#ticker').countdown({
	    	until: launchDay,
	    	layout: '<div class="col-sm-6 col-md-3"><div class="counter-bg"><div class="counter-inner"><span class="count-digit">{dn}</span><span class="count-text">{dl}</span></div></div></div><div class="col-sm-6 col-md-3"><div class="counter-bg"><div class="counter-inner"><span class="count-digit">{hn}</span><span class="count-text">{hl}</span></div></div></div><div class="col-sm-6 col-md-3"><div class="counter-bg"><div class="counter-inner"><span class="count-digit">{mn}</span><span class="count-text">{ml}</span></div></div></div><div class="col-sm-6 col-md-3"><div class="counter-bg"><div class="counter-inner"><span class="count-digit">{sn}</span><span class="count-text">{sl}</span></div></div></div>'
	    });
    });
    // Countdown end





    // Full screen header
	$(function(){

		"use strict";

		var winHeight = $(window).height();
		var winWidth = $(window).width();

		if (winWidth > 979) {
			$('.intro').css({
				'height': winHeight,
			});
			} else{
			$('.intro').css({
				'height': '536px'
			});
		};

		$(window).resize(function(){
			var winHeight = $(window).height();
			var winWidth = $(window).width();

			if (winWidth > 979) {
				$('.intro').css({
					'height': winHeight
				});
				} else{
				$('.intro').css({
					'height': '536px'
				});
			};
		});
	});
	// Full screen header end





	// Initiate smooth scroll
	$(function(){

		"use strict";

		smoothScroll.init({
			speed: 700,
			easing: 'easeInOutCubic'
		});
	});
	// Initiate smooth scroll end





	// Initialise WOW
	$(function(){

		"use strict";

		new WOW({
			mobile: false
		}).init();

	});
	// Wow end





	// Placeholder initialise
    $('input, textarea').placeholder();






});
