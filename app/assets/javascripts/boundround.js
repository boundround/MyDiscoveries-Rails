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
function getThumbnail(){
  var video = $("video.play-in-modal");
  		if (video.length > 0 ) {
	      	$.each(video, function(key, value){
	      	var id = $(value).data("id")
	        if ( $(value).data("video") == "youtube" &&  $(value).attr("poster") == "" ) {
	        	$(value).prop("poster", "http://img.youtube.com/vi/"+id+"/maxresdefault.jpg")
	        }else if ( $(value).data("video") == "vimeo" &&  $(value).attr("poster") == "" ){
        	var url = "https://vimeo.com/api/oembed.json?url=https%3A//vimeo.com/"+id;
        	 $.getJSON( url, function( data ) {
	        	$(value).prop("poster", data.thumbnail_url);
		      });

	        }
        });
	}
}

$(document).ready(function() {
	getThumbnail();
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

	if (document.getElementById('icon')){
		var lon = $('.area-content').data('long');
		var lat = $('.area-content').data('lat');

			$.ajax({
	 			url: "https://api.forecast.io/forecast/c652be9c98a1353375baff9c36ba0787/" + lat + "," + lon,
	 			dataType: 'jsonp',
	 			success: function(data){
	   		console.log(data);
	   		var farenheit = data.currently.temperature;
	   		var temperature = Math.round((farenheit - 32) * 5/9);
	   		var iconString = data.currently.icon;
	   		icon = "/assets/images/" + iconString+ ".png"; // source
	   		$('#temperature').append(temperature + "&deg; C"); // append to DOM #ID temperature
	   		document.getElementById("icon").src = icon; // JavaScript change img src
	 		}
		});
	}

	function setAvatarPosition(){
		var img = $(".img-rounded.edit-profile img");
		// var img = $(".img-rounded.edit-profile img")
		$.each(img, function(index, val) {
			setTimeout(function(){
			if ($(val).height() < 200 ) {
				$(val).css({"height":"200px", "max-width":"initial"});
				// alert("height<200");
			}
			}, 500);

			setTimeout(function(){

			if ($(val).width() > 200 ) {
				width = $(val).width();
				// console.log(width);
				width_plus = width-200;
				// console.log(width_plus);
				margin = width_plus / 2;
				// console.log(-margin);
				$(val).css({"left":-margin});
				// alert("width>200");
			}
			}, 500);
		});
	}

	var title_editable = new MediumEditor('.title-editable', {
		    																	placeholder: {
		    																		text:'Title'
	   		 																	}
		     // align: 'center'
	});

	// title_editable.trigger('editableClick', function(data, editable){
	// 	console.log(data);
	// 	alert("klk");
	// 	console.log(editable);
	// 	// console.log();

	// });
	// title_editable.setContent("p", function(){
	// 	alert("asd");
	// });


	var content_editable = new MediumEditor('.content-editable', {
		    																		placeholder: {
		    																			text:'Tell your story',
	    																			},
	        																	autoLink: true
	});

	$(function() {
		 $('.title-editable').mediumInsert({
		        								editor: title_editable,
		        								addons:{
			        								images: {
		            								deleteScript: '/users/resolvejs',
		            									fileUploadOptions: {
		                								url: '/users/resolvejs',
		                								acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
		            									},
			        								}
		    									}
			});

	    $('.content-editable').mediumInsert({
	        editor: content_editable,
	         				addons:{
			        			images: {
		            			deleteScript: '/users/resolvejs',
		            			fileUploadOptions: {
		                	// url: '/users/'+ $("#user_id").data("id") +'/new_story',
		                	url: '/users/resolvejs',
		                	acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
		            			}
		            		}
			     				}
	    });
	});

	$("#submit_story").click(function(event) {
		var title = $(".title-editable")
		content = $(".content-editable")
		// if ( title.find("p").text() == "" ) {
			// alert("Title can't be blank");
		// 	}else{
		$("#story_title").val(title.html());
		// }

		// if ( content.find("p").text() == "" ) {
		// 	alert("Content can't be blank");
		// }else{
		$("#story_content").val(content.html());
		// }

		// if ( title.find("p").text() != "" &&  content.find("p").text() != "" ) {
		// };
			$("#submit-form-story").click();
	});

	$(".medium-editor-action").click(function(event){
 		setDefaultText();
	});

	setTimeout(function(){
	//
		setDefaultText()
		}, 1000);
		// $(".title-editable p").replaceWith("<h2></h2>")

	function edit_story(){
		var title = $(".title-editable");
		content = $(".content-editable");

		title.html( $("#story_title").val());
		content.html( $("#story_content").val() );
	}

	function setDefaultText(){
		if($(".title-editable p").length != 0){
	  	text = $(".title-editable p").text();
  		if(text == ""){
  			$(".title-editable p").replaceWith("<h2><br></h2>");
  		} else {
  			$(".title-editable p").replaceWith("<h2>"+text+"</h2>");
  			var sel = window.getSelection();
  			sel.removeAllRanges();
  		}
		}
	}

	function set_default_editor(){
		var title = $(".title-editable");
		content = $(".content-editable");
		// if (title[0]) {};
	}

	function update_story(){
		var title = $(".title-editable");
		content = $(".content-editable");

		title.html( $("#story_title").val());
		content.html( $("#story_content").val());

		$("#story_title").val("");
		$("#story_content").val("");
	}

	$(function(){
		$("#form_change_password").submit(function(e) {
			e.preventDefault();
			var data_input = $(this).serialize();
			// console.log(data_input);
			$.ajax({
				url: '/update_password_user',
				type: 'post',
				dataType: 'json',
				data: data_input,
			})
			.done(function(data) {
				if (data.success == true) {
	        success = "<div class='alert alert-success alert-dismissible' role='alert'>"
					              +"<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>"
					              +"Succes to change password"
					            +"</div>";
	        $("#messages-devise").append(success);
	        $("#form_change_password input").val("");
				} else {
					error = "<div class='alert alert-warning alert-dismissible' role='alert'>"
		              	+"<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>"
		                + data.messages
		                + "</div>"
		      $("#messages-devise").append(error);
		      $("#form_change_password input").val("");
				}
			// console.log("success");
			// console.log(data);
			})
			.fail(function(data) {
				console.log("error");
				// console.log(data.status);
				// console.log(data);
				// console.log(data.responseText);
			});
			// .always(function() {
			// 	console.log("complete");
			// });
		});
	});

	function avatarUpload(){
		$(".img-rounded.edit-profile").mouseover(function() {
			$(".avatar-text").show();
		});
		$(".img-rounded.edit-profile").mouseleave(function() {
			$(".avatar-text").hide();
		});
		$(".img-rounded.edit-profile").click(function(event) {
			$("#user_avatar").click();
		});

		$('#avatar-upload').fileupload({
			// dataType: 'json',
		  add: function (e, data) {
		    // console.log(e);
		    // console.log(data);
		    $(".avatar-img").hide();
		    $(".avatar-text").text("Click to change your avatar");
		    $("#submit-upload").click(function(event) {
					data.submit();
		    });

		    if (data.files && data.files[0]) {
			    var reader = new FileReader();
			    reader.onload = function (e) {
			      $('#image-avatar-preview').show().attr('src', e.target.result);
			    }
			    reader.readAsDataURL(data.files[0]);
		    }

		    setAvatarPosition();
		  } //add
		});
	}

	avatarUpload();
	setAvatarPosition();

});

$(window).resize(function() {
	setImagesPosition();
});

$(function () {
	$('[data-toggle="tooltip"]').tooltip()
})
