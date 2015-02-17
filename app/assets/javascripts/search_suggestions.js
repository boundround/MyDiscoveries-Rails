window.onload = function() {
  var userIP = $('#user-ip').data('ip');
  var userCity = '';
  var userCountry = '';

  var resultSource = '';
  var iOS = ( navigator.userAgent.match(/(iPad|iPhone|iPod)/g) ? true : false );

  $.ajax({
    url: 'http://freegeoip.net/json/' + userIP,
    success: function(data) {
      userCity = data.city;
      userCountry = data.country_name;
    }
  });

  $('.search-box').autocomplete({
    autoFocus: true,
    //source: "/search_suggestions.json?term=" + request.term
    source: function( request, response ) {
      $.ajax({
        url: '/sm/search?types[]=place&types[]=area&limit=100&term=' + request.term,
        success: function( data ) {
          console.log("DATA");
          console.log(data);
          data = data.results.area.concat(data.results.place);
          if ( data.length >= 1 ) {
            response( $.map( data, function( item ) {
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
                resultType: 'place',
                placeId: item.slug,
                url: item.url
              }
            }));
          } else {
            geoNamesSearch(request, response);
          }
        }
      });

      var geoNamesSearch = function(request, response) {
        $.ajax({
          url: "http://ws.geonames.org/searchJSON?username=boundround",
          dataType: "jsonp",
          data: {
            featureClass: "S",
            style: "full",
            maxRows: 12,
            name_startsWith: request.term
          },
          success: function( data ) {
            response( $.map( data.geonames, function( item ) {
              return {
                label: item.name + (item.adminName1 ? ", " + item.adminName1 : "") + ", " + item.countryName,
                value: item.name,
                lat: item.lat,
                lng: item.lng,
                resultType: 'geoNames'
              }
            }));
          }
        });
      }

    },
    minLength: 2,
    select: function( event, ui ) {

      if (ui.item.resultType !== "geoNames")
        window.location = ui.item.url;

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

    $('#slideout-menu-toggle').on('click', function(event){
      event.preventDefault();
      window.scrollTo(0,0);
      // create menu variables
      var slideoutMenu = $('.slideout-menu');
      var slideoutMenuWidth = $('.slideout-menu').width();

      // toggle open class
      slideoutMenu.toggleClass("open");

      // slide menu
      if (slideoutMenu.hasClass("open")) {
        slideoutMenu.animate({
          left: "0px"
        });
      } else {
        slideoutMenu.animate({
          left: -slideoutMenuWidth
        }, 250);
      }
    });
}

