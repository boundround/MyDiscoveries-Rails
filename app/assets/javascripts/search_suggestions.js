window.onload = function() {
  console.log("search-suggestions.js");
  var userIP = $('#user-ip').data('ip');
  var userCity = '';
  var userCountry = '';

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
                }
              }

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
              };
            }));
          } else {
            googlePlaceSearch(request, response);
          }
        }
      });

      var googlePlaceSearch = function(request, response) {
        function initialize() {
          var service = new google.maps.places.AutocompleteService();
          service.getQueryPredictions({ input: request.term }, callback);
        }

        function callback(predictions, status) {
          if (status != google.maps.places.PlacesServiceStatus.OK) {
            alert(status);
            return;
          }
          response( $.map( predictions, function( item ) {
            return {
              label: item.description,
              value: item.description,
              lat: -33.865143,
              lng: 151.2099,
              resultType: 'Google',
              placeId: item.place_id
            }
          }));
        }
        initialize();
      }

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
};
