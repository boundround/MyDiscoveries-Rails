var slider;

$(function() {
  $("#main-carousel").owlCarousel({
    autoPlay: 2000, //Set AutoPlay to 3 seconds
    items: 3,
    itemsDesktop: [1199, 3],
    itemsDesktopSmall: [979, 2],
    itemsTablet: [767, 3],
    itemsTabletSmall:[540,2],
    itemsMobile: [480, 1],
    stopOnHover:true,
    pagination:false
});
slider= $('.bxslider').bxSlider({
  auto:true,
  pager: false,
  controls:false
});
$('#slider-prev').click(function(e){
        e.preventDefault();
        slider.goToPrevSlide();
    });
$('#slider-next').click(function(e){
        e.preventDefault();
        slider.goToNextSlide();
    });

});

$(function() {
  $("#famous-carousel").owlCarousel({
    autoPlay: 2000, //Set AutoPlay to 3 seconds
    items: 3,
    itemsDesktop: [1199, 3],
    itemsDesktopSmall: [979, 2],
    itemsTablet: [767, 3],
    itemsTabletSmall:[540,2],
    itemsMobile: [480, 1],
    stopOnHover:true,
    pagination:false
});
slider= $('.bxslider').bxSlider({
  auto:true,
  pager: false,
  controls:false
});
$('#slider-prev').click(function(e){
        e.preventDefault();
        slider.goToPrevSlide();
    });
$('#slider-next').click(function(e){
        e.preventDefault();
        slider.goToNextSlide();
    });

});


$(function() {
    $('.br_main_content,.br_sidebar').matchHeight();
    $('.selectpicker').selectpicker();


    $(".br_sounds i").click(function(){

      $(this).parent().parent().parent().addClass('br_active');
      $(this).parent().parent().parent().siblings().removeClass('br_active');
    });
    var i=1;
    $('.br_mob_links a').click(function(e){
        e.preventDefault();

        if ($('.br_sidebar').hasClass('hidden-xs')) {
            $('.br_sidebar').removeClass('hidden-xs');
            $('.br_main_content').addClass('hidden-xs');
            $(this).addClass('hidden-xs');
            $(this).siblings().removeClass('hidden-xs');
        }
        else{
            $('.br_sidebar').addClass('hidden-xs');
            $('.br_main_content').removeClass('hidden-xs');
            $(this).addClass('hidden-xs');
            $(this).siblings().removeClass('hidden-xs');
        }
       slider.reloadSlider();

    });
});

