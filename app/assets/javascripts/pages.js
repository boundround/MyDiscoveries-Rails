var formatCategory = function(string) {
  string = string.replace(/\_/g, " ");
  return string = string.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
}

map = L.mapbox.map('map', 'boundround.j0d79a3j', {
  	worldCopyJump: true,
    // these options apply to the tile layer in the map
    tileLayer: {
        // this map option disables world wrapping. by default, it is false.
        continuousWorld: false,
        // this option disables loading tiles outside of the world bounds.
        noWrap: true
      },
      zoomControl: false,
      maxBounds: [[85,-250],[-85,250]],
      minZoom: 2,
      maxZoom: 18
    });

map.on('load', function() {
  location.hash == '' ? location.hash = '#3/-33.865143/151.2099' : location.hash = location.hash;
  window.parsedHash = L.Hash.parseHash(location.hash);
  map.setView(parsedHash.center, parsedHash.zoom);

  /// Switch globe display on
  if (parsedHash.zoom < 4) {
    $('#svgdiv').css('visibility', 'visible');
  };
});


L.control.zoomslider().addTo(map);

// Create leaflet hash object

var hash = L.hash(map);

map.on('zoomend', function() {
  console.log("this mapzoom: " + map.getZoom())
  window.parsedHash = L.Hash.parseHash(location.hash);
  console.log(parsedHash.zoom);
  if (map.getZoom() < transitionzoomlevel){
    $('#svgdiv').css('visibility', 'visible');
    $('#svgdiv').fadeIn("fast");
    var ll = window.previousLocation ? window.previousLocation : map.getCenter();
    if (typeof brglobe != 'undefined') {
      brglobe.setLocation(ll.lat,ll.lng);
       console.log("zoomend 1 fired");
    }
  }
});

map.on('moveend', function(){
  showPlaceCards();
});

var transitionzoomlevel = 4; //2d zoom level transition to globe
var areahidelevel = 7; //zoom level at which area icons that have places are replaced with cluster icons
var areatouchmagnification = 3; //number of levels to zoom when touch area with places

window.placeMarkers = new L.MarkerClusterGroup({showCoverageOnHover: false, maxClusterRadius: 20});
placeMarkers.addTo(map);
window.areaMarkers = new L.MarkerClusterGroup({showCoverageOnHover: false, maxClusterRadius: 20});
areaMarkers.addTo(map);

window.placeLayers = {
  all: [],
  beach: [],
  park: [],
  animals: [],
  sport: [],
  museum: [],
  activity: [],
  theme_park: [],
  sights: [],
  place_to_eat: [],
  place_to_stay: [],
  shopping: [],
};

window.areaLayers = {
  havePlaces: [],
  noPlaces: []
}

var getInboundCategories = function() {
  // Construct an empty object to keep track of onscreen markers.
  inboundCategories = {
    all: true,
    beach: false,
    park: false,
    animals: false,
    sport: false,
    museum: false,
    activity: false,
    theme_park: false,
    sights: false,
    place_to_eat: false,
    place_to_stay: false,
    shopping: false,
  };


  // Get the map bounds - the top-left and bottom-right locations.
  var bounds = map.getBounds();

  // Temporarily add all place markers.
  var tempMarkers = new L.MarkerClusterGroup();
  tempMarkers.addLayers(placeLayers['all']);

  // For each marker, consider whether it is currently visible by comparing
  // with the current map bounds.
  tempMarkers.eachLayer(function(marker) {
      if (bounds.contains(marker.getLatLng())) {
          inboundCategories[marker.options.category] = true;
      }
  });

  // Remove all place markers.
  tempMarkers.clearLayers();

  return inboundCategories;
};

var setFilterButtons = function(inboundCategories) {
  $('#no-places').remove();

  // Temporarily show all buttons.
  $('#menu-ui').find('a').show();

  // Hide filter menu buttons that don't relate to visible markers.
  var shownCategoryButtons = [];
  for (var category in inboundCategories) {
    if( inboundCategories.hasOwnProperty( category ) ) {
      if (inboundCategories[category]) {
        shownCategoryButtons.push(category);
      } else {
        $('a[data-category=' + category + ']').hide();
      }
    }
  }
  if (shownCategoryButtons.length <= 1 ) {
    $('#menu-ui').find('a').hide();
    $('#menu-ui').prepend("<a id='no-places'>No Places</a>");
  }
};

// Change filter menu based on markers visible in current view
map.on('moveend', function(event) {
  if (map.getZoom() >= transitionzoomlevel) {
    setFilterButtons(getInboundCategories());
    areaMarkers.addLayers(window.areaLayers.havePlaces);
    showAreaCards();
    //areaMarkers.removeLayers(window.areaLayers.havePlaces);
  }
});

