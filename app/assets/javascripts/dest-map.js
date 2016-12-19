

        google.maps.event.addDomListener(window, 'load', init);
    var map;
    function init() {
        var mapOptions = {
            center: new google.maps.LatLng(-23.268748, 133.952527),
            zoom: 4,
            zoomControl: true,
            zoomControlOptions: {
                style: google.maps.ZoomControlStyle.DEFAULT,
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
        var description, telephone, email, web, markericon, marker, link;
        var mapElement = document.getElementById('dest-map');
        var map = new google.maps.Map(mapElement, mapOptions);
        var locations = [
            ['Sydney', 'undefined', 'undefined', 'undefined', 'undefined', -33.865079,  151.212088, '/assets/mydiscoveries_icon/i/map/map-point.png'],['Adelaide', 'undefined', 'undefined', 'undefined', 'undefined', -34.899139,  138.601548, '/assets/mydiscoveries_icon/i/map/map-point.png'],['Perth', 'undefined', 'undefined', 'undefined', 'undefined', -31.923271,  115.859885, '/assets/mydiscoveries_icon/i/map/map-point.png']
        ];
        for (var i = 0; i < locations.length; i++) {
            if (locations[i][1] =='undefined'){ description ='';} else { description = locations[i][1];}
            if (locations[i][2] =='undefined'){ telephone ='';} else { telephone = locations[i][2];}
            if (locations[i][3] =='undefined'){ email ='';} else { email = locations[i][3];}
            if (locations[i][4] =='undefined'){ web ='';} else { web = locations[i][4];}
            if (locations[i][7] =='undefined'){ markericon ='';} else { markericon = locations[i][7];}
            marker = new google.maps.Marker({
                icon: markericon,
                position: new google.maps.LatLng(locations[i][5], locations[i][6]),
                map: map,
                title: locations[i][0],
                desc: description,
                tel: telephone,
                email: email,
                web: web
            });
            link = '';     }

    }


