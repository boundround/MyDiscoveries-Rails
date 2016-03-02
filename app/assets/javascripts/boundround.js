// Setup chart
function setUpChart(){
	if ( ($("#chart-area").length ) || ($("#chart-area2").length) ){
		var ctx = $("#chart-area")[0].getContext("2d");

		window.myDoughnut = new Chart(ctx).Doughnut(doughnutData, {responsive : true});

		var ctx2 = $("#chart-area2")[0].getContext("2d");
		window.myDoughnut = new Chart(ctx2).Doughnut(doughnutData2, {responsive : true});
	}
}
var doughnutData = [
		{
			value: 300,
			color:"#F7464A",
			highlight: "#FF5A5E",
			label: "Red"
		},
		{
			value: 50,
			color: "#46BFBD",
			highlight: "#5AD3D1",
			label: "Green"
		},
		{
			value: 100,
			color: "#FDB45C",
			highlight: "#FFC870",
			label: "Yellow"
		},
		{
			value: 40,
			color: "#949FB1",
			highlight: "#A8B3C5",
			label: "Grey"
		},
		{
			value: 120,
			color: "#4D5360",
			highlight: "#616774",
			label: "Dark Grey"
		}

	];
	var doughnutData2 = [
		{
			value: 300,
			color:"#F7464A",
			highlight: "#FF5A5E",
			label: "Red"
		},
		{
			value: 50,
			color: "#46BFBD",
			highlight: "#5AD3D1",
			label: "Green"
		},
		{
			value: 100,
			color: "#FDB45C",
			highlight: "#FFC870",
			label: "Yellow"
		},
		{
			value: 40,
			color: "#949FB1",
			highlight: "#A8B3C5",
			label: "Grey"
		},
		{
			value: 120,
			color: "#4D5360",
			highlight: "#616774",
			label: "Dark Grey"
		}

	];
function funFact(){
	var position = $(".position-js");
	$.each(position, function(index, val) {
		 if (index % 2 != 0) {
		 	$(val).find('.fun-image').css({"float":"right","margin":"0"});
		 	$(val).find('.number').css({"left":"89px"});
		 }
	});
	item = $("#carousel-fun-fact").find(".item")[0]
	$(item).addClass("active");
}
function setupNav(){
	$(".navbar-toggle").click(function(){
		if ( $(this).attr("aria-expanded") == "false"){
			$(this).find(".fa-bars").hide();
			$(this).find(".fa-close").show();
		}else{
			$(this).find(".fa-bars").show();
			$(this).find(".fa-close").hide();

		}
	});

	$("#fa-search-nav-xs").click(function(event) {
		$("#menu-nav").hide();
		$("#search-nav").show();
	});
	
	$("#fa-times-nav-xs").click(function(event) {
		$("#search-nav").hide();
		$("#menu-nav").show();
	});
}
function setUpOwlCarousel(){
if ($("#top-owl").length > 0) {
    $("#top-owl").owlCarousel({
      autoPlay: 3000, //Set AutoPlay to 3 seconds
      items : 3,
      // itemsDesktop : [1199,3],
      // itemsDesktopSmall : [979,3]
      // itemsDesktop : [845,3],
      itemsDesktop : [736,3],
      itemsDesktopSmall : [979,3],
      navigation : true,
          navigationText: [
      "<i class='fa fa-arrow-left white'></i>",
      "<i class='fa fa-arrow-right white'></i>"
      ]
  });
}
}
function setImagesPosition(){
	var outer = $(".outer-js"); //div outer image
	// var image = $(".inner-js");
	$.each(outer, function(index, val) {
		var  outerHeight = $(val).height();
			 outerWidth = $(val).width();
			 inner = $(val).find(".inner-js") //image innner outer div
			 // console.log(inner.height());
		if ( inner.height() > outerHeight) {
			// console.log("init outer width "+outerWidth);
			// console.log("init image width "+innerWidth);
			// image > div
			margin = inner.height() - outerHeight;
			margin = margin/2;
			$(inner).css({"position":"relative","top":-margin});
			// console.log(a = $(inner).html());
			// console.log(innerHeight.height());
			// console.log("now outer width "+outerWidth);
			// margin = outerHeight - inner;
			// console.log(margin);
		}else{
			// console.log("no margin");
			// image.css({"height":"100%","width":"initial"});
			// margin = image.width() - outer.width();
			// image.css({"position":"relative","left":-margin});
			// console.log(-margin);
			// console.log( - outer);
			
		}
	});
}
function setUpModal(){
		$('#myModal').on('shown.bs.modal', function () {
		$('#myInput').focus()
		});

 		$(".custom-close-register").on('click', function() {
            $('#myModal').modal('hide');
            $('#myModal9').modal('show');
            $('#myModal10').modal('hide');
            $('#myModal11').modal('hide');
        });

 	    $(".custom-close-login").on('click', function() {
 	        $('#myModal').modal('show');
 	        $('#myModal9').modal('hide');
 	        $('#myModal10').modal('hide');
 	        $('#myModal11').modal('hide');
 	    });

 	    $(".custom-close-register-name").on('click', function() {
 	        $('#myModal10').modal('show');
 	        $('#myModal9').modal('hide');
 	        $('#myModal').modal('hide');
 	        $('#myModal11').modal('hide');
 	    });

 	    $(".custom-close-register-travelling").on('click', function() {
 	        $('#myModal11').modal('show');
 	        $('#myModal9').modal('hide');
 	        $('#myModal').modal('hide');
 	        $('#myModal10').modal('hide');
 	    });


 	    $(".custom-close-start-travelling").on('click', function() {
 	        $('#myModal11').modal('hide');
 	        $('#myModal9').modal('hide');
 	        $('#myModal').modal('hide');
 	        $('#myModal10').modal('hide');
 	    });


 	// alert("test");
}

