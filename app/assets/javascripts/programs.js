$(document).ready(function () {
    $(".navbar-toggle").on("click", function () {
        $(this).toggleClass("active");
    });
});

$(window).load(function(){
    setTimeout(function(){
       $('.loader-container').fadeOut(800);
   },1000);
})

window.onload = function() {
	
	$('#program-search-box').autocomplete({
	  autoFocus: true,
	//  source: "/search_suggestions.json?term=" + request.term
//		source : ["billy","joe","bob","larry"],
	  source: function( request, response ) {
	    $.ajax({
	        url: '/sm/search?types[]=program&limit=100&term=' + request.term,
	//      url: '/sm/search?types[]=place&types[]=area&limit=100&term=' + request.term,
	      success: function( data ) {
	        var data = $.map(data.results.area.concat(data.results.place), function( item ) {
	          var areaDisplay = null;
	          if (item.hasOwnProperty('area')) {
	            if (item.area.display_name == item.area.country) {
	              areaDisplay = item.area.display_name;
	            } else {
	              areaDisplay = item.area.display_name + ", " + item.area.country;
	            };
	          };

	          if (item.hasOwnProperty('country')) {
	            areaDisplay = item.country ? item.country : "";
	          }

	          return {
	            label: item.display_name + (areaDisplay ? ", " + areaDisplay : ""),
	            value: item.display_name,
	            lat: item.latitude,
	            lng: item.longitude,
	            resultType: item.placeType,
	            place_id: item.slug
	          }
	        });

	        if ( data.length >= 1 ) {
	          response(data);
	        }
				
	        $('.program-search-box-button').on('click', function(){
	          $('#program-search-box').data('ui-autocomplete')._trigger('select', 'autocompleteselect', {item: data[0]});
	        });
	      }
	    });
	  },
	  minLength: 2,
	  select: function( event, ui ) {
	    $.ajax({
	      type: "POST",
	      url: '/searchqueries/create',
	      data: {search_query: {
	        term: this.value,
	        source: ui.item.resultType,
	        city: userCity,
	        country: userCountry
	      }},
	      success: console.log('saved: ' + ui.item.label)
	    });

	  },
	  open: function() {
	    $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
	  },
	  close: function() {
	    $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
	  }
	});
	
    $('.btn-log').click(function () {


        $('.nav_button').children('ul').hide(0);
        setTimeout(function(){
            if ($('.left_login .dropdown').hasClass('open')) {

               $('.left_login').addClass('top100');
           }
           else{
            $('.left_login').removeClass('top100'); 
        }  
    },5)


    });
    $('.nav_button button').click(function () {

        $('.nav_button').toggleClass('top100');
        $('.left_login').children('ul').hide(0);
        $('.left_login .login').css('z-index','5'); 
        $('.left_login').removeClass('top100');        

    });
    $('.left_login .dropdown-menu').on({
        "click":function(e){
          e.stopPropagation();
      }
  });


	$('.selectpicker').selectpicker();

	$('.open-btn').click(function(e){
	    e.preventDefault();
	    $(this).hide(0);
	    $('.story_area').stop().slideToggle(400);
	    $('.close-btn').show(0);
	});

	$('.close-btn').click(function(e){
	   e.preventDefault();
	  $(this).hide(0);
	  $('.story_area').stop().slideToggle(400);

	  $('.open-btn').show();
	});


  $(".btn-bg a:nth-child(1)").click(function(e){
    e.preventDefault();
	  $(this).addClass("active-btn");    
	  $(".btn-bg a:nth-child(2)").removeClass('active-btn');
  });

  $(".btn-bg a:nth-child(2)").click(function(e){
    e.preventDefault();
	  $(this).addClass("active-btn");    
	  $(".btn-bg a:nth-child(1)").removeClass('active-btn');
  });
};
