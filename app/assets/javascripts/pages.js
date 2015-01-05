var hoverBackground = {
  park: '#9ff1ab',
  animals: '#ff9280',
  activity: '#fa8383',
  beach: '#ffcf7b',
  museum: '#7994b1',
  place_to_eat: '#76a15a',
  place_to_stay: '#a0dcda',
  shopping: '#aab7f4',
  sights: '#f2a1bc',
  sport: '#d6abe8',
  theme_park: '#9dd0f0'
}

var formatCategory = function(string) {
  string = string.replace(/\_/g, " ");
  return string = string.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
}

var postSearchCSS = function() {
  $('.br-logo-home').addClass('br-logo-home-post-search');
  $('.search-wrapper').addClass('search-wrapper-post-search');
  $('.ui-select').show();
  $('#places').show();
  $('#areas').show();
}

var resetHomeScreen = function() {
  $('.br-logo-home').removeClass('br-logo-home-post-search');
  $('.search-wrapper').removeClass('search-wrapper-post-search');
  $('.ui-select').hide();
  $('#places').hide();
  $('#areas').hide();
  console.log('resetting home screen');
}

var removeDuplicateAreaObjects = function(array) {
  var out = [];
  var temp = {};
  for (var i = 0; i < array.length; i++) {
    temp[array[i].title] = array[i];
  }

  for (var key in temp) {
    if (temp.hasOwnProperty(key)) {
      out.push(temp[key])
    }
  }
  return out;
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
    // resetHomeScreen();
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
    // resetHomeScreen();
    if (typeof brglobe != 'undefined') {
      brglobe.setLocation(ll.lat,ll.lng);
       console.log("zoomend 1 fired");
    }
  }
});

var transitionzoomlevel = 4; //2d zoom level transition to globe
var areahidelevel = 7; //zoom level at which area icons that have places are replaced with cluster icons
var areatouchmagnification = 3; //number of levels to zoom when touch area with places

window.placeMarkers = new L.MarkerClusterGroup({showCoverageOnHover: false, maxClusterRadius: 20});
placeMarkers.addTo(map);
placeMarkers.on('mouseover', function(e) {
  var cardId = $('#' + e.layer.options.icon.options.placeId);
  var backgroundColor = hoverBackground[e.layer.options.category];
  cardId.css('background-color', backgroundColor);
  cardId.find('.card-footer').css('background-color', cardId.find('.place-title').css('color'));
  cardId.find('.card-footer').css('color', 'white');
  e.layer.openPopup();
  console.log(e.layer.options.icon.options.iconSize.x);
  console.log(e.layer.options.icon.options.iconSize.y);
});

$(document).ready(function(){
  $('#explore-map-button').on('click', function(){
    $(this).hide();
    $('#cards').css('height', '20%');
    $('#card-container').remove();
    $('.home-footer').remove();
    postSearchCSS();
  });
});

if (window.innerWidth < 1000) {
  $('#filters').remove();
} else {
  placeMarkers.on('mouseout', function(e) {
    var cardId = $('#' + e.layer.options.icon.options.placeId);
    cardId.css('background-color', 'white');
    cardId.find('.card-footer').css('background-color', '#f7f7f7');
    cardId.find('.card-footer').css('color', '#aaaaaa');
    e.layer.closePopup();
  });
}
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

// Change filter menu based on markers visible in current view
map.on('moveend', function(event) {
  if (map.getZoom() >= areahidelevel) {
    // areaMarkers.addLayers(window.areaLayers.havePlaces);
    showAreaCards();
    showPlaceCards();
    postSearchCSS();
  } else {
    resetHomeScreen();
  }
});

