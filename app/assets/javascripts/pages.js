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

window.initialCenter = $('.modal-content').data();
if (window.initialCenter.lat) {
  map.setView([initialCenter.lat, initialCenter.long], transitionzoomlevel);
};

L.control.zoomslider().addTo(map);


map.on('zoomend', function() {
    if (map.getZoom() < transitionzoomlevel){
      $('#svgdiv').fadeIn("fast");
      var ll = window.previousLocation ? window.previousLocation : map.getCenter();
      if (typeof brglobe != 'undefined') {
   		  brglobe.setLocation(ll.lat,ll.lng);
      };
    };
});

//var transitionzoomlevel = 7;
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
      };
    };
  };
  if (shownCategoryButtons.length <= 1 ) {
    $('#menu-ui').find('a').hide();
    $('#menu-ui').prepend("<a id='no-places'>No Places</a>");
  };
};

// Change filter menu based on markers visible in current view
map.on('moveend', function(event) {
  if (map.getZoom() >= transitionzoomlevel) {
    console.log(event);
    console.log('move end fired');
    setFilterButtons(getInboundCategories());
  };
});

// map.on('zoom', function() {
//   if (map.getZoom() > transitionzoomlevel) {
//     console.log('zoom end fired');
//
//     setFilterButtons(getInboundCategories());
//   };
// });



$('#menu-ui').on('click', 'a', function(e) {
  category = $(this).data('category');
  $(this).siblings().removeClass('active');
  $(this).addClass('active');
  placeMarkers.clearLayers();
  placeMarkers.addLayers(placeLayers[category]);
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
                  iconSize: new L.Point(55, 55),
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
                                              + location.properties.id
                                              });},
      place: function() {return new placeIcon({ labelText: location.properties.title,
                                              labelClassName: 'place-icon-label ' + location.properties.id,
                                              iconUrl: location.properties.icon.iconUrl
                                              });}
    }

    // Only create marker if it has lat and long
    if (location.geometry.coordinates[1] && location.geometry.coordinates[0]) {
      var marker = L.marker(new L.LatLng(location.geometry.coordinates[1], location.geometry.coordinates[0]),
          {icon: icon[markerType](),
           riseOnHover: true,
           riseOffset: 500,
           category: location.properties.category }
      );
      markerArray.push(marker);
      if (markerType == 'place') {
        if (placeLayers[location.properties.category]) {
          window.placeLayers[location.properties.category].push(marker);
        };
      };
      if (markerType == 'area') {
        location.properties.places ? window.areaLayers.havePlaces.push(marker) : window.areaLayers.noPlaces.push(marker);
      };
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
        var placesArray = createMarkerArray(data, 'place');
        addMarkersClickEvent(placeMarkers);

        //switch between areas and places
        map.on('zoomstart', function() {
          window.previousZoom = map.getZoom();
					window.previousLocation = map.getCenter();
        });
        map.on('zoomend', function() {
            var newZoom = map.getZoom();
            if (previousZoom >= areahidelevel && newZoom < areahidelevel) {
              placeMarkers.removeLayers(placesArray);
              areaMarkers.addLayers(window.areaLayers.havePlaces)
              $('#menu-ui').css("visibility", "hidden");
            } else if (previousZoom < areahidelevel && newZoom >= areahidelevel){
              areaMarkers.removeLayers(window.areaLayers.havePlaces)
              placeMarkers.addLayers(placesArray);
              $('#menu-ui').css("visibility", "visible");
            };
        });
      }
    });

  }
});

//


var lastLoaded = 0;

