function setUpChart() {
    if (($("#chart-area").length) || ($("#chart-area2").length)) {
        var ctx = $("#chart-area")[0].getContext("2d");

        window.myDoughnut = new Chart(ctx).Doughnut(doughnutData, { responsive: true });

        var ctx2 = $("#chart-area2")[0].getContext("2d");
        window.myDoughnut = new Chart(ctx2).Doughnut(doughnutData2, { responsive: true });
    }
}
var doughnutData = [{
        value: 300,
        color: "#F7464A",
        highlight: "#FF5A5E",
        label: "Red"
    }, {
        value: 50,
        color: "#46BFBD",
        highlight: "#5AD3D1",
        label: "Green"
    }, {
        value: 100,
        color: "#FDB45C",
        highlight: "#FFC870",
        label: "Yellow"
    }, {
        value: 40,
        color: "#949FB1",
        highlight: "#A8B3C5",
        label: "Grey"
    }, {
        value: 120,
        color: "#4D5360",
        highlight: "#616774",
        label: "Dark Grey"
    }

];
var doughnutData2 = [{
        value: 300,
        color: "#F7464A",
        highlight: "#FF5A5E",
        label: "Red"
    }, {
        value: 50,
        color: "#46BFBD",
        highlight: "#5AD3D1",
        label: "Green"
    }, {
        value: 100,
        color: "#FDB45C",
        highlight: "#FFC870",
        label: "Yellow"
    }, {
        value: 40,
        color: "#949FB1",
        highlight: "#A8B3C5",
        label: "Grey"
    }, {
        value: 120,
        color: "#4D5360",
        highlight: "#616774",
        label: "Dark Grey"
    }

];

function funFact() {
    var position = $(".position-js");
    $.each(position, function(index, val) {
        if (index % 2 != 0) {
            $(val).find('.fun-image').css({ "float": "right", "margin": "0" });
            $(val).find('.number').css({ "left": "89px" });
        }
    });
    item = $("#carousel-fun-fact").find(".item")[0]
    $(item).addClass("active");
}

function setupNav() {
    $(".navbar-toggle").click(function() {
        if ($(this).attr("aria-expanded") == "false") {
            $(this).find(".fa-bars").hide();
            $(this).find(".fa-times").show();
        } else {
            $(this).find(".fa-bars").show();
            $(this).find(".fa-times").hide();
        }
    });

    $("#fa-search-nav-xs").click(function(event) {
        $("#menu-nav").hide();
        $("#search-nav").show();
        $(".search-nav-mobile").focus();
    });

    $("#fa-times-nav-xs").click(function(event) {
        $("#search-nav").hide();
        $("#menu-nav").show();
    });
}

function setImagesPosition() {
    var outer = $(".outer-js"); //div outer image
    // var image = $(".inner-js");
    $.each(outer, function(index, val) {
        var outerHeight = $(val).height();
        outerWidth = $(val).width();
        inner = $(val).find(".inner-js") //image innner outer div
        if (inner.height() > outerHeight) {
            margin = inner.height() - outerHeight;
            margin = margin / 2;
            $(inner).css({ "position": "relative", "top": -margin });
        } else {
            $(inner).css({ "position": "relative", "width": "initial", "height": "100%" });
            setTimeout(function() {
                margin = inner.width() - outerWidth;
                margin = margin / 2;
                $(inner).css({ "left": -margin });
            }, 1000);
        }
    });

    setTimeout(function() {
        var top_outer = $(".top-outer-js");

        $.each(top_outer, function(index, val) {
            var outerHeight = $(val).height();
            outerWidth = $(val).width();
            inner = $(val).find(".top-inner-js") //image innner outer div

            if (inner.height() > outerHeight) {
                margin = inner.height() - outerHeight;
                margin = margin / 2;
                $(inner).css({ "top": -margin });
            }
        });
    }, 1000);
}

function setModalOpeningHour() {
    $('#OpeningHourModal').on('shown.bs.modal', function() {
        $('#myInput').focus()
    });
}

function setModalTickets() {
    $('#TicketsModal').on('shown.bs.modal', function() {
        $('#myInput').focus()
    });
}

function setModalReview() {
    $('#ReviewModal').on('shown.bs.modal', function() {
        $('#myInput').focus()
    });
}

function setModalPhoto() {
    $('#PhotoModal').on('shown.bs.modal', function() {
        $('#myInput').focus()
    });
}

function setModalEditPhoto() {
    $('#EditPhotoModal').on('shown.bs.modal', function() {
        $('#myInput').focus()
    });

    $(".edit-photo").on('click', function() {
        $('#EditPhotoModal').modal('hide');
        $('#EditPhotoDataModal').modal('show');
    });

    $(".back-edit-photo").on('click', function() {
        $('#EditPhotoModal').modal('show');
        $('#EditPhotoDataModal').modal('hide');
    });
}