$('#menu-ui').on('click', 'a', function(e) {
  category = $(this).data('category');
  $(this).siblings().removeClass('active');
  $(this).addClass('active');
  placeMarkers.clearLayers();
  placeMarkers.addLayers(placeLayers[category]);
});

var areaIcon = L.Icon.Label.extend({
                options: {
                  iconUrl: 'http://d1w99recw67lvf.cloudfront.net/category_icons/place-pin.png',
                  shadowUrl: null,
                  iconSize: new L.Point(43, 43),
                  iconAnchor: new L.Point(0, 0),
                  labelAnchor: new L.Point(47, 0),
                  wrapperAnchor: new L.Point(21, 13),
                }
              });

var placeIcon = L.Icon.Label.extend({
                options: {
                  iconUrl: 'http://09f1be2b4e79305414d1-e02ea5f9f7cbf68a786b2624900f7447.r95.cf4.rackcdn.com/icons20140522/Do_generic_yellow_m.png',
                  shadowUrl: null,
                  iconSize: new L.Point(25, 38),
                  iconAnchor: new L.Point(0, 0),
                  labelAnchor: new L.Point(0, 55),
                  wrapperAnchor: new L.Point(0, 0),
                  labelClassName: 'place-icon-label'
                }
              });

//new marker array
var createMarkerArray = function(geoJSON, markerType) {
  var markerArray = [];   

  for (var i = 0; i < geoJSON.features.length; i++) {
    var location = geoJSON.features[i];

    var icon = {
      area: function() {return new areaIcon({ labelText: location.properties.title,
                                              labelClassName: 'area-icon-label' + ' '
                                              + location.properties.places + ' '
                                              + location.properties.id,
                                              url: location.properties.url,
                                              placeCount: location.properties.placeCount,
                                              country: location.properties.country
                                              });},
      place: function() {return new placeIcon({ labelText: location.properties.title,
                                              labelClassName: 'place-icon-label ' + location.properties.id,
                                              iconUrl: location.properties.icon.iconUrl,
                                              url: location.properties.url,
                                              imageCount: location.properties.imageCount,
                                              videoCount: location.properties.videoCount,
                                              gameCount: location.properties.gameCount,
                                              heroImage: location.properties.heroImage,
                                              placeId: location.properties.placeId
                                              });}
    }

    // Only create marker if it has lat and long
    if (location.geometry.coordinates[1] && location.geometry.coordinates[0]) {
      var marker = L.marker(new L.LatLng(location.geometry.coordinates[1], location.geometry.coordinates[0]),
          {icon: icon[markerType](),
           riseOnHover: true,
           riseOffset: 500,
           category: location.properties.category }
      )
      markerArray.push(marker);
      if (markerType == 'place') {
        if (placeLayers[location.properties.category]) {
          window.placeLayers[location.properties.category].push(marker);
        }
      }
      if (markerType == 'area') {
        location.properties.places ? window.areaLayers.havePlaces.push(marker) : window.areaLayers.noPlaces.push(marker);
      }
    };
  };
  if (markerType == 'place') {
    window.placeLayers.all = markerArray;
  }
  return markerArray;
};

//Get all areas and add to map
$.ajax({
  url: '/areas/mapdata.json',
  success: function(data) {
    window.areasGeoJSON = data;
    var areasArray = createMarkerArray(data, 'area');

    areaMarkers.addLayers(window.areaLayers.havePlaces);
    areaMarkers.addLayers(window.areaLayers.noPlaces);

    addMarkersClickEvent(areaMarkers);

    //Get all places and add to map
    $.ajax({
      url: '/places/mapdata.json',
      success: function(data) {
        window.placesGeoJSON = data;
        window.placesArray = createMarkerArray(data, 'place');
        addMarkersClickEvent(placeMarkers);

        areasPlacesSwitch();

        location.hash == "#3/-33.87/102.48" ? location.hash = '#3/-33.865143/151.2099' : location.hash;
        brglobe.setLocation(-33.865, 151.209);
      }
    });

  }
});

