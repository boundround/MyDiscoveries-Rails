init();
$('#dest-map').on('hidden.bs.collapse', function () {
  init();
})
$('#dest-map').on('shown.bs.collapse', function () {
  init(); 
})

function init() {
    var mapElement = document.getElementById('dest-map');
    if(mapElement != null){
        var locations = JSON.parse(mapElement.getAttribute("data-map"));
        var lat_first = locations[0][5];
        var lng_first = locations[0][6];
        if(mapElement.getAttribute("data-zoom") == "" ||
           mapElement.getAttribute("data-zoom") == null){
            var zoom_level = 4;
        }else{
            var zoom_level = JSON.parse(mapElement.getAttribute("data-zoom"));
        }
        var mapOptions = {
            center: new google.maps.LatLng(lat_first, lng_first),
            zoom: zoom_level,
            zoomControl: false,
            zoomControlOptions: {
                style: google.maps.ZoomControlStyle.DEFAULT,
            },
            disableDoubleClickZoom: true,
            mapTypeControl: true,
            mapTypeControlOptions: {
                style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
            },
            scaleControl: true,
            scrollwheel: false,
            panControl: true,
            streetViewControl: true,
            draggable: true,
            overviewMapControl: true,
            overviewMapControlOptions: {
                opened: false
            },
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        var title, description, telephone, email, web, lat, lng, markericon, marker, link;
        var map = new google.maps.Map(mapElement, mapOptions);

        for (var i = 0; i < locations.length; i++) {
            if (locations[i][0] == '') { title = ''; } else { title = locations[i][0]; }
            if (locations[i][1] == '') { description = ''; } else { description = locations[i][1]; }
            if (locations[i][2] == '') { telephone = ''; } else { telephone = locations[i][2]; }
            if (locations[i][3] == '') { email = ''; } else { email = locations[i][3]; }
            if (locations[i][4] == '') { web = ''; } else { web = locations[i][4]; }
            if (locations[i][5] == '') { lat = ''; } else { lat = locations[i][5]; }
            if (locations[i][5] == '') { lng = ''; } else { lng = locations[i][6]; }
            if (locations[i][7] == '') { markericon = ''; } else { markericon = locations[i][7]; }

            marker = new google.maps.Marker({
                icon: markericon,
                position: new google.maps.LatLng(lat, lng),
                map: map,
                title: title,
                desc: description,
                tel: telephone,
                email: email,
                web: web
            });
            link = '';
        }
    }

}
