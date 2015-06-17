     var slider;
     var slider_n;

     $(document).ready(function() {
     	$(".navbar-toggle").on("click", function() {
     		$(this).toggleClass("active");
     	});

     	$('.carousel').carousel({
     		interval: 6000

     	});

     	$('.rate').click(function() {
     		$(this).toggleClass('filled-star');
     	})

     });

     $(window).load(function() {
     		setTimeout(function() {
     			$('.loader-container').fadeOut(800);
     		}, 1000);
     });


     	//		 $(document).ready(function () {
     	window.onload = function() {

     		alert(yo);
     		slider = $('.bxslider1').bxSlider({
     			minSlides: 2,
     			maxSlides: 3,
     			slideWidth: 200,
     			slideMargin: 12,
     			auto: true,
     			pager: false,
     			controls: false
     		});

     		$('#slider-prev').click(function(e) {
     			e.preventDefault();
     			slider.goToPrevSlide();
     		});

     		$('#slider-next').click(function(e) {
     			e.preventDefault();
     			slider.goToNextSlide();
     		});



     		slider_n = $('.bxslider', $('.model-slider')).bxSlider({
     			minSlides: 1,
     			maxSlides: 4,
     			slideWidth: 250,
     			auto: true,
     			pager: false,
     			controls: false
     		});

     		$('#slider-next2').click(function(e) {
     			e.preventDefault();
     			slider_n.goToNextSlide();
     		});

     		$('#slider-prev2').click(function(e) {
     			e.preventDefault();
     			slider_n.goToPrevSlide();
     		});

     		$('.enquire-modal').click(function(e) {
     			e.preventDefault();
     			$('#myModal').modal('show');
     			setTimeout(function() {
     				slider_n.reloadSlider();
     			}, 400);

     		});

     		$('.modal-header .close').click(function(e) {
     			e.preventDefault();

     			$('#myModal,#myModal2').modal('hide');


     		});


     		$('#datepicker').change(function() {
     			$('#datepicker').datetimepicker('hide');
     		});


     		$('#datepicker').datetimepicker({
     			timepicker: false,
     			format: 'd.m.Y'
     		});

     		$('.selectpicker').selectpicker();

     		$('.rating-box input').change(function() {
     			$('.rating-box').slideUp(400);
     		});

     		$('.btn-log').click(function() {


     			$('.nav_button').children('ul').hide(0);
     			setTimeout(function() {
     				if ($('.left_login .dropdown').hasClass('open')) {

     					$('.left_login').addClass('top100');
     				} else {
     					$('.left_login').removeClass('top100');
     				}
     			}, 5);


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
     	};
