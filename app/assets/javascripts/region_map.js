(function (win, doc) {

    "use strict";

    var dataFromSetver = {
        "data": [
            {
                "lat": -25.363,
                "lng": 131.044,
                "country": "South Korea",
                "point": "Jeju Island",
                "description": "Sun bathe peer out window, chatter at birds, lure them to mouth but purr while eating chew iPad power cord.",
                "page-url": "#link-to-region3",
                "preview": "/assets/img/promo-map/jeju-island.jpg",
                "inner-cards": [
                    {
                        "img": "/assets/img/promo-map/point-preview.jpg",
                        "header": "Seoul",
                        "description": "Tropical Fruit World"
                    },
                    {
                        "img": "/assets/img/promo-map/point-preview.jpg",
                        "header": "Seoul",
                        "description": "Tropical Fruit World"
                    },
                    {
                        "img": "/assets/img/promo-map/point-preview.jpg",
                        "header": "Seoul",
                        "description": "Tropical Fruit World"
                    }
                ]
            },
            {
                "lat": -25.363 + 1,
                "lng": 131.044 + 1,
                "country": "South Korea 2",
                "point": "South Korea 2",
                "description": "Sun!!! bathe peer out window, chatter at birds, lure them to mouth but purr while eating chew iPad power cord.",
                "page-url": "#link-to-region2",
                "preview": "/assets/img/promo-map/kyoto.jpg",
                "inner-cards": [
                    {
                        "img": "/assets/img/promo-map/point-preview.jpg",
                        "header": "Seoulssdf",
                        "description": "Tropical Fruit Worldasf"
                    },
                    {
                        "img": "/assets/img/promo-map/point-preview.jpg",
                        "header": "Seoulsfsa",
                        "description": "Tropical Fruit Worldasf"
                    },
                    {
                        "img": "/assets/img/promo-map/point-preview.jpg",
                        "header": "Seoulsfas",
                        "description": "Tropical Fruit Worldsaf"
                    }
                ]
            },
            {
                "lat": -25.363 + 0.5,
                "lng": 131.044 + 0.5,
                "country": "South Korea 2",
                "point": "Jeju Island 2",
                "description": "Sun bathe peer out window, chatter at birds, lure them to mouth but purr while eating chew iPad power cord.",
                "page-url": "#link-to-region1",
                "preview": "/assets/img/promo-map/jeju-island.jpg?ee",
                "inner-cards": [
                    {
                        "img": "/assets/img/promo-map/point-preview.jpg",
                        "header": "Seoul",
                        "description": "Tropical Fruit World"
                    },
                    {
                        "img": "/assets/img/promo-map/point-preview.jpg",
                        "header": "Seoul",
                        "description": "Tropical Fruit World"
                    },
                    {
                        "img": "/assets/img/promo-map/point-preview.jpg",
                        "header": "Seoul",
                        "description": "Tropical Fruit World"
                    }
                ]
            }

        ],
        "meta": {
            "name": "Ebash karty, bleat\'!!!"
        }
    };

    var cardTemplate = [

        '<div class="point-card js-point-card">',

            '<a class="point-card__close js-point-card__close" href="#"></a>',
            '<h3 class="point-card__header">{{= it.country }}</h3>',
            '<h4 class="point-card__local-header">{{= it.point }}</h4>',
            '<p class="point-card__local-description">{{= it.description }}</p>',

            '<div class="scroll-area">',

                '<div class="scroll-area__swiper-container swiper-container">',

                    '<div class="scroll-area__content swiper-wrapper">',
                        '<div class="swiper-slide">',
                        '{{~ it[\'inner-cards\'] :item }}',
                        '<div class="region-preview-item">',
                        '<img src="{{= item.img }}" alt="" class="region-preview-item__image">',
                        '<h3 class="region-preview-item__header">{{= item.header }}</h3>',
                        '<p class="region-preview-item__paragraph">{{= item.description }}</p>',
                        '<div style="clear:both"></div>',
                        '</div>',
                        '{{~}}',
                        '</div>',
                    '</div>',

                '</div>',

                '<div class="swiper-scrollbar"></div>',

            '</div>',

            '<a href="{{= it[\'page-url\'] }}" class="card-go-to">',
                '<span class="card-go-to__text card-go-to__text--go-to">go to</span>',
                '<span class="card-go-to__text">Jeju Island</span>',
            '</a>',

        '</div>'

    ].join('');

    var cardTemplateFn = doT.compile(cardTemplate);

    // var map;

    var pathToMapPoint = '/assets/img/map/map-point.svg';

    function RegionMap() {

        var regionMap = this,
            mapNode = doc.querySelector('.js-google-promo-map');
        if (!mapNode) {
            return;
        }

        regionMap._mapNode = mapNode;

        regionMap._mapData = dataFromSetver;

        regionMap._createMap();

        /*
         regionMap._map = new google.maps.Map(mapNode, {
         center: regionMap._mapData.data[0],
         zoom: 8
         });
         */

        regionMap._markers = [];

        regionMap._addStyle();
        regionMap._addMarkers();

        google.maps.event.addDomListenerOnce(win, 'load', function onLoad() {
            $('img[src="' + pathToMapPoint + '"]').parent().addClass('region-map-point');
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
            {name: "Styled Map"}
        );

        var map = new google.maps.Map(
            mapNode,
            {
                zoom: $('input[name=region]').data("zoom"),
                center: regionMap._mapData.data[0],
                draggable: false,
                scrollwheel: false
            }
        );

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

        regionMap.hideCard();

    };

    RegionMap.prototype._addStyle = function () {

        var style = doc.createElement('style'),
            data = this._mapData.data;

        style.innerText = data
                .map(function (marker) {
                    return 'img[src="' + marker.preview + '"]';
                })
                .join(', ') + ' { border-radius: 50%; filter: grayscale(100%); border: 4px solid #fff !important; } '; // FUUUUCKKK!!!!!!

        style.innerText += data
                .map(function (marker) {
                    return 'img[src="' + marker.preview + '"] + .region-map-point__title';
                })
                .join(', ') + ' { display: block; } ';

        doc.head.appendChild(style);

    };

    RegionMap.prototype.showCard = function (point) {

        var regionMap = this,
            data = regionMap._mapData.data,
            cardData = {},
            html;

        regionMap.hideCard();

        data.every(function (item) {
            if (item.point === point) {
                cardData = item;
                return false;
            }
            return true;
        });

        html = cardTemplateFn(cardData);

        $('.js-promo-map').append(html).find('.js-point-card__close').on('click', function (e) {
            e.preventDefault();
            regionMap.hideAll();
        });

        var elem = $('.js-point-card').get(0);
        if (elem) {
            var tl = new TimelineLite();
            tl.from(elem, 1, {top: -100, opacity: 0, force3D: true});
        }

        // add swiper
        var innerPoints = $('.js-point-card .region-preview-item');

        $('.js-point-card .swiper-slide').height(
            innerPoints.length * (innerPoints.height() + 10) // 10 it is vertical margins of blocks
        );

        var swiper = new Swiper('.js-point-card .swiper-container', {
            scrollbar: '.swiper-scrollbar',
            direction: 'vertical',
            slidesPerView: 'auto',
            mousewheelControl: true,
            freeMode: true
        });

    };

    RegionMap.prototype.hideCard = function () {

        var elem = $('.js-point-card').get(0);

        if (elem) {
            elem.classList.remove('js-point-card');
            var tl = new TimelineLite({
                onComplete: function () {
                    elem.parentNode.removeChild(elem);
                }
            });
            tl.to(elem, 1, {top: 100, opacity: 0, force3D: true});
        }

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

        google.maps.event.addDomListener(marker, 'mouseover', function () {

            marker.set('icon', pointData.preview);

            win.util.waitFor(function () {
                return $('img[src="' + pointData.preview + '"]', mapNode).length;
            }).then(function () {
                $('img[src="' + pointData.preview + '"]', mapNode).each(function () {
                    var $parent = $(this).parent();
                    if ($parent.find('.region-map-point__title').length) {
                        return;
                    }
                    $parent.append('<span class="region-map-point__title">' + pointData.point + '</span>');
                });
            }).catch(function (e) {
                console.log(e);
                console.log('can not load img');
            });

        });

        google.maps.event.addDomListener(marker, 'mouseout', function () {

            var $imgs = $('img[src="' + pointData.preview + '"]');

            if ($imgs.parent().hasClass('map-point-clicked')) {
                return;
            }

            marker.set('icon', pathToMapPoint);

        });

        google.maps.event.addDomListener(marker, 'click', function () {

            regionMap.hideAll();

            marker.set('icon', pointData.preview);

            regionMap.showCard(marker.title);

            $('img[src="' + pointData.preview + '"]').parent().each(function () {
                $(this).addClass('map-point-clicked');
            });

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
