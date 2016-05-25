// Add to Wishlist
function addToFav() {
    $(".icon-favourite").on('click', function(e) {
        var icon = $(this);
        var userId = $(this).data("user-id");
        var placeId = $(this).data("place-id");
        data = {};
        data["places_user"] = { user_id: userId, place_id: placeId };
        if (userId === "no-user") {
            $("#myModal").modal();
        } else if ($(this).data("liked") === false) {
            $.ajax({
                type: "POST",
                url: '/places_users/create',
                data: data,
            });
            $(".favourites-title").text("Remove From Favourites");
            $(".text-favourite-place").text("Remove From Favourites");
            $(this).data("liked", true);
            icon.addClass("selected");
        } else if ($(this).data("liked") === true) {
            $.ajax({
                type: "POST",
                _method: 'delete',
                url: '/places_users/destroy',
                data: data,
            });
            $(".favourites-title").text("Add To Favourites");
            $(".text-favourite-place").text("Add To Favourites");
            $(this).data("liked", false);
            icon.removeClass("selected");
        }
    });
}

function allMap() {
    if (document.getElementById('map')) {
        var getPlaceDetails = function(place) {
            var map = new google.maps.Map(document.getElementById('map'), {
                center: new google.maps.LatLng($('.area-content').data('lat'), $('.area-content').data('long')),
                zoom: 13
            });

            var location = {
                "lat": $('.area-content').data('lat'),
                "lng": $('.area-content').data('long')
            };

            var marker = new google.maps.Marker({
                map: map,
                position: location
            });

            var service = new google.maps.places.PlacesService(map);
            var request = {
                placeId: place
            };
            service.getDetails(request, function(place, status) {
                if (status == google.maps.places.PlacesServiceStatus.OK) {

                    var i;
                    var day = new Date();
                    if (place.opening_hours) {
                        var openingHours = place.opening_hours.weekday_text;
                    }
                    if (openingHours) {
                        $('#hours').html("Hours:  ")
                        var placeInfo = "";
                        for (i = 0; i < openingHours.length; i++) {
                            if (day.getDay() === i && place.opening_hours.open_now === true) {
                                placeInfo += openingHours[i] + "<span id='open-now'>&nbsp;&nbsp;Open Now</span><br>"
                            } else {
                                placeInfo += openingHours[i] + "<br>";
                            }
                        }
                    }
                    if (placeInfo) {
                        $('#operating-hours').html(placeInfo);
                    }

                }
            });
        };

        getPlaceDetails($('#place-id').data("place"));
    }
}

function setUpLoadMore() {
    var sec_card = $("section.cards")
    $.each(sec_card, function(index, val) {
        var cards = $(val).find(".card")
        btn = $(val).find(".load-more")
        if (cards.length > 3) {
            cards.slice(-3).hide();
            btn.click(function() {
                cards.slice(-3).show();
                btn.remove();
            });
        } else {
            btn.remove();
        }
    });

    var content = $(".review-content");
    content.css("cursor", "pointer");
    $.each(content, function(index, val) {
        $(val).click(function() {
            $(this).find(".some-text").html($(this).find(".some-text").data("full-text"));
        });
    });

    $(".readmore-area").click(function(event) {
        $(".destination-desc").siblings(".destination-desc").toggle();
        $(".readmore-area").siblings(".readmore-area").toggle();
    });

    var blog_text = $(".blog-content");
    $.each(blog_text, function(index, val) {
        text = $(val).text();
        $(val).text(text.substring(0, 280) + "...");
    });
}

function setupModal() {
    $(".story[data-class='apiblog']").click(function() {
        var id = $(this).data("id");
        place = $(this).data("place");
        image = $(this).data("image");
        place_name = $(this).data("place-name");
        category = $(this).data("cat");
        host = document.location.origin;
        $("#modal-dialog-story").hide();
        $("#modal-dialog-blog").show();
        if (category == "") {
            $("#show-story-modal iframe").prop("src", host + "/wp-blog/" + id + "/" + place);
        } else {
            $("#show-story-modal iframe").prop("src", host + "/wp-blog/" + id + "/" + category);
        }

        $("#show-story-modal .modal-dialog").css("max-width", "1120px");
        $("#show-story-modal").modal();
        $("#modal-dialog-story").hide();
        $("#modal-dialog-blog").show();
    });

    $(".story[data-class='story']").on('click', function(e) {
        var title = $(this).data('title');
        user = $(this).data('user');
        content = $(this).data('content');
        image1 = $(this).data('image-0');

        image2 = $(this).data('image-1');
        image3 = $(this).data('image-2');
        $('#story-user').html("by : " + user);
        $('#story-title').html(title);
        $('#story-content').html(content);
        if (image1)
            $('#storyHeroImage').prepend("<div id='image-1' class='img-cont share story-hero-container'><img src=" + image1 + " class='story-image'></div>");
        if (image2)
            $('#story-image-2a').prepend('<div id="image-2" class="pull-right side-img-cont share"><div class="share-btn"><img src=' + image2 + ' class="story-image"></div></div>');
        if (image3)
            $('#story-image-3a').html("<div id='image-3' class='img-cont2 share z-up'><div class='share-btn'><img src=" + image3 + " class='story-image'></div></div>");
        $("#show-story-modal").modal();
        $("#modal-dialog-story").show();
        $("#modal-dialog-blog").hide();
    });

    $('#story-close').on('click', function() {
        $('#image-1').remove();
        $('#image-2').remove();
        $('#image-3').remove();
    });
}

