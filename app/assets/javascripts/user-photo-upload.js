$(function () {
    $('#user-photo-upload').fileupload({
        dataType: 'json',
        add: function (e, data) {
            data.context = $('<button class="btn btn-primary"/>').text('Upload')
                .appendTo($('#user-photo-upload-button'))
                .click(function () {
                    data.context = $('<p/>').text('Uploading...').replaceAll($(this));
                    data.submit();
                });

            if (data.files && data.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#image-preview').show().attr('src', e.target.result);
            }

            reader.readAsDataURL(data.files[0]);
            }
        },
        send: function(){
            $('#myModal').modal("hide");
            $('.loader-bound-round').show();
            // $('#image-preview').attr('src', "#").hide();
            // $('#user-photo-upload-button').html("");
            // var message = "Thanks for your photo! We'll let you know when others can see it too.";
            // $('.alert-wrapper').html('<div class="alert alert-info fade in"><button class="close" data-dismiss="alert">×</button>' + message + '</div>');
            // var newImage = '<div class="carousel-item br_16"><img src="' + imageData +
            //     '" class="img-resposive carousel-country-photo" data-slide-number="' + $('.carousel-item').length +
            //     '"></div>';
            // $('.owl-carousel').append(newImage);
        },
        done: function (e, data) {
            // data.context.text('Upload finished.');
            // $('#progress .bar').css('width', '0%');
            // $('#image-preview').attr('src', "#");
            // $('#user-photo-upload-button').html("");
            // $('#myModal').modal("hide");
            location.reload();
        }
    });

    function readURL(input) {

        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#image-preview').show().attr('src', e.target.result);
            }

            reader.readAsDataURL(input.files[0]);
        }
    }

    $("#user_photo_path").change(function(){
        readURL(this);
    });

    $("#story_user_photos_attributes_0_path").change(function(){
        if (this.files && this.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                console.log("ADDING FIRST PHOTO");
                $('#story-image-preview').css('background', 'url(' + e.target.result + ') no-repeat');
                $('#story-image-preview').css('background-size', '100% 500px');
                $('#story-upload-glyphicon').hide();
                $('#story-hero-upload-button').html("+ Change feature image");
                //$('#story-hero-preview').css('background', 'url(https://d1w99recw67lvf.cloudfront.net/user_avatars/15/mod-target.jpg) no-repeat');
            }

            reader.readAsDataURL(this.files[0]);
        }
    });

    // $('#story-form').fileupload({
    //     dataType: 'json',
    //     add: function (e, data) {
    //         if (data.files && data.files[0]) {
    //         var reader = new FileReader();

    //         reader.onload = function (e) {
    //             console.log("ADDING FIRST PHOTO");
    //             $('#story-image-preview').css('background', 'url(' + e.target.result + ') no-repeat');
    //             $('#story-image-preview').css('background-size', '100% 500px');
    //             $('#story-upload-glyphicon').hide();
    //             $('#story-hero-upload-button').html("+ Change feature image");
    //         }

    //         reader.readAsDataURL(data.files[0]);
    //         }
    //     },
    //     send: function(){
    //         $('#story').modal("hide");
    //         $('.loader-bound-round').show();
    //     },
    //     done: function (e, data) {
    //         location.reload();
    //     }
    // });

});
