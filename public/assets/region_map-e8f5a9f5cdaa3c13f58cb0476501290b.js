!function(e,i){"use strict";function t(){var t=this,a=i.querySelector(".js-google-promo-map");a&&(t._mapNode=a,t._mapData=o,t._createMap(),t._markers=[],t._addStyle(),t._addMarkers(),google.maps.event.addDomListenerOnce(e,"load",function(){$('img[src="'+p+'"]').parent().addClass("region-map-point").css("width","50px")}),t._map.addListener("click",function(){t.hideAll()}),a.classList.contains("js-do-not-click")||google.maps.event.addListenerOnce(t._map,"tilesloaded",function(){new google.maps.event.trigger(t._markers[0],"mouseover"),setTimeout(function(){new google.maps.event.trigger(t._markers[0],"click")},1e3)}))}function a(e){e&&$("style.map-click").remove()}var r=$("input[name=region]").data("marker").split(', ["@"]');r.pop();var s=function(){var e=[];return $.each(r,function(i,t){var a={},r=t.split(', "#');a.point=r[0].split("=>")[1].slice(1,-1),a.lat=parseFloat(r[1].split("=>")[1]),a.lng=parseFloat(r[2].split("=>")[1]),r[3].length>150?a.description=r[3].split("=>")[1].slice(1,-1).substr(0,150)+" ...":a.description=r[3].split("=>")[1].slice(1,-1),a.country=r[4].split("=>")[1].slice(1,-1),a.preview=r[6].split("=>")[1].slice(1,-1),a["inner-cards"]=[],a.path=r[5].split("=>")[1].slice(1,-1);var s=r[7].split(', ["#"]');s.pop(),$.each(s,function(e,i){var t={},r=i.split('"@');r.shift(),t.img=r[2].split("=>")[1].slice(1,-2),t.header=r[0].split("=>")[1].slice(1,-3),t.description=r[1].split("=>")[1].slice(1,-3),a["inner-cards"].push(t)}),e.push(a)}),e},o={meta:{name:"Ebash karty, bleat'!!!"},data:s()},n=['<div class="point-card js-point-card" style="opacity: 1; transform: translate3d(0px, 0px, 0px);">','<h3 class="point-card__header">{{= it.country }}</h3>','<h4 class="point-card__local-header">{{= it.point }}</h4>','<div class="point-card__local-description">{{= it.description }}</div>','<div class="scroll-area" style="overflow: scroll;">','<div class="scroll-area__swiper-container swiper-container swiper-container-vertical swiper-container-free-mode">','<div class="scroll-area__content swiper-wrapper" style="transform: translate3d(0px, 0px, 0px);">','<div class="swiper-slide swiper-slide-active">',"{{~ it['inner-cards'] :item }}",'<div class="region-preview-item">','<img src="{{= item.img }}" alt="" class="region-preview-item__image">','<h3 class="region-preview-item__header">{{= item.header }}</h3>','<p class="region-preview-item__paragraph">{{= item.description }}</p></div>',"{{~}}","</div>","</div>","</div>",'<div class="swiper-scrollbar" style="transition-duration: 400ms;"></div>',"</div>",'<a href="{{= it.path }}" class="card-go-to"><span class="card-go-to__text card-go-to__text--go-to">go to</span>','<span class="card-go-to__text">{{= it.point}}</span></a></div>'].join(""),l=doT.compile(n),p="/assets/img/map/map-point.svg";t.prototype._createMap=function(){var e=this,t=i.querySelector(".js-google-promo-map"),a=[{featureType:"all",elementType:"geometry",stylers:[{color:"#95CC72"}]},{featureType:"all",elementType:"labels.text.fill",stylers:[{color:"#f5f5f5"}]},{featureType:"water",elementType:"geometry",stylers:[{color:"#C5F4FE"}]},{featureType:"administrative.country",elementType:"geometry.stroke",stylers:[{color:"#f5f5f5"},{weight:.5}]},{featureType:"administrative_area_level_1",elementType:"labels.text",stylers:[{visibility:"off"}]},{featureType:"administrative.country",elementType:"labels.text",stylers:[{visibility:"on"}]},{featureType:"all",elementType:"labels.text.stroke",stylers:[{visibility:"off"}]}],r=new google.maps.StyledMapType(a,{name:"Styled Map"}),s=new google.maps.Map(t,{zoom:$("input[name=region]").data("zoom"),center:e._mapData.data[0],draggable:!1,scrollwheel:!1,zoomControl:!1});s.mapTypes.set("map_style",r),s.setMapTypeId("map_style"),e._map=s},t.prototype.hideAll=function(){var e=this;e._markers.forEach(function(e){e.set("icon",p)}),$(".map-point-clicked").removeClass("map-point-clicked"),e.hideCard()},t.prototype._addStyle=function(){var e=i.createElement("style"),t=this._mapData.data;e.innerText=t.map(function(e){return'img[src="'+e.preview+'"]'}).join(", ")+" { border-radius: 50%; filter: grayscale(100%); border: 4px solid #fff !important; opacity: 0!important; display: block !important; } ",e.innerText+=t.map(function(e){return'img[src="'+e.preview+'"] + .region-map-point__title'}).join(", ")+" { display: block; } ",i.head.appendChild(e)},t.prototype.showCard=function(e){var i,t=this,a=t._mapData.data,r={};t.hideCard(),a.every(function(i){return i.point===e?(r=i,!1):!0}),i=l(r),$(".js-promo-map").append(i).find(".js-point-card__close").on("click",function(e){e.preventDefault(),t.hideAll()});var s=$(".js-point-card").get(0);if(s){var o=new TimelineLite;o.from(s,1,{top:-100,opacity:0,force3D:!0})}var n=$(".js-point-card .region-preview-item");$(".js-point-card .swiper-slide").height(n.length*(n.height()+10));new Swiper(".js-point-card .swiper-container",{scrollbar:".swiper-scrollbar",direction:"vertical",slidesPerView:"auto",mousewheelControl:!0,freeMode:!0})},t.prototype.hideCard=function(){var e=$(".js-point-card").get(0);if(e){e.classList.remove("js-point-card");var i=new TimelineLite({onComplete:function(){e.parentNode.removeChild(e)}});i.to(e,1,{top:100,opacity:0,force3D:!0})}},t.prototype._addMarker=function(e){var i=this,t=(i._mapNode,i._map),r=new google.maps.Marker({position:{lat:e.lat,lng:e.lng},draggable:!1,icon:p,optimized:!1,title:e.point});return google.maps.event.addDomListener(r,"mouseover",function(){r.set("icon",e.preview);var i=$('.image-marker:contains("'+e.point+'")').parent();$('img[src="'+e.preview+'"]').siblings().hasClass("image-marker")||$('img[src="'+e.preview+'"]').parent().append('<div class="image-marker" style="background-image: url('+e.preview+')">'+e.point+"</div>"),i.addClass("hover")}),google.maps.event.addDomListener(r,"mouseout",function(){var i=$('img[src="'+e.preview+'"]');if(!i.parent().hasClass("map-point-clicked")){var t=$('img[src="'+e.preview+'"]').parent();r.set("icon",p),a(!0),i.parent().hasClass("map-point-clicked")||t.removeClass("hover")}}),google.maps.event.addDomListener(r,"click",function(){a(!0),i.hideAll(),r.set("icon",e.preview),i.showCard(r.title);var t=$('img[src="'+e.preview+'"]').parent();$('img[src="'+e.preview+'"]').siblings().hasClass("image-marker")||$('img[src="'+e.preview+'"]').parent().append('<div class="image-marker" style="background-image: url('+e.preview+')">'+e.point+"</div>"),$(".gm-style div").removeClass("marker-clicked map-point-clicked hover"),0==$(".marker-clicked").length&&setTimeout(function(){t.addClass("marker-clicked map-point-clicked")},100)}),r.setMap(t),r},$(".js-google-promo-map").click(function(){0==$(".marker-clicked").length&&0==$(".hover").length||($(".gm-style div").removeClass("marker-clicked map-point-clicked"),$(".gm-style div").removeClass("hover"))}),t.prototype._addMarkers=function(){var e=this,i=e._mapData;this._markers=i.data.map(e._addMarker,this)},e.onload=function(){new t}}(window,window.document);