var areaIcon = L.Icon.Label.extend({
                options: {
                  iconUrl: 'https://s3.amazonaws.com/donovan-bucket/orange_plane.png',
                  shadowUrl: null,
                  iconSize: new L.Point(43, 26),
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
      place: function() {return new placeIcon({ // labelText: location.properties.title,
                                              labelClassName: 'place-icon-label ' + location.properties.id,
                                              iconUrl: location.properties.icon.iconUrl,
                                              url: location.properties.url,
                                              imageCount: location.properties.imageCount,
                                              videoCount: location.properties.videoCount,
                                              gameCount: location.properties.gameCount,
                                              heroImage: location.properties.heroImage,
                                              placeId: location.properties.placeId,
                                              area: location.properties.area,
                                              title: location.properties.title
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
      showAreaCards();
    } else if (previousZoom < areahidelevel && newZoom >= areahidelevel){
      areaMarkers.removeLayers(window.areaLayers.havePlaces)
      placeMarkers.addLayers(placesArray);
      showAreaCards();
      showPlaceCards();
      postSearchCSS();
    }
  });
  if (window.parsedHash && window.parsedHash.zoom > 3) {
    areaMarkers.removeLayers(window.areaLayers.havePlaces)
    placeMarkers.addLayers(placesArray);
    showAreaCards();
    showPlaceCards();
    postSearchCSS();
  }
}

var showAreaCards = function(){
  var bounds = map.getBounds();
  var text = '';
  var areas = [];
  placeMarkers.eachLayer(function(marker) {
    if (bounds.contains(marker.getLatLng())) {
      areas.push(marker.options.icon.options.area)
    }
  });
  areas = removeDuplicateAreaObjects(areas);
  for (var i = 0; i < areas.length; i++) {
    var url = areas[i].url;
    if (areas[i].country != areas[i].title){
      var areaTitle = areas[i].title + ', ' + areas[i].country;
    } else {
      var areaTitle = areas[i].title
    }
    if (areas[i].placeCount > 0) {
      var placeCountText = areas[i].placeCount + ' places';
    } else {
      var placeCountText = '&nbsp;';
    }

    var pin = '<div class="area-card-pin"><img src="http://d1w99recw67lvf.cloudfront.net/category_icons/place-pin.png" class="area-pin" alt="map pin"></div>';

    text += '<a class="no-anchor-decoration" href="' + url + '"><div class="area-card">' + pin + '<div class="area-title">' + areaTitle +
      '<br><span class="place-count">' + placeCountText + '</span></div></div></a>';
  }
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
      var placeTitle = marker.options.icon.options.title;
      var placeId = marker.options.icon.options.placeId;

      var content = '<a class="no-anchor-decoration" href="' + url +
      '"><div class="upper-card" style="background-image: url(' + heroImage + ')"><div class="card-category">' +
      categoryIcon + categoryText + '</div></div><p class="place-title ' + category + '">' + placeTitle + '</p><br></a>'

      text += '<div class="place-card" id="' + placeId + '">' + content + '<div class="card-footer"><div class="image-count">' +
      imageCountIcon + '&nbsp;&nbsp;' + imageCount + '</div><div class="video-count">' +
      videoCountIcon + '&nbsp;&nbsp;' + videoCount + '</div><div class="game-count">' +
      gameCountIcon + '&nbsp;&nbsp;' + gameCount + '</div></div></div>';

      marker.bindPopup(content);

      $('.leaflet-marker-icon')
        .mouseenter(function() {
          $(this).css('height', '45px').css('width', '30px');
        })
        .mouseleave(function() {
          $(this).css('height', '38px').css('width', '25px');
        });
      }
  });
  $('#places').html(text);
  if (typeof(resultCard) !== 'undefined') {
    var removeCard = $('#' + $(resultCard).attr('id'));
    removeCard.remove();
    $('#places').prepend(resultCard);
  }
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
        showAreaCards();
        showPlaceCards();
        postSearchCSS();
      } else {
          window.location.href = url
        };
    } else { //if (map.getZoom() >= areahidelevel )
        if (markerType === 'area') {
          window.location.href = url
        } else {
          if (window.innerWidth < 1000){
            e.layer.openPopup();
          } else {
            window.location.href = url;
          }
        }
      }
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
      window.resultCard = $('#' + ui.item.placeId);
      console.log("saving result card");
      showAreaCards();
      showPlaceCards();

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

var filters = document.getElementById('filters');
var checkboxes = document.getElementsByClassName('filter');

function changeFilters() {
    // Find all checkboxes that are checked and build a list of their values
    var on = [];
    for (var i = 0; i < checkboxes.length; i++) {
        if (checkboxes[i].checked) on.push(checkboxes[i].value);
    }

    placeMarkers.clearLayers();
    for (var j = 0; j < checkboxes.length; j++) {
      placeMarkers.addLayers(placeLayers[on[j]]);
    }
    return false;
}

// When the form is touched, re-filter markers
filters.onchange = changeFilters;
// Initially filter the markers
changeFilters();