// Launch modals on clicks
var addMarkersClickEvent = function(markers) {
  markers.on('click', function(e) {
    var markerProps = e.layer.options.icon.options.labelClassName.split(" ");
    var markerType = '';
    markerProps.shift().match(/area/) ? markerType = 'area' :  markerType = 'place';
    var markerID = markerProps.pop();
    var hasPlaces = markerProps.slice(-2)[0] === 'true';
    if (map.getZoom() < areahidelevel ) {
      if (hasPlaces) {
        map.setView([e.latlng.lat, e.latlng.lng], areahidelevel+areatouchmagnification);
      } else {
          $('.area-content').empty();
          $('#areaModal').modal();
          History.pushState({state: markerID}, markerID, ("?state=" + markerID)); // logs {state:1}, "State 1", "?state=1"
          $.ajax({
            url: '/' + markerType + 's/' + markerID + ".html",
            success: function(data) {
              $('.area-content').html(data);
              loadIsotope();
              //Vimeo api code
              var iframe = $('.hero-video')[0];
              player = $f(iframe);

              // When the player is ready, add listeners for pause, finish, and playProgress
              player.addEvent('ready', function() {
              });

              // Call the API when a button is pressed
              $('#dropdownMenu1').bind('click', function() {
                  player.api('pause');
              });


              //Stop  area video on modal close
              $('#areaModal').on('hidden.bs.modal', function (e) {
                player.api('pause');
              });
            }
          });
          window.lastLoaded = markerID;
          // $('#showAreaModal').length < 1 ? $('#areaModal').modal() : $('#showAreaModal').modal();
        };
    }
		else//      if (map.getZoom() >= areahidelevel )
		{
        if (markerType === 'area') {
          $('.area-content').empty();
          $('#areaModal').modal();
          History.pushState({state: markerID}, markerID, ("?state=" + markerID)); // logs {state:1}, "State 1", "?state=1"
          $.ajax({
            url: '/' + markerType + 's/' + markerID + ".html",
            success: function(data) {
              $('.area-content').html(data);
              loadIsotope();
              //Vimeo api code
              var iframe = $('.hero-video')[0];
              player = $f(iframe);

              // When the player is ready, add listeners for pause, finish, and playProgress
              player.addEvent('ready', function() {
              });

              // Call the API when a button is pressed
              $('#dropdownMenu1').bind('click', function() {
                  player.api('pause');
              });


              //Stop  area video on modal close
              $('#areaModal').on('hidden.bs.modal', function (e) {
                player.api('pause');
              });
            }
          });
          window.lastLoaded = markerID;
          // $('#showAreaModal').length < 1 ? $('#areaModal').modal() : $('#showAreaModal').modal();
        } else {
          $('.area-content').empty();
          $('#areaModal').modal();
          History.pushState({state: markerID}, markerID, ("?state=" + markerID)); // logs {state:1}, "State 1", "?state=1"
          $.ajax({
            url: '/' + markerType + 's/' + markerID + ".html",
            success: function(data) {
              $('.area-content').html(data);
              loadIsotope();
              //Vimeo api code
              var iframe = $('.hero-video')[0];
              player = $f(iframe);

              // When the player is ready, add listeners for pause, finish, and playProgress
              player.addEvent('ready', function() {
              });

              // Call the API when a button is pressed
              $('#dropdownMenu1').bind('click', function() {
                  player.api('pause');
              });


              //Stop  area video on modal close
              $('#areaModal').on('hidden.bs.modal', function (e) {
                player.api('pause');
              });
            }
          });
          window.lastLoaded = markerID;
          // $('#showAreaModal').length < 1 ? $('#areaModal').modal() : $('#showAreaModal').modal();
        };
      };
  });
};

$('.dude-help').on('click', function () {
  $(this).find('.balloon-wrapper').toggleClass('balloon-wrapper-show');
  $(this).toggleClass('dude-help-out');
});

