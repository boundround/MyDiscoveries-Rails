(function (win, doc) {
    "use strict";
    var input_offer = $('input[name=offer]');
    var start_lat   = parseFloat(input_offer.data('startLat'));
    var start_lng   = parseFloat(input_offer.data('startLng'));
    var start_name  = input_offer.data('startName');
    var end_lat     = parseFloat(input_offer.data('endLat'));
    var end_lng     = parseFloat(input_offer.data('endLng'));
    var end_name    = input_offer.data('endName');
    var img_url     = input_offer.data('imgTemplate');
    var pointer_url = input_offer.data('imgPointer');

    var dataFromSetver = {
      "data": [
        {
          "lat": start_lat,
          "lng": start_lng,
          "point": "Start: " + start_name,
          "preview": img_url
        },
        {
          "lat": end_lat,
          "lng": end_lng,
          "point": "End: "+ end_name,
          "preview": img_url
        }
      ],
      "meta": {
        "name": ""
      }
    };

    var pathToMapPoint = pointer_url;

    function RegionMap() {

        var regionMap = this,
            mapNode = doc.querySelector('.js-google-promo-map');
        if (!mapNode) {
            return;
        }

        regionMap._mapNode = mapNode;

        regionMap._mapData = dataFromSetver;

        regionMap._createMap();

        regionMap._markers = [];

        regionMap._addStyle();
        regionMap._addMarkers();

        google.maps.event.addDomListenerOnce(win, 'load', function onLoad() {
            $('img[src="' + pathToMapPoint + '"]').parent().addClass('region-map-point'); //.css('width','50px');
        });

        regionMap._map.addListener('click', function () {
            regionMap.hideAll();
        });

        if (!mapNode.classList.contains('js-do-not-click')) {
            google.maps.event.addListenerOnce(regionMap._map, 'tilesloaded', function () {
                new google.maps.event.trigger(regionMap._markers[0], 'mouseover');
                setTimeout(function () {
                    new google.maps.event.trigger(regionMap._markers[0], 'click');
                }, 1000);
            });
        }

    }

    RegionMap.prototype._createMap = function () {

        var regionMap = this;

        var mapNode = doc.querySelector('.js-google-promo-map');

        var styles = [
          {
            featureType: "all",
            elementType: "geometry",
            stylers: [
                {color: "#95CC72"}
            ]
          },
          {
            featureType: "all",
            elementType: "labels.text.fill",
            stylers: [
                {color: "#f5f5f5"}
            ]
          },
          {
            featureType: "water",
            elementType: "geometry",
            stylers: [
                {color: "#C5F4FE"}
            ]
          },
          {
            featureType: "administrative.country",
            elementType: "geometry.stroke",
            stylers: [
                {color: "#f5f5f5"},
                {weight: 0.5}
            ]
          },
          {
            featureType: "administrative_area_level_1",
            elementType: "labels.text",
            stylers: [
                {visibility: "off"}
            ]
          },
          {
            featureType: "administrative.country",
            elementType: "labels.text",
            stylers: [
                {visibility: "on"}
            ]
          },
          {
            featureType: "all",
            elementType: "labels.text.stroke",
            stylers: [
                {visibility: "off"}
            ]
          }
        ];

        var styledMap = new google.maps.StyledMapType(
            styles,
            { name: "Styled Map" }
        );

        var map = new google.maps.Map(
          mapNode,
          {
            zoom: $('input[name=offer]').data("zoom"),
            draggable: false,
            scrollwheel: false,
            zoomControl: true
          }
        );

        map.setCenter(new google.maps.LatLng(
          ((end_lat + start_lat) / 2.0),
          ((end_lng + start_lng) / 2.0)
        ));

        map.mapTypes.set('map_style', styledMap);
        map.setMapTypeId('map_style');

        regionMap._map = map;

    };

    RegionMap.prototype.hideAll = function () {

        var regionMap = this;

        regionMap._markers.forEach(function (marker) {
            marker.set('icon', pathToMapPoint);
        });

        $('.map-point-clicked').removeClass('map-point-clicked');

    };

    RegionMap.prototype._addStyle = function () {

        var style = doc.createElement('style'),
            data = this._mapData.data;

        style.innerText = data
                .map(function (marker) {
                    return 'img[src="' + marker.preview + '"]';
                })
                .join(', ') + ' { border-radius: 50%; filter: grayscale(100%); border: 4px solid #fff !important; opacity: 0!important; display: block !important; } ';
        style.innerText += data
                .map(function (marker) {
                    return 'img[src="' + marker.preview + '"] + .region-map-point__title';
                })
                .join(', ') + ' { display: block; } ';

        doc.head.appendChild(style);

    };


    RegionMap.prototype._addMarker = function (pointData) {

        var regionMap = this,
            mapNode = regionMap._mapNode,
            map = regionMap._map,
            marker = new google.maps.Marker({
                position: {lat: pointData.lat, lng: pointData.lng},
                // map: map,
                draggable: false,
                icon: pathToMapPoint,
                optimized: false,
                title: pointData.point
            });
        google.maps.event.addDomListener(marker, 'mouseover', function (event) {
            marker.set('icon', pointData.preview);
            $('.google-promo-map .img-circle:not(.gmnoprint), .google-promo-map .img-circle').removeClass('hover');
            win.util.waitFor(function () {
                return $('img[src="' + pointData.preview + '"]', mapNode).length;
            }).then(function () {
                $('img[src="' + pointData.preview + '"]', mapNode).each(function () {
                    var $parent = $(this).parent();
                    $parent.addClass('hover');
                    if ($parent.find('.region-map-point__title').length) {
                        return;
                    }
                    $parent.append('<span class="region-map-point__title">' + pointData.point + '</span>');
                });
            }).catch(function (e) {
                console.log('can not load img');
            });

            $('img[src="' + pointData.preview + '"]').parent().each(function () {
                $(this).css({
                    'background-image': 'url(' + pointData.preview + ')',
                    'background-size' : 'cover'
                })
            });

            $('.google-promo-map .img-circle:not(.gmnoprint), .google-promo-map .img-circle').css({
               'border':'4px solid #fff !important'

            })
        });

        google.maps.event.addDomListener(marker, 'mouseout', function () {

            var $imgs = $('img[src="' + pointData.preview + '"]');
            if ($imgs.parent().hasClass('map-point-clicked')) {
                return;
            }
            marker.set('icon', pathToMapPoint);

            if ($imgs.parent().hasClass('map-point-clicked')) {
                return;
            }

            $('.google-promo-map .img-circle:not(.gmnoprint), .google-promo-map .img-circle').removeClass('hover');

            $('img[src="' + pointData.preview + '"]').parent().each(function () {
                $(this).addClass('img-circle').removeClass('hover').css({
                    'background-image': 'url(' + pointData.preview + ')',
                    'background-size' : 'cover'
                })
            });

        });

        google.maps.event.addDomListener(marker, 'click', function (event) {
            regionMap.hideAll();

            marker.set('icon', pointData.preview);

            $('img[src="' + pointData.preview + '"]').parent().each(function () {
                $(this).addClass('map-point-clicked');
                $(this).addClass('map-point-clicked img-circle').css({
                    'background-image': 'url(' + pointData.preview + ')',
                    'background-size' : 'cover'
                })
            });

             $('.google-promo-map .map-point-clicked.img-circle:not(.gmnoprint)').css({
                'border-color':'#6cb7ca'
             })

            $('a.point-card__close.js-point-card__close').click(function(){
                $('.google-promo-map .img-circle:not(.gmnoprint), .google-promo-map .img-circle').removeClass('hover');
            })

        });

        marker.setMap(map);

        return marker;

    };

    RegionMap.prototype._addMarkers = function () {

        var regionMap = this,
            mapData = regionMap._mapData;

        this._markers = mapData.data.map(regionMap._addMarker, this);

    };


    win.onload = function () {
      new RegionMap();
    };

}(window, window.document));
