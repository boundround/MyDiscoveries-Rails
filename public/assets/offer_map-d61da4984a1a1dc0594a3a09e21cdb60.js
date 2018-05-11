!function(e,t){"use strict";function o(){var o=this,a=t.querySelector(".js-google-promo-map");a&&(o._mapNode=a,o._mapData=g,o._createMap(),o._markers=[],o._addStyle(),o._addMarkers(),google.maps.event.addDomListenerOnce(e,"load",function(){$('img[src="'+d+'"]').parent().addClass("region-map-point")}),o._map.addListener("click",function(){o.hideAll()}),a.classList.contains("js-do-not-click")||google.maps.event.addListenerOnce(o._map,"tilesloaded",function(){new google.maps.event.trigger(o._markers[0],"mouseover"),setTimeout(function(){new google.maps.event.trigger(o._markers[0],"click")},1e3)}))}var a=$("input[name=offer]"),r=parseFloat(a.data("startLat")),i=parseFloat(a.data("startLng")),n=a.data("startName"),l=parseFloat(a.data("endLat")),p=parseFloat(a.data("endLng")),s=a.data("endName"),c=a.data("imgTemplate"),m=a.data("imgPointer"),g={data:[{lat:r,lng:i,point:"Start: "+n,preview:c},{lat:l,lng:p,point:"End: "+s,preview:c}],meta:{name:""}},d=m;o.prototype._createMap=function(){var e=this,o=t.querySelector(".js-google-promo-map"),a=[{featureType:"all",elementType:"geometry",stylers:[{color:"#95CC72"}]},{featureType:"all",elementType:"labels.text.fill",stylers:[{color:"#f5f5f5"}]},{featureType:"water",elementType:"geometry",stylers:[{color:"#C5F4FE"}]},{featureType:"administrative.country",elementType:"geometry.stroke",stylers:[{color:"#f5f5f5"},{weight:.5}]},{featureType:"administrative_area_level_1",elementType:"labels.text",stylers:[{visibility:"off"}]},{featureType:"administrative.country",elementType:"labels.text",stylers:[{visibility:"on"}]},{featureType:"all",elementType:"labels.text.stroke",stylers:[{visibility:"off"}]}],n=new google.maps.StyledMapType(a,{name:"Styled Map"}),s=new google.maps.Map(o,{zoom:$("input[name=offer]").data("zoom"),draggable:!1,scrollwheel:!1,zoomControl:!0});s.setCenter(new google.maps.LatLng((l+r)/2,(p+i)/2)),s.mapTypes.set("map_style",n),s.setMapTypeId("map_style"),e._map=s},o.prototype.hideAll=function(){var e=this;e._markers.forEach(function(e){e.set("icon",d)}),$(".map-point-clicked").removeClass("map-point-clicked")},o.prototype._addStyle=function(){var e=t.createElement("style"),o=this._mapData.data;e.innerText=o.map(function(e){return'img[src="'+e.preview+'"]'}).join(", ")+" { border-radius: 50%; filter: grayscale(100%); border: 4px solid #fff !important; opacity: 0!important; display: block !important; } ",e.innerText+=o.map(function(e){return'img[src="'+e.preview+'"] + .region-map-point__title'}).join(", ")+" { display: block; } ",t.head.appendChild(e)},o.prototype._addMarker=function(t){var o=this,a=o._mapNode,r=o._map,i=new google.maps.Marker({position:{lat:t.lat,lng:t.lng},draggable:!1,icon:d,optimized:!1,title:t.point});return google.maps.event.addDomListener(i,"mouseover",function(){i.set("icon",t.preview),$(".google-promo-map .img-circle:not(.gmnoprint), .google-promo-map .img-circle").removeClass("hover"),e.util.waitFor(function(){return $('img[src="'+t.preview+'"]',a).length}).then(function(){$('img[src="'+t.preview+'"]',a).each(function(){var e=$(this).parent();e.addClass("hover"),e.find(".region-map-point__title").length||e.append('<span class="region-map-point__title">'+t.point+"</span>")})})["catch"](function(){console.log("can not load img")}),$('img[src="'+t.preview+'"]').parent().each(function(){$(this).css({"background-image":"url("+t.preview+")","background-size":"cover"})}),$(".google-promo-map .img-circle:not(.gmnoprint), .google-promo-map .img-circle").css({border:"4px solid #fff !important"})}),google.maps.event.addDomListener(i,"mouseout",function(){var e=$('img[src="'+t.preview+'"]');e.parent().hasClass("map-point-clicked")||(i.set("icon",d),e.parent().hasClass("map-point-clicked")||($(".google-promo-map .img-circle:not(.gmnoprint), .google-promo-map .img-circle").removeClass("hover"),$('img[src="'+t.preview+'"]').parent().each(function(){$(this).addClass("img-circle").removeClass("hover").css({"background-image":"url("+t.preview+")","background-size":"cover"})})))}),google.maps.event.addDomListener(i,"click",function(){o.hideAll(),i.set("icon",t.preview),$('img[src="'+t.preview+'"]').parent().each(function(){$(this).addClass("map-point-clicked"),$(this).addClass("map-point-clicked img-circle").css({"background-image":"url("+t.preview+")","background-size":"cover"})}),$(".google-promo-map .map-point-clicked.img-circle:not(.gmnoprint)").css({"border-color":"#6cb7ca"}),$("a.point-card__close.js-point-card__close").click(function(){$(".google-promo-map .img-circle:not(.gmnoprint), .google-promo-map .img-circle").removeClass("hover")})}),i.setMap(r),i},o.prototype._addMarkers=function(){var e=this,t=e._mapData;this._markers=t.data.map(e._addMarker,this)},e.onload=function(){new o}}(window,window.document);