var loadIsotope = function() {
  var $container = $('#photos-masonry');

  $container.imagesLoaded(function() {
    $container.isotope({
      layoutMode: 'masonry',
      itemSelector: '.item ',
      masonry: {
        columnWidth: $container.find('.grid-sizer')[0]
      },
      getSortData: {
        priority: '.priority'
      },
      sortBy: ['priority', 'original-order']
    });
  });

  // Close expanded cards
  $('.photo-card').on( 'click', function() {
    $(this).siblings('.game-card').find('.game-divider').empty();
    $(this).siblings('.video-card').find('.game-divider').empty();
    $(this).siblings('.photo-card').find('.game-divider').empty();
    $(this).siblings('.photo-card-expanded').removeClass('photo-card-expanded')
      .find('.fun-fact').hide().end()
      .find('.game-thumbnail').show();
    $(this).siblings('.game-card-expanded').removeClass('game-card-expanded')
      .find('.game-thumbnail').show().end()
      .find('.fun-fact').hide();
    $container.imagesLoaded(function() {
      $container.isotope({ layoutMode : 'masonry' });
    });
  });

  // Expand Game Card
  $('.game-card').on( 'click', function() {
    var gameURL = $(this).find('.game-data').data('url');
    var content = '<iframe class="game-frame" src="' + gameURL + '" ></iframe>';
    var divider = $(this).find('.game-divider');
    //expand clicked game card
    $(this).find('.game-thumbnail').hide();
    $(this).addClass('game-card-expanded');
    $(this).find('.fun-fact').show();
    $(divider).empty();
    $(divider).append(content);
    $container.imagesLoaded(function() {
      $container.isotope({ layoutMode : 'masonry' });
    });
  });

  // Expand Video Card
  $('.video-card').on( 'click', function() {

    var vimeoId = $(this).find('.video-data').data('video-id');
    var content = '<iframe class="vimeo-frame" src=\"//player.vimeo.com/video/' + vimeoId + '\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>';
    var divider = $(this).find('.game-divider');
    //expand clicked game card
    $(this).find('.game-thumbnail').hide();
    $(this).addClass('game-card-expanded');
    $(divider).empty();
    $(divider).append(content);
    $container.imagesLoaded(function() {
      $container.isotope({ layoutMode : 'masonry' });
    });
  });

  // Expand Photo Card
  $('.photo-thumb').on('click', function(e) {
    var photoUrl = $(this).find('.photo-data').data('photo-url');
    var divider = $(this).find('.game-divider');
    // remove photo thumbnail and populate expanded divider with large image
    $(this).find('.game-thumbnail').hide();
    $(this).addClass('photo-card-expanded');
    $(this).find('.fun-fact').show();
    $(divider).empty();

    //Dummy image, medium
    var content2 = $('<img src=' +
    '"data:image/gif;base64,R0lGODlhLAH6APf/AKOhofetcHy2ze95hfppdPiRcv3fVf3mkP3iVfpcaJ3J3P3hWPrQpvvorfpjbP38/ObX2NmOk/e5AflyemBfXfGRLtvGx/iEhfnEE//26PvUafbo6PvSM/3dTfrKVvnDAf7navzVOffz0fzbiQ4PDPSlJfvJOP7iTNi3uvvLI/l7gutoQ/Xy8vealdimqeZDV+zk5PnVyvjp1e1rdvm9Ff7oe/3ZRK/Fq/m/CPm5BePIyu1xe+6apfOTVfm+AuIsW+WVmvnBDelWZPiqlvzWePnFZ/n83u17O+aEivzswPzenPrGdfvNKPrLRfrGGPe5BXa10/WsGfeVhfi4mfekge7r6+O2ufelo/m9BN++wPfyzvf20f3y3P3eSfrJHZK7wvrHivzdXt3W1uOnq+eLkvf51frHnPvQLfi8t/nd0PizrP/68vzXP99udO90i/i2hS8vLPi7C/e3APj229qtseplb+lbSv3bSOM7W+dRUcvDyf3x0Pl0aOMyWOfj4+MxVXa0zfm7W/n518XMk/f19eZLZPnAH/fJvvhVYO98iPf11vvQX+91gN6dofe9BPeOj7rM2eKusvnELuEnTcnZ5I+OjeTR0uMvW+Z8hfe1Dvj72PzYPNe6Tt/NzvvRSe3aaNp7geIxXuhJUOrf4E5NS9Dm8PKaI8msuLi1tfvPUeM1XsLBwfXbXuM9VnJxcPe9AuPXc+vs8t3Vfv7mXfP1+uPc3dGmK+XNXu3n56+RP/nx1+Lj6vWCbv6+AO5ebCUkItOhpfLv79G1eW2xy+XDZTw6N452OOM0WH9+fv/ABOno6PzZW/3fUurNh+M2WENCQfj5/jw8QdHPz+azJfm7Avm5ABoaF/m7AB0eHv3fT/m5Av3dUPm3AP3bTOM3W/3dU/vbSPn4+OM0W/vdTv7fTf/fU/zYVf3bUve2E98gTuZAWOEqX+R2ffOurfvJGfnDDv3YN/vQIIK/1fvbTPNGWPu7APu5APu7BO/w9/e7BPzeUv3eU/i7BPi8BP///////yH/C05FVFNDQVBFMi4wAwEAAAAh/wtYTVAgRGF0YVhNUDw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDIxIDc5LjE1NDkxMSwgMjAxMy8xMC8yOS0xMTo0NzoxNiAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDozYjQ3YzlhYS0zYTVmLTQ0NzEtYWMwMS1iN2RjMjA5MGViNGEiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6MTA1NjgyNjYxMDVGMTFFNEJFMEE5NTQ3NkMwQkI3RDQiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6MTA1NjgyNjUxMDVGMTFFNEJFMEE5NTQ3NkMwQkI3RDQiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChNYWNpbnRvc2gpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MGIxNGE1MmItY2Y1OC00ZTNlLTkzZjItMDIyMjc4NmJkMDVlIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjNiNDdjOWFhLTNhNWYtNDQ3MS1hYzAxLWI3ZGMyMDkwZWI0YSIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PgH//v38+/r5+Pf29fTz8vHw7+7t7Ovq6ejn5uXk4+Lh4N/e3dzb2tnY19bV1NPS0dDPzs3My8rJyMfGxcTDwsHAv769vLu6ubi3trW0s7KxsK+urayrqqmop6alpKOioaCfnp2cm5qZmJeWlZSTkpGQj46NjIuKiYiHhoWE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"'
    + ' class="photo-transparent-placeholder">');
    $(this).find('.game-divider').append(content2);

    var content = $('<img class="photo-frame">');
    $(this).find('.game-divider').append(content);
    content.hide();
    content.load(function(){
      content.show();
      content2.hide();
    });
    content.attr("src",photoUrl);

    $container.imagesLoaded(function() {
      $container.isotope({ layoutMode : 'masonry' });
    });
  });


  $('#menu').on( 'click', 'a', function() {
    var filterValue = $(this).attr('data-filter');
    $container.isotope({ filter: filterValue });
  });

  // var hash = $('.title').text();
  // window.location.hash = hash;

}

$('#areaModal').on('hide.bs.modal', function (e) {
  History.pushState({state: 'map'}, 'Map', ("map")); // logs {state:1}, "State 1", "?state=1"
  $('#photos-masonry').isotope({ filter: '' });
  var hash = this.id;
  // history.pushState('', document.title, window.location.pathname);
});

//Close all modals open when you click back on main modal.
$('.footer').on('click', function() {
  $('.modal').modal('hide');
})