function setUpModalUserPhoto() {
    $("#user_photo_path").hide();
    $("#icon-upload").click(function(event) {
        $("#user_photo_path").click();
    });
    $("#image-preview").click(function(event) {
        $("#user_photo_path").click();
    });


}

function getThumbnail() {
    var video = $(".play-in-modal");
    if (video.length > 0) {
        $.each(video, function(key, value) {
            var id = $(value).data("id");
            if ($(value).data("video") == "youtube" && $(value).data("thumb") == "") {
                $(value).css({ "background-image": "url(http://img.youtube.com/vi/" + id + "/maxresdefault.jpg" });
            } else if ($(value).data("video") == "vimeo" && $(value).data("thumb") == "") {
                var url = "https://vimeo.com/api/oembed.json?url=https%3A//vimeo.com/" + id;
                $.getJSON(url, function(data) {
                    $(value).css({ "background-image": "url(" + data.thumbnail_url + ")" });
                });

            }
        });
    }
}


$(document).ready(function() {
    getThumbnail();
    setUpModalUserPhoto();
    setModalOpeningHour();
    setModalTickets();
    setModalReview();
    setModalPhoto();
    setModalEditPhoto();
    setupNav();
    setImagesPosition();
    funFact();
    setUpChart();

    if (document.getElementById('icon')) {
        var lon = $('.area-content').data('long');
        var lat = $('.area-content').data('lat');

        $.ajax({
            url: "https://api.forecast.io/forecast/c652be9c98a1353375baff9c36ba0787/" + lat + "," + lon,
            dataType: 'jsonp',
            success: function(data) {

                var farenheit = data.currently.temperature;
                var temperature = Math.round((farenheit - 32) * 5 / 9);
                var iconString = data.currently.icon;
                icon = "/assets/images/" + iconString + ".png"; // source
                $('#temperature').append(temperature + "&deg; C"); // append to DOM #ID temperature
                document.getElementById("icon").src = icon; // JavaScript change img src
            }
        });
    }

    function setAvatarPosition() {
        var img = $(".img-rounded.edit-profile img");


        $.each(img, function(index, val) {
            setTimeout(function() {
                if ($(val).height() < 200) {
                    $(val).css({ "height": "200px", "max-width": "initial" });
                }
            }, 500);

            setTimeout(function() {

                if ($(val).width() > 200) {
                    width = $(val).width();

                    width_plus = width - 200;

                    margin = width_plus / 2;

                    $(val).css({ "left": -margin });


                }
            }, 500);
        });
    }

    if (!document.querySelector("#edit-story-page")){
      var content_editable = new MediumEditor('.content-editable', {
            placeholder: {
                text: 'Tell your story',
            },
            targetBlank: true,
            autoLink: true,
            toolbar: {
              /* These are the default options for the toolbar,
                 if nothing is passed this is what is used */
              allowMultiParagraphSelection: true,
              buttons: ['bold', 'italic', 'underline', 'anchor', 'h2', 'h3', 'h4', 'quote'],
              diffLeft: 0,
              diffTop: -10,
              firstButtonClass: 'medium-editor-button-first',
              lastButtonClass: 'medium-editor-button-last',
              relativeContainer: null,
              standardizeSelectionStart: false,
              static: false,
              /* options which only apply when static is true */
              align: 'center',
              sticky: false,
              updateOnEmptySelection: false
          }
      });
    } else {
      var content_editable = new MediumEditor('.content-editable', {
        placeholder: {
            text: ''
        },
        targetBlank: true,
        toolbar: {
          /* These are the default options for the toolbar,
             if nothing is passed this is what is used */
          allowMultiParagraphSelection: true,
          buttons: ['bold', 'italic', 'underline', 'anchor', 'h2', 'h3', 'h4', 'quote'],
          diffLeft: 0,
          diffTop: -10,
          firstButtonClass: 'medium-editor-button-first',
          lastButtonClass: 'medium-editor-button-last',
          relativeContainer: null,
          standardizeSelectionStart: false,
          static: false,
          /* options which only apply when static is true */
          align: 'center',
          sticky: false,
          updateOnEmptySelection: false
      }
      });

    }
    $(function() {
      console.log("autosaving");
      if ($("#new_story").length > 0) {
        setTimeout(autoSaveStory, 30000);
      }
    });

    function autoSaveStory() {
      $.ajax({
        type: "POST",
        url: "/stories/autosave",
        data: $("#new_story").serialize(),
        dataType: "JSON",
        success: function(data) {
          console.log(data);
        }
      });
      //setTimeout(autoSaveStory, 60000);
    }

    $(function() {
        $('.content-editable').mediumInsert({
            editor: content_editable,
            addons: {
                images: {
                    deleteScript: '/users/resolvejs',
                    fileUploadOptions: {


                        url: '/users/resolvejs',
                        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
                    }
                }
            }
        });
    });

    $("#submit_story").click(function(event) {
        content = $(".content-editable")

        $("#story_content").val(content.html());


        $("#submit-form-story").click();
    });

    if ($('#edit-story-page')){
      $(".content-editable").data("placeholder", "");;
      setTimeout(function() {
        var storyContent = $('#edit-story-page').data('content');
        $(".content-editable").find("p").replaceWith(storyContent);
      }, 2000);
    }



    function edit_story() {
        content = $(".content-editable");

        title.html($("#story_title").val());
        content.html($("#story_content").val());
    }

    function set_default_editor() {
        var title = $(".title-editable");
        content = $(".content-editable");
        // if (title[0]) {};
    }

    function update_story() {
        var title = $(".title-editable");
        content = $(".content-editable");

        title.html($("#story_title").val());
        content.html($("#story_content").val());

        $("#story_title").val("");
        $("#story_content").val("");
    }

    $(function() {
        $("#form_change_password").submit(function(e) {
            e.preventDefault();
            var data_input = $(this).serialize();

            $.ajax({
                    url: '/update_password_user',
                    type: 'post',
                    dataType: 'json',
                    data: data_input,
                })
                .done(function(data) {
                    if (data.success == true) {
                        success = "<div class='alert alert-success alert-dismissible' role='alert'>" + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>" + "Succesfully changed password" + "</div>";
                        $("#messages-devise").append(success);
                        $("#form_change_password input").val("");
                    } else {
                        error = "<div class='alert alert-warning alert-dismissible' role='alert'>" + "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>" + data.messages + "</div>"
                        $("#messages-devise").append(error);
                        $("#form_change_password input").val("");
                    }


                })
                .fail(function(data) {




                });
        });
    });

    function avatarUpload() {
        $(".img-rounded.edit-profile").mouseover(function() {
            $(".avatar-text").show();
        });
        $(".img-rounded.edit-profile").mouseleave(function() {
            $(".avatar-text").hide();
        });
        $(".img-rounded.edit-profile").click(function(event) {
            $("#user_avatar").click();
        });

        $('#avatar-upload').fileupload({
            add: function(e, data) {
                    $(".avatar-img").hide();
                    $(".avatar-text").text("Click to change your avatar");
                    $("#submit-upload").click(function(event) {
                        data.submit();
                    });
                    if (data.files && data.files[0]) {
                        var reader = new FileReader();
                        reader.onload = function(e) {
                            $('#image-avatar-preview').show().attr('src', e.target.result);
                        }
                        reader.readAsDataURL(data.files[0]);
                    }
                    setAvatarPosition();
                } //add
        });
    }

    avatarUpload();
    setAvatarPosition();

    var searchString = location.search.substring(1);
    if (searchString.substr(0, 5) === "video") {
        videoId = searchString.split('=')[1];

        div = $('*[data-id="' + videoId + '"]');
        video = div.parents().find('video.play-in-modal');
        showAndPlayVideoOnModal($(video));
    }

});

