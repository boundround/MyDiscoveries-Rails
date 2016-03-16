window.onload = function(){
  $("#pac-input").geocomplete({
    types: ['geocode', 'establishment'],
    map: ".map-canvas",
    markerOptions: {
      draggable: true
    },
    details: "body",
    detailsAttribute: "data-geo",
  });


  $("#pac-input")
    .geocomplete()
    .bind("geocode:dragged", function(event, result){
      // repopulate lat long and address fields on marker drag
      $("#pac-input").geocomplete("find", result.lat() + "," + result.lng());
    });
}

function detailsArea(){

var LANGUAGES = {"af":"Afrikaans","agq":"Aghem","ak":"Akan","sq":"Albanian","am":"Amharic","ar":"Arabic","hy":"Armenian","as":"Assamese","asa":"Asu","az":"Azerbaijani","ksf":"Bafia","bm":"Bambara","bas":"Basaa","eu":"Basque","be":"Belarusian","bem":"Bemba","bez":"Bena","bn":"Bengali","brx":"Bodo","bs":"Bosnian","br":"Breton","bg":"Bulgarian","my":"Burmese","ca":"Catalan","tzm":"Central Morocco Tamazight","chr":"Cherokee","cgg":"Chiga","zh":"Chinese","swc":"Congo Swahili","kw":"Cornish","hr":"Croatian","cs":"Czech","da":"Danish","dua":"Duala","nl":"Dutch","ebu":"Embu","en":"English","eo":"Esperanto","et":"Estonian","ee":"Ewe","ewo":"Ewondo","fo":"Faroese","fil":"Filipino","fi":"Finnish","fr":"French","ff":"Fulah","gl":"Galician","lg":"Ganda","ka":"Georgian","de":"German","el":"Greek","gu":"Gujarati","guz":"Gusii","ha":"Hausa","haw":"Hawaiian","he":"Hebrew","hi":"Hindi","hu":"Hungarian","is":"Icelandic","ig":"Igbo","id":"Indonesian","ga":"Irish","it":"Italian","ja":"Japanese","dyo":"Jola-Fonyi","kea":"Kabuverdianu","kab":"Kabyle","kl":"Kalaallisut","kln":"Kalenjin","kam":"Kamba","kn":"Kannada","kk":"Kazakh","km":"Khmer","ki":"Kikuyu","rw":"Kinyarwanda","kok":"Konkani","ko":"Korean","khq":"Koyra Chiini","ses":"Koyraboro Senni","nmg":"Kwasio","lag":"Langi","lv":"Latvian","ln":"Lingala","lt":"Lithuanian","lu":"Luba-Katanga","luo":"Luo","luy":"Luyia","mk":"Macedonian","jmc":"Machame","mgh":"Makhuwa-Meetto","kde":"Makonde","mg":"Malagasy","ms":"Malay","ml":"Malayalam","mt":"Maltese","gv":"Manx","mr":"Marathi","mas":"Masai","mer":"Meru","mfe":"Morisyen","mua":"Mundang","naq":"Nama","ne":"Nepali","nd":"North Ndebele","nb":"Norwegian Bokmål","nn":"Norwegian Nynorsk","nus":"Nuer","nyn":"Nyankole","or":"Oriya","om":"Oromo","ps":"Pashto","fa":"Persian","pl":"Polish","pt":"Portuguese","pa":"Punjabi","ro":"Romanian","rm":"Romansh","rof":"Rombo","rn":"Rundi","ru":"Russian","rwk":"Rwa","saq":"Samburu","sg":"Sango","sbp":"Sangu","seh":"Sena","sr":"Serbian","ksb":"Shambala","sn":"Shona","ii":"Sichuan Yi","si":"Sinhala","sk":"Slovak","sl":"Slovenian","xog":"Soga","so":"Somali","es":"Spanish","sw":"Swahili","sv":"Swedish","gsw":"Swiss German","shi":"Tachelhit","dav":"Taita","ta":"Tamil","twq":"Tasawaq","te":"Telugu","teo":"Teso","th":"Thai","bo":"Tibetan","ti":"Tigrinya","to":"Tongan","tr":"Turkish","uk":"Ukrainian","ur":"Urdu","uz":"Uzbek","vai":"Vai","vi":"Vietnamese","vun":"Vunjo","cy":"Welsh","yav":"Yangben","yo":"Yoruba","dje":"Zarma","zu":"Zulu"};
    // var toTitleCase = function(str){
    //     return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
    // }

    var countryCode = $('#country-data').data('country-code');
    // var capitalCity = $('#country-data').data('capital-city');
    var languages;
    if (countryCode){
        $.ajax({
            url: "//restcountries.eu/rest/v1/alpha/" + countryCode,
            type: "GET",
            success: function(data){
                console.log(data);
                var population = data.population.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                $('#country-population').append(population);
                languages = data.languages;
                // console.log(languages);
                if ($('#language').html() === ""){
                    for(var i = 0; i < languages.length; i++){
                        if(LANGUAGES[languages[i]]){
                            $('#language').append(LANGUAGES[languages[i]] + "<br>");
                        }
                    }
                }
                // if (capitalCity === ""){
                //     capitalCity = data.capital;
                // }
            }

        });
    }
}

$(document).ready(function() {
    detailsArea();
});