function setUpfileUpload(input, list) {
    $(input).MultiFile({
        list: list,
        max: 10,
        accept: 'jpg|png|gif|mp4|3gp'
    });
}

function responsiveModalVideo() {

    var iframe = $(".responsive-video-modal iframe");
    // 4k 5k
    if ($(window).width() >= 5000) {
        iframe.prop("width", "100%");
        iframe.prop("height", "1950px");
    } else if (($(window).width() >= 3000) && ($(window).width() < 5000)) {
        iframe.prop("width", "100%");
        iframe.prop("height", "1550px");
    }
    // 3k
    else if (($(window).width() >= 1920) && ($(window).width() < 3000)) {
        iframe.prop("width", "100%");
        iframe.prop("height", "830px");
    }
    // FHD
    else if (($(window).width() >= 1024) && ($(window).width() < 1920)) {
        iframe.prop("width", "920px");
        iframe.prop("height", "525px");
    }
    // Large Device(tablets)
    else if (($(window).width() >= 500) && ($(window).width() < 1024)) {
        iframe.prop("width", "600px");
        iframe.prop("height", "345px");
    }
    // Small Device
    else if (($(window).width() > 415) && ($(window).width() < 500)) {
        iframe.prop("width", "320px");
        iframe.prop("height", "180px");
    }
    // Extra Small Device
    else if ($(window).width() <= 414) {
        iframe.prop("width", "270px");
        iframe.prop("height", "155px");
    }
}

function chooseHero() {
    $('input[name="hero_image"]').click(function() {
        $('input[name="hero_image"]').not(this).prop('checked', false);
        $(this).prop('checked', true);
        var type = $(this).data("type");
        place_id = $(this).data("place");
        photo_id = $(this).data("photo");
        if (type) {
            window.location = '/places/' + place_id + '/update_hero/' + type + '/' + photo_id
        } else {
            alert("choose another image");
        }
    });


}
$(window).resize(function() {
    responsiveModalVideo();
});

$(document).ready(function() {
    $('#publish-review-button').on('click', function() {
        $('#ReviewModal').modal("hide");
    })
    $('.place-date').datepicker();

    chooseHero();
    setUpfileUpload('.file-upload', '.lis-file-upload');
    setUpfileUpload('.file-upload2', '.lis-file-upload2');
    setUpfileUpload();
    addToFav();
    setUpLoadMore();
    setupModal();
    responsiveModalVideo();

    if ($('#map').length) {
        var map = new google.maps.Map(document.getElementById('map'), {
            center: new google.maps.LatLng($('.area-content').data('lat'), $('.area-content').data('long')),
            zoom: 13
        });

        if ($("#place-opening-hours").length) {

            opening_hours = $("#place-opening-hours");
            place_id = opening_hours.data('place-id');

            var service = new google.maps.places.PlacesService(map);
            var request = {
                placeId: place_id
            };

            service.getDetails(request, function(place, status) {
                if (status == google.maps.places.PlacesServiceStatus.OK) {
                    var i;
                    var day = new Date();
                    if (place.opening_hours) {
                        var openingHours = place.opening_hours.weekday_text;
                    }
                    var placeInfo = '<p class="text-center"><b>No schedule found</b></p>';
                    if (openingHours) {
                        placeInfo = '';
                        for (i = 0; i < openingHours.length; i++) {
                            open_now = '';
                            if (day.getDay() === i && place.opening_hours.open_now === true) {
                                open_now = '<span class="label label-info">Open now</span>';
                            }
                            schedule = openingHours[i];
                            schedule = schedule.split(' ');
                            placeInfo += '<div class="modal-footer">';
                            placeInfo += '<div class="col-xs-12 col-sm-12" align="left">';
                            placeInfo += '  <p> ' + schedule.shift() + ' ' + open_now + '</p>';
                            placeInfo += '  <p><b>' + schedule.join(' ') + '</b></p>';
                            placeInfo += ' </div>';
                            placeInfo += '</div>';
                        }
                    }
                    modal_target = opening_hours.data('target');
                    if ($(modal_target).length) {
                        $(modal_target).find("div.modal-footer").remove();
                        $(modal_target).find('div.modal-content').append(placeInfo)
                    }
                }
            });
        }
    }

});
