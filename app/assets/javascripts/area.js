function mapAdmin(){
  if (document.querySelector("#pac-input")){
    var latLong = [];
    var latitude = document.querySelector("#latitude");
    var longitude = document.querySelector("#longitude");
    if(latitude){
      latLong.push(latitude.innerHTML);
    }
    if(longitude){
      latLong.push(longitude.innerHTML);
    }

    if(latLong.length !== 2){
      latLong = [-33.8688, 151.2093]
    }

    $("#pac-input").geocomplete({
      types: ['geocode', 'establishment'],
      map: "#map-canvas",
      location: latLong,
      geolocate: true,
      markerOptions: {
        draggable: true
      },
      details: "body",
      detailsAttribute: "data-geo",
    });

    var service = new google.maps.places.PlacesService($("#pac-input").geocomplete("map"));
    var zoom_level_region = $('#region_zoom_level').val(),
        zoom_level_place = $('#place_zoom_level').val();
    if((zoom_level_region == undefined || zoom_level_region == '') && (zoom_level_place == undefined || zoom_level_place == '')){
        $("#pac-input").geocomplete("map").setZoom(4)
    }else{
      if(zoom_level_region != undefined){
        parseZoom = parseInt(zoom_level_region)
      }else if(zoom_level_place != undefined){
        parseZoom = parseInt(zoom_level_place)
      }
      $("#pac-input").geocomplete("map").setZoom(parseZoom)
    }

    $("#pac-input")
      .geocomplete()
      .bind("geocode:dragged", function(event, result){
        // repopulate lat long and address fields on marker drag
        $("#pac-input").geocomplete("find", result.lat() + "," + result.lng());
      })
      .bind("geocode:idle", function(event, result){
        var controller = $('.container').data("controller").slice(0, -1);
        $('#'+ controller +'_zoom_level').val($("#pac-input").geocomplete("map").zoom)
        $('#zoom_text').text($('#'+ controller +'_zoom_level').val())
      });

    }
}

$(window).load(function(){
  if($('.container').data("controller") != "product"){
    mapAdmin()
  }else{
    $('#accordion .panel.panel-default').click(function(){
      mapAdmin()
    })
  }

  if (document.querySelector('#pickup-address-autocomplete')){
    $("#pickup-address-autocomplete").geocomplete({
      map: "#map-canvas",
      geolocate: true,
      details: "body"
    });
  }

  if (document.querySelector('#pickup-address-autocomplete')){
    $("#dropoff-airport-autocomplete").geocomplete({
      map: "#map-canvas-2",
      geolocate: true,
      details: "body"
    });
  }

})

function detailsArea(){
  var LANGUAGES = {"af":"Afrikaans","agq":"Aghem","ak":"Akan","sq":"Albanian","am":"Amharic","ar":"Arabic","hy":"Armenian","as":"Assamese","asa":"Asu","az":"Azerbaijani","ksf":"Bafia","bm":"Bambara","bas":"Basaa","eu":"Basque","be":"Belarusian","bem":"Bemba","bez":"Bena","bn":"Bengali","brx":"Bodo","bs":"Bosnian","br":"Breton","bg":"Bulgarian","my":"Burmese","ca":"Catalan","tzm":"Central Morocco Tamazight","chr":"Cherokee","cgg":"Chiga","zh":"Chinese","swc":"Congo Swahili","kw":"Cornish","hr":"Croatian","cs":"Czech","da":"Danish","dua":"Duala","nl":"Dutch","ebu":"Embu","en":"English","eo":"Esperanto","et":"Estonian","ee":"Ewe","ewo":"Ewondo","fo":"Faroese","fil":"Filipino","fi":"Finnish","fr":"French","ff":"Fulah","gl":"Galician","lg":"Ganda","ka":"Georgian","de":"German","el":"Greek","gu":"Gujarati","guz":"Gusii","ha":"Hausa","haw":"Hawaiian","he":"Hebrew","hi":"Hindi","hu":"Hungarian","is":"Icelandic","ig":"Igbo","id":"Indonesian","ga":"Irish","it":"Italian","ja":"Japanese","dyo":"Jola-Fonyi","kea":"Kabuverdianu","kab":"Kabyle","kl":"Kalaallisut","kln":"Kalenjin","kam":"Kamba","kn":"Kannada","kk":"Kazakh","km":"Khmer","ki":"Kikuyu","rw":"Kinyarwanda","kok":"Konkani","ko":"Korean","khq":"Koyra Chiini","ses":"Koyraboro Senni","nmg":"Kwasio","lag":"Langi","lv":"Latvian","ln":"Lingala","lt":"Lithuanian","lu":"Luba-Katanga","luo":"Luo","luy":"Luyia","mk":"Macedonian","jmc":"Machame","mgh":"Makhuwa-Meetto","kde":"Makonde","mg":"Malagasy","ms":"Malay","ml":"Malayalam","mt":"Maltese","gv":"Manx","mr":"Marathi","mas":"Masai","mer":"Meru","mfe":"Morisyen","mua":"Mundang","naq":"Nama","ne":"Nepali","nd":"North Ndebele","nb":"Norwegian Bokmål","nn":"Norwegian Nynorsk","nus":"Nuer","nyn":"Nyankole","or":"Oriya","om":"Oromo","ps":"Pashto","fa":"Persian","pl":"Polish","pt":"Portuguese","pa":"Punjabi","ro":"Romanian","rm":"Romansh","rof":"Rombo","rn":"Rundi","ru":"Russian","rwk":"Rwa","saq":"Samburu","sg":"Sango","sbp":"Sangu","seh":"Sena","sr":"Serbian","ksb":"Shambala","sn":"Shona","ii":"Sichuan Yi","si":"Sinhala","sk":"Slovak","sl":"Slovenian","xog":"Soga","so":"Somali","es":"Spanish","sw":"Swahili","sv":"Swedish","gsw":"Swiss German","shi":"Tachelhit","dav":"Taita","ta":"Tamil","twq":"Tasawaq","te":"Telugu","teo":"Teso","th":"Thai","bo":"Tibetan","ti":"Tigrinya","to":"Tongan","tr":"Turkish","uk":"Ukrainian","ur":"Urdu","uz":"Uzbek","vai":"Vai","vi":"Vietnamese","vun":"Vunjo","cy":"Welsh","yav":"Yangben","yo":"Yoruba","dje":"Zarma","zu":"Zulu"};
  var countryCode = $('#country-data').data('country-code');
  var languages;
  if (countryCode){
    $.ajax({
      url: "//restcountries.eu/rest/v1/alpha/" + countryCode,
      type: "GET",
      success: function(data){
        var population = data.population.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        var region = data.region;
        $('#country-population').append(population);
        $('#region').append(region);
        languages = data.languages;
        if ($('#language').html() === ""){
          for(var i = 0; i < languages.length; i++){
            if(LANGUAGES[languages[i]]){
              $('#language').append(LANGUAGES[languages[i]] + "<br>");
            }
          }
        }
      }
    });
  }
}
$(document).ready(function() {
  //detailsArea();
});