var areasPlacesSwitch = function() {
  //switch between areas and places
  map.on('zoomstart', function() {
    window.previousZoom = map.getZoom();
    console.log('previousZoom' + previousZoom);
    window.previousLocation = map.getCenter();
  });
  map.on('zoomend', function() {
    var newZoom = map.getZoom();
    if (previousZoom >= areahidelevel && newZoom < areahidelevel) {
      placeMarkers.removeLayers(placesArray);
      areaMarkers.addLayers(window.areaLayers.havePlaces)
      $('#menu-ui').css("visibility", "hidden");
      showAreaCards();
    } else if (previousZoom < areahidelevel && newZoom >= areahidelevel){
      showAreaCards();
      areaMarkers.removeLayers(window.areaLayers.havePlaces)
      placeMarkers.addLayers(placesArray);
      $('#menu-ui').css("visibility", "visible");
      showPlaceCards();
    }
  });
  if (window.parsedHash && window.parsedHash.zoom > 3) {
    showAreaCards();
    areaMarkers.removeLayers(window.areaLayers.havePlaces)
    placeMarkers.addLayers(placesArray);
    $('#menu-ui').css("visibility", "visible");
    showPlaceCards();
  }
}

var showAreaCards = function(){
  var bounds = map.getBounds();
  var text = '';
  areaMarkers.eachLayer(function(marker) {
    if (bounds.contains(marker.getLatLng())) {
      var url = marker.options.icon.options.url;
      if (marker.options.icon.options.country != marker.options.icon.options.labelText){
        var areaTitle = marker.options.icon.options.labelText + ', ' + marker.options.icon.options.country;
      } else {
        var areaTitle = marker.options.icon.options.labelText
      }
      if (marker.options.icon.options.placeCount > 0) {
        var placeCountText = marker.options.icon.options.placeCount + ' places';
      } else {
        var placeCountText = '&nbsp;';
      }
      var pin = '<div class="area-card-pin"><img src="http://d1w99recw67lvf.cloudfront.net/category_icons/place-pin.png" class="area-pin" alt="map pin"></div>';

      text += '<a class="no-anchor-decoration" href="' + url + '"><div class="area-card">' + pin + '<div class="area-title">' + areaTitle +
        '<br><span class="place-count">' + placeCountText + '</span></div></div></a>';
    }
  });
  $('#areas').html(text);
}

var showPlaceCards = function(){
  var bounds = map.getBounds();
  var text = "";
  placeMarkers.eachLayer(function(marker) {
    if (bounds.contains(marker.getLatLng())) {
      var category = marker.options.category;
      var categoryIcon = "<img src='http://d1w99recw67lvf.cloudfront.net/category_icons/" + marker.options.category + "_icon.png' alt='" + marker.options.category + " icon'>";
      var imageCountIcon = "<img src='http://d1w99recw67lvf.cloudfront.net/category_icons/photos_count.png' height='12px' alt='photo count'>";
      var gameCountIcon = "<img src='http://d1w99recw67lvf.cloudfront.net/category_icons/games_count.png' height='12px' alt='games count'>";
      var videoCountIcon = "<img src='http://d1w99recw67lvf.cloudfront.net/category_icons/videos_count.png' height='12px' alt='videos count'>";
      var categoryText = formatCategory(category);
      var url = marker.options.icon.options.url;
      var heroImage = marker.options.icon.options.heroImage;
      var imageCount = marker.options.icon.options.imageCount;
      var videoCount = marker.options.icon.options.videoCount;
      var gameCount = marker.options.icon.options.gameCount;
      var placeTitle = marker.options.icon.options.labelText;
      var placeId = marker.options.icon.options.placeId;
      text += '<div class="place-card" id="' + placeId + '"><a class="no-anchor-decoration" href="' + url +
      '"><div class="upper-card" style="background-image: url(' + heroImage + ')"><div class="card-category">' +
      categoryIcon + categoryText + '</div></div><p class="place-title ' + category + '">' + placeTitle + '</p><br></a><div class="card-footer">' +
      imageCountIcon + '&nbsp;&nbsp;' + imageCount + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
      videoCountIcon + '&nbsp;&nbsp;' + videoCount + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
      gameCountIcon + '&nbsp;&nbsp;' + gameCount + '</div></div>';
    }
  });
  $('#places').html(text);
}

// Redirect to areas or places on click
var addMarkersClickEvent = function(markers) {
  markers.on('click', function(e) {
    var markerProps = e.layer.options.icon.options.labelClassName.split(" ");
    var url = e.layer.options.icon.options.url;
    var markerType = '';
    markerProps.shift().match(/area/) ? markerType = 'area' :  markerType = 'place';
    var markerID = markerProps.pop();
    var hasPlaces = markerProps.slice(-2)[0] === 'true';
    if (map.getZoom() < areahidelevel ) {
      if (hasPlaces) {
        map.setView([e.latlng.lat, e.latlng.lng], areahidelevel+areatouchmagnification);
      } else {
          // setModalContent(markerType, markerID);
          window.location.href = url
        };
    } else { //if (map.getZoom() >= areahidelevel )
        if (markerType === 'area') {
          // setModalContent(markerType, markerID);
          window.location.href = url
        } else {
          // setModalContent(markerType, markerID);
          window.location.href = url
        };
      };
  });
};