$(document).ready(function(){
    var LANGUAGES = {"af":"Afrikaans","agq":"Aghem","ak":"Akan","sq":"Albanian","am":"Amharic","ar":"Arabic","hy":"Armenian","as":"Assamese","asa":"Asu","az":"Azerbaijani","ksf":"Bafia","bm":"Bambara","bas":"Basaa","eu":"Basque","be":"Belarusian","bem":"Bemba","bez":"Bena","bn":"Bengali","brx":"Bodo","bs":"Bosnian","br":"Breton","bg":"Bulgarian","my":"Burmese","ca":"Catalan","tzm":"Central Morocco Tamazight","chr":"Cherokee","cgg":"Chiga","zh":"Chinese","swc":"Congo Swahili","kw":"Cornish","hr":"Croatian","cs":"Czech","da":"Danish","dua":"Duala","nl":"Dutch","ebu":"Embu","en":"English","eo":"Esperanto","et":"Estonian","ee":"Ewe","ewo":"Ewondo","fo":"Faroese","fil":"Filipino","fi":"Finnish","fr":"French","ff":"Fulah","gl":"Galician","lg":"Ganda","ka":"Georgian","de":"German","el":"Greek","gu":"Gujarati","guz":"Gusii","ha":"Hausa","haw":"Hawaiian","he":"Hebrew","hi":"Hindi","hu":"Hungarian","is":"Icelandic","ig":"Igbo","id":"Indonesian","ga":"Irish","it":"Italian","ja":"Japanese","dyo":"Jola-Fonyi","kea":"Kabuverdianu","kab":"Kabyle","kl":"Kalaallisut","kln":"Kalenjin","kam":"Kamba","kn":"Kannada","kk":"Kazakh","km":"Khmer","ki":"Kikuyu","rw":"Kinyarwanda","kok":"Konkani","ko":"Korean","khq":"Koyra Chiini","ses":"Koyraboro Senni","nmg":"Kwasio","lag":"Langi","lv":"Latvian","ln":"Lingala","lt":"Lithuanian","lu":"Luba-Katanga","luo":"Luo","luy":"Luyia","mk":"Macedonian","jmc":"Machame","mgh":"Makhuwa-Meetto","kde":"Makonde","mg":"Malagasy","ms":"Malay","ml":"Malayalam","mt":"Maltese","gv":"Manx","mr":"Marathi","mas":"Masai","mer":"Meru","mfe":"Morisyen","mua":"Mundang","naq":"Nama","ne":"Nepali","nd":"North Ndebele","nb":"Norwegian Bokmål","nn":"Norwegian Nynorsk","nus":"Nuer","nyn":"Nyankole","or":"Oriya","om":"Oromo","ps":"Pashto","fa":"Persian","pl":"Polish","pt":"Portuguese","pa":"Punjabi","ro":"Romanian","rm":"Romansh","rof":"Rombo","rn":"Rundi","ru":"Russian","rwk":"Rwa","saq":"Samburu","sg":"Sango","sbp":"Sangu","seh":"Sena","sr":"Serbian","ksb":"Shambala","sn":"Shona","ii":"Sichuan Yi","si":"Sinhala","sk":"Slovak","sl":"Slovenian","xog":"Soga","so":"Somali","es":"Spanish","sw":"Swahili","sv":"Swedish","gsw":"Swiss German","shi":"Tachelhit","dav":"Taita","ta":"Tamil","twq":"Tasawaq","te":"Telugu","teo":"Teso","th":"Thai","bo":"Tibetan","ti":"Tigrinya","to":"Tongan","tr":"Turkish","uk":"Ukrainian","ur":"Urdu","uz":"Uzbek","vai":"Vai","vi":"Vietnamese","vun":"Vunjo","cy":"Welsh","yav":"Yangben","yo":"Yoruba","dje":"Zarma","zu":"Zulu"};
    var toTitleCase = function(str){
        return str.replace(/\w\S*/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
    }

    var countryCode = $('#country-data').data('country-code');
    var capitalCity = $('#country-data').data('capital-city');
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
                console.log(languages);
                if ($('#language').html() === ""){
                    for(var i = 0; i < languages.length; i++){
                        if(LANGUAGES[languages[i]]){
                            $('#language').append(LANGUAGES[languages[i]] + "<br>");
                        }
                    }
                }
                if (capitalCity === ""){
                    capitalCity = data.capital;
                }
            }

        });
    }

    $('.carousel-country-photo').on('click', function(){
        var carouselItems = $('.carousel-item');
        $('.owl-controls').show();
        if ($("#modal-carousel").has(".carousel-item").length === 0){
            $.each(carouselItems, function(index){
                var newImage = $(carouselItems[index]).clone()
                if($(carouselItems[index]).hasClass("carousel-video")){
                    newImage.removeAttr('id');
                    var a = $(carouselItems[index]).parent().find('.overlay').find('.carousel-like-icon')[0];
                    var b = $(a).clone();
                    console.log(b);
                    videoID = 'big-player-' + index;
                    newImage.attr('id', videoID).addClass('carousel-big-video');
                    $("#modal-carousel").append(newImage.css("height", "400px"));
                    newImage.wrap("<div></div>").after(b.css("top", "20px"));
                } else {
                    $(newImage).css("height", "100%");
                    newImage.find('.carousel-like-icon').css("right", "auto");
                    newImage.append("<div>" + newImage.find("img").data("caption")) + "</div>";
                    newImage.append("<div><a href='" + newImage.find("img").data("placeurl") + "'>Explore " + newImage.find("img").data("placename") + "</a></div>");
                    $("#modal-carousel").append(newImage);
                }
            });
            var bigVideos = $('.carousel-big-video');
            $.each(bigVideos, function(){
                title = $(this).data("title");
                description = $(this).data("description");
                $(this).wrap("<div></div>");
                $(this).parent().prepend(title).append(description);
            });

            $('.like-icon').on('click', function(e){
            e.preventDefault();
            e.stopPropagation();
            var postPath = $(this).data('postPath');
            var postType = $(this).data('postType');
            var data = {};
            switch(postType){
              case "photos_user":
                data[postType] = {user_id: $(this).data("user"), photo_id: $(this).data("contentId")};
                break;
              case "user_photos_user":
                data[postType] = {user_id: $(this).data("user"), user_photo_id: $(this).data("contentId")};
                break;
              case "stories_user":
                data[postType] = {user_id: $(this).data("user"), story_id: $(this).data("contentId")};
                break;
              case "reviews_user":
                data[postType] = {user_id: $(this).data("user"), review_id: $(this).data("contentId")};
                break;
              case "fun_facts_user":
                data[postType] = {user_id: $(this).data("user"), fun_fact_id: $(this).data("contentId")};
                break;
              case "games_user":
                data[postType] = {user_id: $(this).data("user"), game_id: $(this).data("contentId")};
                break;
              case "videos_user":
                data[postType] = {user_id: $(this).data("user"), video_id: $(this).data("contentId")};
                break;
              case "places_user":
                data[postType] = {user_id: $(this).data("user"), place_id: $(this).data("contentId")};
                break;
              case "areas_user":
                data[postType] = {user_id: $(this).data("user"), area_id: $(this).data("contentId")};
            }
            console.log($(this).data('liked'));
            if ($(this)[0].dataset.liked === 'false'){
              $(this).find('.like-heart').removeClass('fa-heart-o').removeClass("like-heart").addClass('fa-heart').addClass('liked-heart');
              $(this)[0].dataset.liked = 'true';
              $.ajax({
                type: "POST",
                url: '/' + postPath + '/create',
                data: data,
                success: console.log('LIKE SAVED')
              });
            } else if ($(this)[0].dataset.liked === 'true') {
                $(this).find('.liked-heart').removeClass('fa-heart').removeClass('liked-heart').addClass('fa-heart-o').addClass('like-heart');
                $(this)[0].dataset.liked = 'false';
                $.ajax({
                  type: "POST",
                  _method: 'delete',
                  url: '/' + postPath + '/destroy',
                  data: data,
                  success: console.log('LIKE DELETED')
                });
            } else {
              alert("You must be logged in to save favourites!");
            }
          });
        }
        $('#carousel-modal').modal("show");

        $("#modal-carousel").owlCarousel({
            items: 1,
            autoPlay: false,
            singleItem:true,
            stopOnHover:true,
            pagination:false,
            navigation: true
        });

        var owl = $("#modal-carousel").data('owlCarousel');

        owl.jumpTo($(this).data("slide-number"));
    });

    $('.content-length').keyup(function(){
      var len = $(this).val().length;
      $(this).closest(".form-group").find(".char-count").text(len);
    });
});
