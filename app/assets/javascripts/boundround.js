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
			$(this).find(".fa-times").show();
		}else{
			$(this).find(".fa-bars").show();
			$(this).find(".fa-times").hide();

		}
	});

	$("#fa-search-nav-xs").click(function(event) {
		$("#menu-nav").hide();
		$("#search-nav").show();
		$(".search-nav-mobile").focus();
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
		if ( inner.height() > outerHeight) {
			margin = inner.height() - outerHeight;
			margin = margin/2;
			$(inner).css({"position":"relative","top":-margin});
		}else{
			$(inner).css({"position":"relative","width":"initial","height":"100%"});
			setTimeout(function(){
				margin = inner.width() - outerWidth;
				margin = margin/2;
				$(inner).css({"left":-margin});
				// console.log(inner.width());
				// console.log(outerWidth);
			}, 1000);
		}
	});

setTimeout(function() {
	var top_outer = $(".top-outer-js");

	$.each(top_outer, function(index, val) {
		 var outerHeight = $(val).height();
		 	 outerWidth = $(val).width();
		 	 inner = $(val).find(".top-inner-js") //image innner outer div
		 	// console.log(inner.height());
		 if ( inner.height() > outerHeight ) {
			 	margin = inner.height() - outerHeight;
				margin = margin/2;
				$(inner).css({"top":-margin});
		 }
	});
	}, 1000);
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
	$("#aStoryModal").click(function() {
		$("#StoryModal").modal();
		$('#TitleStoryModal').hide();
	   $('#PhotoStoryModal').hide();
	   $('#DateStoryModal').hide();
	   $('#AboutStoryModal').hide();
	   $('#AgeBracketModal').hide();
	   $('#FirstNameModal').hide();
	});

	$('#StoryModal').on('shown.bs.modal', function () {
  	$('#myInput').focus()
	// $('#TitleStoryModal').hide();
	// $('#PhotoStoryModal').hide();
	// $('#DateStoryModal').hide();
	// $('#AboutStoryModal').hide();
	// $('#AgeBracketModal').hide();
	// $('#FirstNameModal').hide();
	});

	$(".story").on('click', function() {
	   $('#ContentStoryModal').show();
	   $('#TitleStoryModal').hide();
	   $('#PhotoStoryModal').hide();
	   $('#DateStoryModal').hide();
	   $('#AboutStoryModal').hide();
	   $('#AgeBracketModal').hide();
	   $('#FirstNameModal').hide();
	});

	$(".title-story").on('click', function() {
	   // $('#StoryModal').modal('hide');
		$('#TitleStoryModal').show();
		$('#PhotoStoryModal').hide();
		$('#ContentStoryModal').hide();
		$('#DateStoryModal').hide();
		$('#AboutStoryModal').hide();
		$('#AgeBracketModal').hide();
		$('#FirstNameModal').hide();
	});

	$(".photo-story").on('click', function() {
	   // $('#StoryModal').modal('hide');
		$('#PhotoStoryModal').show();
		$('#TitleStoryModal').hide();
		$('#ContentStoryModal').hide();
		$('#DateStoryModal').hide();
		$('#AboutStoryModal').hide();
		$('#AgeBracketModal').hide();
		$('#FirstNameModal').hide();
	});

	$(".date-story").on('click', function() {
	   // $('#StoryModal').modal('hide');
		$('#DateStoryModal').show();
	    $('#PhotoStoryModal').hide();
		$('#TitleStoryModal').hide();
		$('#ContentStoryModal').hide();
		$('#AboutStoryModal').hide();
		$('#AgeBracketModal').hide();
		$('#FirstNameModal').hide();
	});

	$(".about-story").on('click', function() {
	   // $('#StoryModal').modal('hide');
		$('#AboutStoryModal').show();
		$('#PhotoStoryModal').hide();
		$('#DateStoryModal').hide();
		$('#TitleStoryModal').hide();
		$('#ContentStoryModal').hide();
		$('#AgeBracketModal').hide();
		$('#FirstNameModal').hide();
	});

	$(".agebracket").on('click', function() {
	   // $('#StoryModal').modal('hide');
		$('#AgeBracketModal').show();
		$('#PhotoStoryModal').hide();
		$('#AboutStoryModal').hide();
		$('#DateStoryModal').hide();
		$('#TitleStoryModal').hide();
		$('#ContentStoryModal').hide();
		$('#FirstNameModal').hide();
	});

	$(".firstname").on('click', function() {
	   // $('#StoryModal').modal('hide');
		$('#FirstNameModal').show();
		$('#PhotoStoryModal').hide();
		$('#AgeBracketModal').hide();
		$('#AboutStoryModal').hide();
		$('#DateStoryModal').hide();
		$('#TitleStoryModal').hide();
		$('#ContentStoryModal').hide();
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
function setUpModalUserPhoto(){
	$("#user_photo_path").hide();
	$("#icon-upload").click(function(event) {
		$("#user_photo_path").click();
	});
	$("#image-preview").click(function(event) {
		$("#user_photo_path").click();
	});


}

$(document).ready(function() {
	setUpModal();
	setUpModalUserPhoto();
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

	var lon = $('.area-content').data('long');
	var lat = $('.area-content').data('lat');

		$.ajax({
 			url: "http://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + lon + "&APPID=be7c03a2939edf508c723b0729095bcc",
 			success: function(data){
   		console.log(data);
   		//var name = data.name;
   		//console.log(name);
   		//var icon = data.icon;
   		var temperature = data.main.temp; // not in elms
   		console.log(temperature);
   		var icon = data.weather[0].icon;
   		console.log(icon);
   		$('#temperature').append(temperature); // for the #id to append
      $('#icon').append(icon); // for the #id to append (is an img)
 	}
});


});

$(window).resize(function() {
	setImagesPosition();
});