$('.dude-help').on('click', function () {
  $(this).find('.balloon-wrapper').toggleClass('balloon-wrapper-show');
  $(this).toggleClass('dude-help-out');
});


// Search Box

// Save User Location

window.onload = function() {
  var userIP = $('#user-ip').data('ip');
  var userCity = '';
  var userCountry = '';

  var resultSource = '';

  $.ajax({
    url: 'http://freegeoip.net/json/' + userIP,
    success: function(data) {
      userCity = data.city;
      userCountry = data.country_name;
    }
  });

  $('.search-box').autocomplete({
    source: function( request, response ) {
      $.ajax({
        url: '/places/search.json?term=' + request.term,
        success: function( data ) {
          if ( data.length >= 1 ) {
            response( $.map( data, function( item ) {
              var areaDisplay = null;
              if (item.area.display_name) {
                if (item.area.display_name == item.area.country) {
                  areaDisplay = item.area.display_name;
                } else {
                  areaDisplay = item.area.display_name + ", " + item.area.country;
                };
              };

              return {
                label: item.display_name + (areaDisplay ? ", " + areaDisplay : ""),
                value: item.display_name,
                lat: item.latitude,
                lng: item.longitude,
                resultType: 'place',
                placeId: item.slug
              }
            }));
          } else {
            autoCompleteAreaSearch(request, response);
          }
        }
      });

      var autoCompleteAreaSearch = function(request, response) {
        $.ajax({
          url: '/areas/search.json?term=' + request.term,
          success: function( data ) {
            if ( data.length >= 1 ) {
              response( $.map( data, function( item ) {
                return {
                  label: item.display_name + (item.country ? ", " + item.country : ""),
                  value: item.display_name,
                  lat: item.latitude,
                  lng: item.longitude,
                  resultType: 'area'
                }
              }));
            } else {
              geoNamesSearch(request, response);
              // googlePlaceSearch(request, response);
            }
          }
        });
      };

      // var googlePlaceSearch = function(request, response) {
      //   function initialize() {
      //     var service = new google.maps.places.AutocompleteService();
      //     service.getQueryPredictions({ input: request.term }, callback);
      //   }
      //
      //   function callback(predictions, status) {
      //     if (status != google.maps.places.PlacesServiceStatus.OK) {
      //       alert(status);
      //       return;
      //     }
      //     response( $.map( predictions, function( item ) {
      //       return {
      //         label: item.description,
      //         value: item.description,
      //         lat: 0,
      //         lng: 0,
      //         resultType: 'Google'
      //       }
      //     }));
      //     // var results = document.getElementById();
      //     //
      //     // for (var i = 0, prediction; prediction = predictions[i]; i++) {
      //     //   results.innerHTML += '<li>' + prediction.description + '</li>';
      //     // }
      //     console.log(status);
      //     console.log(predictions);
      //
      //
      //   }
      //
      //   initialize();
      // }


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
      $.ajax({
        type: "POST",
        url: '/searchqueries/create',
        data: {search_query: {
          term: this.value,
          source: ui.item.resultType,
          city: userCity,
          country: userCountry
        }},
        success: console.log('saved: ' + ui.item.label),
      });


      var newZoom = 7;
      if (ui.item.resultType === 'place') {
        newZoom = 13;
      }
      $('#svgdiv').fadeOut("fast");
      map.setView( [ui.item.lat, ui.item.lng], newZoom );
      var resultCard = $('#' + ui.item.placeId);
      console.log("putting card at top");
      $('#places').prepend(resultCard);

      if (ui.item.resultType === 'geoNames') {
        var popup = L.popup()
          .setLatLng([ui.item.lat, ui.item.lng])
          .setContent('<h3>' + ui.item.value + '</h3><br><button type="button" id="want-button" class="btn btn-default btn-md"><span class="glyphicon glyphicon-thumbs-up"></span> I Want This in Bound Round</button>')
          .openOn(map);
      }

      $('#want-button').on('click', function(e) {
        $('#want-button').hide();
        $('.leaflet-popup-content').append("Thanks we're on it!");

        $.ajax({
          type: "POST",
          url: '/notification',
          data: {place: ui.item.value,
                city: userCity,
                country: userCountry
          },
          success: console.log('sent: ' + ui.item.value),
        });
      });

      if (typeof brglobe != 'undefined') {
         brglobe.setLocation(ui.item.lat, ui.item.lng);
      }
    },
    open: function() {
      $( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
    },
    close: function() {
      $( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
    }
  });
  }

$('#navModal').modal('show');

$('.go-to-globe').on('click', function(){
  $('#navModal').modal('hide');
});