$(window).resize(function() {
    setImagesPosition();
});

$(function() {
    $('[data-toggle="tooltip"]').tooltip()
})


$(document).on('ajax:beforeSend', 'a.single-pagination', function() {
    container = $(this).closest('div.single-pagination-container');
    container.find('div.single-pagination-loader').removeClass('hidden');
    $(this).addClass('hidden');
}).on('ajax:success', 'a.single-pagination', function() {
    container = $(this).closest('div.single-pagination-container');
    container.find('div.single-pagination-loader').addClass('hidden');
    $(this).removeClass('hidden');
}).on('ajax:error', 'a.single-pagination', function() {
    container = $(this).closest('div.single-pagination-container');
    container.find('div.single-pagination-loader').addClass('hidden');
    $(this).removeClass('hidden');
});

$(document).ready(function() {

    $(document).on('click', '.play-in-modal', function(e) {
        showAndPlayVideoOnModal($(this))
    });

    $('div.video-modal').on('hide.bs.modal', function(e) {
        $(this).find('iframe').attr('src', null);
    });

    $('div.modal-video').on('hide.bs.modal', function(e) {
        $(this).find('iframe').attr('src', null);
    });

    $(document).on('click', 'a.play-video', function(e) {
        div = $(this).closest('div');
        video = div.find('.play-in-modal');
        showAndPlayVideoOnModal($(video))
        e.preventDefault();
    })

});

function showAndPlayVideoOnModal(video) {
    modal = video.data('modal');
    vid_src = video.data('video-url');
    $(modal).modal('show');
    $(modal + ' iframe').attr('src', vid_src + '?autoplay=1');
}
