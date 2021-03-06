$(function() {
  $('#user-photo-upload').fileupload({
    dataType: 'json',
    add: function(e, data) {
      $("#icon-upload").hide();
      if ($('#user-photo-upload-button').find("button").length < 1) {
        data.context = $('<button class="btn btn-primary"/>').text('Upload')
        .appendTo($('#user-photo-upload-button'))
        .click(function() {
          data.context = $('<p/>').text('Uploading...').replaceAll($(this));
          data.submit();
        });
      };
      $("#upload-title").text("Click image to change");

      if (data.files && data.files[0]) {
        var reader = new FileReader();

        reader.onload = function(e) {
          $('#image-preview').show().attr('src', e.target.result);
        }

        reader.readAsDataURL(data.files[0]);
      }
    },
    send: function() {
      $("#upload-title").text("Click or drag below");
      $("#icon-upload").show();
      $('#userPhotoModal').modal("hide");
      $('#image-preview').attr('src', "#").hide();
      $('#user-photo-upload-button').html("");
      $('#user_photo_caption').val("");
      var message = "Thanks for your photo! We'll let you know when others can see it too.";
      $('.alert-wrapper').html('<div class="alert alert-info fade in"><button class="close" data-dismiss="alert">×</button>' + message + '</div>');
    },
    done: function(e, data) {}
  });

  $('#user-profile-photo-upload').fileupload({
    dataType: 'json',
    add: function(e, data) {
      data.context = $('<button class="btn btn-primary"/>').text('Upload')
        .appendTo($('#user-photo-upload-button'))
        .click(function() {
          data.context = $('<p/>').text('Uploading...').replaceAll($(this));
          data.submit();
        });

      if (data.files && data.files[0]) {
        var reader = new FileReader();

        reader.onload = function(e) {
          $('#image-preview').show().attr('src', e.target.result);
        }

        reader.readAsDataURL(data.files[0]);
      }
    },
    send: function(e, data) {
      var reader = new FileReader();

      reader.onload = function(e) {
        uploadedImage = data.result;
        imageToAdd = '<div class="col-md-3 photo-wrapper"><div class="my-photos"><img class="my-photo" style="max-width:400px" src="' +
          e.target.result +
          '"></div><p style="text-align:center">Refresh the page to delete or edit this photo</p></div><div class="col-md-1"></div>';
        $(imageToAdd).insertBefore($('.photo-wrapper')[0]);

        function fitToDiv(container, element) {
          var conHeight = container.height();
          var imgHeight = element.height();
          var gap = (imgHeight - conHeight) / 2;
          element.css("margin-top", -(gap / 2));
        };

        $.each($('.my-photo'), function(index, item) { fitToDiv($(item).parent(), $(item)) });
      }
      reader.readAsDataURL(data.files[0]);
      $('#userPhotoModal').modal("hide");
      $('#image-preview').attr('src', "#").hide();
      $('#user-photo-upload-button').html("");
      var message = "Thanks for your photo! We'll let you know when others can see it too.";
      $('.alert-wrapper').html('<div class="alert alert-info fade in"><button class="close" data-dismiss="alert">×</button>' + message + '</div>');

    },
    done: function(e, data) {
      data.context.text('Upload finished.');
    }
  });



  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function(e) {
        $('#image-preview').show().attr('src', e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
    }
  }

  function storyReader(input, previewElement, container) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function(e) {
        container.show();
        var image = e.target.result;
        previewElement.attr('src', image);
      }

      reader.readAsDataURL(input.files[0]);
    }
    $(input).parent().hide();
    var conHeight = container.height();
    var imgHeight = previewElement.height();
    var gap = (imgHeight - conHeight) / 2;
    previewElement.css("margin-top", (gap / 2));
  }

  $("#user_photo_path").change(function() {
    readURL(this);
  });

  $("#story_user_photos_attributes_0_path").change(function() {
    storyReader(this, $('#story-image-1'), $('#story-image-1-container'));
  });

  $("#story_user_photos_attributes_1_path").change(function() {
    storyReader(this, $('#story-image-2'), $('#story-image-2-container'));
  });

  $("#story_user_photos_attributes_2_path").change(function() {
    storyReader(this, $('#story-image-3'), $('#story-image-3-container'));
  });

});
