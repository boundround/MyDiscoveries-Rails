(function () {
    'use strict';

        google.maps.event.addDomListener(window, 'load', init);
    var map1, map2;
    function init() {
        var mapOptions1 = {
            center: new google.maps.LatLng(41.382148, 2.178635),
            zoom: 13,
            zoomControl: true,
            zoomControlOptions: {
                style: google.maps.ZoomControlStyle.DEFAULT
            },
            disableDoubleClickZoom: true,
            mapTypeControl: true,
            mapTypeControlOptions: {
                style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
            },
            scaleControl: true,
            scrollwheel: true,
            panControl: true,
            streetViewControl: true,
            draggable : true,
            overviewMapControl: true,
            overviewMapControlOptions: {
                opened: false
            },
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };

        var mapOptions2 = {
            center: new google.maps.LatLng(41.382148, 2.178635),
            zoom: 5,
            zoomControl: true,
            zoomControlOptions: {
                style: google.maps.ZoomControlStyle.DEFAULT
            },
            disableDoubleClickZoom: true,
            mapTypeControl: true,
            mapTypeControlOptions: {
                style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
            },
            scaleControl: true,
            scrollwheel: true,
            panControl: true,
            streetViewControl: true,
            draggable : true,
            overviewMapControl: true,
            overviewMapControlOptions: {
                opened: false
            },
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };

        var description, telephone, email, web, markericon, marker1, marker2, link;

        var mapElement1 = document.getElementById('ci-map');
        var mapElement2 = document.getElementById('ci-itinerary-map');
        var map1 = new google.maps.Map(mapElement1, mapOptions1);

        var map2 = new google.maps.Map(mapElement2, mapOptions2);


        var locations = [
            ['Barcelona', 'undefined', 'undefined', 'undefined', 'undefined', 41.382148,  2.178635, '../i/map/map-point.png']
        ];
        for (var i = 0; i < locations.length; i++) {
            if (locations[i][1] =='undefined'){ description ='';} else { description = locations[i][1];}
            if (locations[i][2] =='undefined'){ telephone ='';} else { telephone = locations[i][2];}
            if (locations[i][3] =='undefined'){ email ='';} else { email = locations[i][3];}
            if (locations[i][4] =='undefined'){ web ='';} else { web = locations[i][4];}
            if (locations[i][7] =='undefined'){ markericon ='';} else { markericon = locations[i][7];}
            marker1 = new google.maps.Marker({
                icon: markericon,
                position: new google.maps.LatLng(locations[i][5], locations[i][6]),
                map: map1,
                title: locations[i][0],
                desc: description,
                tel: telephone,
                email: email,
                web: web
            });
            link = '';     }

        for (var j = 0; j < locations.length; j++) {
            if (locations[j][1] =='undefined'){ description ='';} else { description = locations[j][1];}
            if (locations[j][2] =='undefined'){ telephone ='';} else { telephone = locations[j][2];}
            if (locations[j][3] =='undefined'){ email ='';} else { email = locations[j][3];}
            if (locations[j][4] =='undefined'){ web ='';} else { web = locations[j][4];}
            if (locations[j][7] =='undefined'){ markericon ='';} else { markericon = locations[j][7];}
            marker2 = new google.maps.Marker({
                icon: markericon,
                position: new google.maps.LatLng(locations[j][5], locations[j][6]),
                map: map2,
                title: locations[j][0],
                desc: description,
                tel: telephone,
                email: email,
                web: web
            });
            link = '';     }

    }


    $(document).ready(function(){

        $('#ci-itinarary-map-loader').on('click', function(){
            $('#ci-itinerary-map').css('display', 'block');
            init();
        })

    })

})();
