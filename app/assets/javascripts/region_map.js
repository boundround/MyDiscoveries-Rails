(function (win, doc) {

    "use strict";
    var data_marker = $('input[name=region]').data('marker').split(', ["@"]');
    data_marker.pop(); //per place
    var datas = function() {
        var results = [];
        $.each(data_marker, function(i, val) {
            var obj = {},
                data_split = val.split(', "#'); //per key
            obj['point'] = data_split[0].split('=>')[1].slice(1, -1);
            obj['lat'] = parseFloat(data_split[1].split('=>')[1]);
            obj['lng'] = parseFloat(data_split[2].split('=>')[1]);
            if (data_split[3].length > 150){
                obj['description'] = data_split[3].split('=>')[1].slice(1, -1).substr(0,150)+" ...";
            }else{
                obj['description'] = data_split[3].split('=>')[1].slice(1, -1);
            }
            obj['country'] = data_split[4].split('=>')[1].slice(1, -1);
            obj['preview'] = data_split[6].split('=>')[1].slice(1, -1);
            obj["inner-cards"] = [];
            obj['path'] = data_split[5].split('=>')[1].slice(1, -1);
            var data_childs = data_split[7].split(', ["#"]');
            data_childs.pop();
            $.each(data_childs, function(i, val){
                var childs_objs = {},
                    data_childs_split = val.split('"@');
                    data_childs_split.shift();
                    childs_objs["img"] = data_childs_split[2].split('=>')[1].slice(1, -2);
                    childs_objs["header"] = data_childs_split[0].split('=>')[1].slice(1, -3);
                    childs_objs["description"] = data_childs_split[1].split('=>')[1].slice(1, -3);
                obj["inner-cards"].push(childs_objs)
            })
            results.push(obj);
        });
        return results;
    }
    var dataFromSetver = {
        "meta": {
            "name": "Ebash karty, bleat\'!!!"
        },
        "data": datas()
    };

    var cardTemplate = [

    '<div class="point-card js-point-card" style="opacity: 1; transform: translate3d(0px, 0px, 0px);">',
      '<h3 class="point-card__header">{{= it.country }}</h3>',
      '<h4 class="point-card__local-header">{{= it.point }}</h4>',
      '<div class="point-card__local-description">{{= it.description }}</div>',
      '<div class="scroll-area" style="overflow: scroll;">',
          '<div class="scroll-area__swiper-container swiper-container swiper-container-vertical swiper-container-free-mode">',
              '<div class="scroll-area__content swiper-wrapper" style="transform: translate3d(0px, 0px, 0px);">',
                  '<div class="swiper-slide swiper-slide-active">',
                      '{{~ it[\'inner-cards\'] :item }}',
                      '<div class="region-preview-item">',
                          '<img src="{{= item.img }}" alt="" class="region-preview-item__image">',
                          '<h3 class="region-preview-item__header">{{= item.header }}</h3>',
                          '<p class="region-preview-item__paragraph">{{= item.description }}</p></div>',
                      '{{~}}',
                  '</div>',
              '</div>',
          '</div>',
          '<div class="swiper-scrollbar" style="transition-duration: 400ms;"></div>',
      '</div>',
      '<a href="{{= it.path }}" class="card-go-to"><span class="card-go-to__text card-go-to__text--go-to">go to</span>',
      '<span class="card-go-to__text">{{= it.point}}</span></a></div>'

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
            $('img[src="' + pathToMapPoint + '"]').parent().addClass('region-map-point').css('width','50px');
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
                scrollwheel: false,
                zoomControl: false
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
                .join(', ') + ' { border-radius: 50%; filter: grayscale(100%); border: 4px solid #fff !important; opacity: 0!important; display: block !important; } ';
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

        google.maps.event.addDomListener(marker, 'mouseover', function (event) {
       
            marker.set('icon', pointData.preview);

            var $parent = $('.image-marker:contains("' + pointData.point + '")').parent();

            if(!$('img[src="' + pointData.preview + '"]').siblings().hasClass('image-marker')){
                $('img[src="' + pointData.preview + '"]').parent().append('<div class="image-marker" style="background-image: url('+ pointData.preview +')">' + pointData.point + '</div>')
            }

            $parent.addClass('hover')

        });

        google.maps.event.addDomListener(marker, 'mouseout', function () {

            var $imgs = $('img[src="' + pointData.preview + '"]');
            if ($imgs.parent().hasClass('map-point-clicked')) {
                return;
            }
            var $parent = $('img[src="' + pointData.preview + '"]').parent();
            marker.set('icon', pathToMapPoint);

            resetStyle(true);

            if ($imgs.parent().hasClass('map-point-clicked')) {
                return;
            }

            $parent.removeClass('hover')


        });

        google.maps.event.addDomListener(marker, 'click', function (event) {
            resetStyle(true);
            regionMap.hideAll();

            marker.set('icon', pointData.preview);

            regionMap.showCard(marker.title);

            var $parent = $('img[src="' + pointData.preview + '"]').parent();

            if(!$('img[src="' + pointData.preview + '"]').siblings().hasClass('image-marker')){
                $('img[src="' + pointData.preview + '"]').parent().append('<div class="image-marker" style="background-image: url('+ pointData.preview +')">' + pointData.point + '</div>')
            }

            $('.gm-style div').removeClass('marker-clicked map-point-clicked hover')
            if($('.marker-clicked').length == 0){
                setTimeout(function(){
                    $parent.addClass('marker-clicked map-point-clicked')
                }, 100)
            }

        });

        marker.setMap(map);

        return marker;

    };

    $('.js-google-promo-map').click(function(){
        if($('.marker-clicked').length != 0 || $('.hover').length != 0){
            $('.gm-style div').removeClass('marker-clicked map-point-clicked')
            $('.gm-style div').removeClass('hover')
        }
    })

    RegionMap.prototype._addMarkers = function () {

        var regionMap = this,
            mapData = regionMap._mapData;

        this._markers = mapData.data.map(regionMap._addMarker, this);

    };


    win.onload = function () {
        new RegionMap();
    };


    function resetStyle(reset){
        if(reset){
           $('style.map-click').remove();
        }
    }
}(window, window.document));
