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
        },
        progress: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $('#progress .bar').css('width', progress + '%');
        },
        done: function (e, data) {
            data.context.text('Upload finished.');
            $('#progress .bar').css('width', '0%');
            $('#image-preview').attr('src', "#");
            $('#user-photo-upload-button').html("");
            $('#myModal').modal("hide");
        }
    });

    function readURL(input) {

        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#image-preview').attr('src', e.target.result);
            }

            reader.readAsDataURL(input.files[0]);
        }
    }

    $("#user_photo_path").change(function(){
        readURL(this);
    });

    function storyPhotoRead(input, previewElement) {

        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                previewElement.attr('src', e.target.result);
            }

            reader.readAsDataURL(input.files[0]);
        }
    }

    $("#story_user_photos_attributes_0_path").change(function(){
        if (this.files && this.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#story-hero-preview').css('background', 'url(' + e.target.result + ') no-repeat');
                $('#story-hero-preview').css('background-size', '100% 306px');
                $('#story-upload-glyphicon').hide();
                $('#story-hero-upload-button').html("+ Change feature image");
            }

            reader.readAsDataURL(this.files[0]);
        }
    });
    $("#story_user_photos_attributes_1_path").change(function(){
        storyPhotoRead(this, $('#story-image-preview-2'));
    });
    $("#story_user_photos_attributes_2_path").change(function(){
        storyPhotoRead(this, $('#story-image-preview-3'));
    });
});
