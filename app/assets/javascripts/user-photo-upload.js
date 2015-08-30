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
});