function setModalOpeningHour(){
  	$('#OpeningHourModal').on('shown.bs.modal', function () {
  	$('#myInput').focus()
	});
}

function setModalTickets(){
  	$('#TicketsModal').on('shown.bs.modal', function () {
  	$('#myInput').focus()
	});
}

function setModalStory(){
	$('#StoryModal').on('shown.bs.modal', function () {
  	$('#myInput').focus()
	});

	$(".story").on('click', function() {
	   $('#StoryModal').modal('show');
	   $('#TitleStoryModal').modal('hide');
	   $('#PhotoStoryModal').modal('hide');
	   $('#DateStoryModal').modal('hide');
	   $('#AboutStoryModal').modal('hide');
	   $('#AgeBracketModal').modal('hide');
	   $('#FirstNameModal').modal('hide');
	});

	$(".title-story").on('click', function() {
	   $('#StoryModal').modal('hide');
	   $('#TitleStoryModal').modal('show');
	});

	$(".photo-story").on('click', function() {
	   $('#StoryModal').modal('hide');
	   $('#PhotoStoryModal').modal('show');
	});

	$(".date-story").on('click', function() {
	   $('#StoryModal').modal('hide');
	   $('#DateStoryModal').modal('show');
	});

	$(".about-story").on('click', function() {
	   $('#StoryModal').modal('hide');
	   $('#AboutStoryModal').modal('show');
	});

	$(".agebracket").on('click', function() {
	   $('#StoryModal').modal('hide');
	   $('#AgeBracketModal').modal('show');
	});

	$(".firstname").on('click', function() {
	   $('#StoryModal').modal('hide');
	   $('#FirstNameModal').modal('show');
	});
}


function setModalBooking(){
	$('#BookingModal').on('shown.bs.modal', function () {
  	$('#myInput').focus()
	});

	$(".booking").on('click', function() {
	   $('#BookingModal').modal('show');
	   $('#TicketBookingModal').modal('hide');
	   $('#PaymentModal').modal('hide');
	});
	$(".ticket-booking").on('click', function() {
	   $('#BookingModal').modal('hide');
	   $('#TicketBookingModal').modal('show');
	});

	$(".payment-booking").on('click', function() {
	   $('#BookingModal').modal('hide');
	   $('#PaymentModal').modal('show');
	});
}

function setModalReview(){
	$('#ReviewModal').on('shown.bs.modal', function () {
  	$('#myInput').focus()
	});
}

function setModalPhoto(){
	$('#PhotoModal').on('shown.bs.modal', function () {
  	$('#myInput').focus()
	});
}

function setModalEditPhoto(){
	$('#EditPhotoModal').on('shown.bs.modal', function () {
  	$('#myInput').focus()
	});

	$(".edit-photo").on('click', function() {
	   $('#EditPhotoModal').modal('hide');
	   $('#EditPhotoDataModal').modal('show');
	});

	$(".back-edit-photo").on('click', function() {
	   $('#EditPhotoModal').modal('show');
	   $('#EditPhotoDataModal').modal('hide');
	});
}

$(window).resize(function() {
	setImagesPosition();
});

$(document).ready(function() {
	setUpModal();
	setModalOpeningHour();
	setModalTickets();
	setModalStory();
	setModalBooking();
	setModalReview();
	setModalPhoto();
	setModalEditPhoto();
	setupNav();
	setUpOwlCarousel();
	setImagesPosition();
	funFact();
	setUpChart();

});