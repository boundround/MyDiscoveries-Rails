(function(){
  $(".user-insta-photo").on("click", function(){
    var img = $(this).data("img");
    var caption = $(this).data("caption");
    var id = $(this).data("id");
    console.log(img);
    console.log(caption);
    console.log(id);
    $('#image-preview').show().attr('src', img);
    $('#insta-caption').val(caption);
    $('#insta-image').val(img);
    $('#insta-id').val(id);
    $(this).hide();
  });

  $("#user-insta-upload-button").on("click", function(){
    $("#myModal").modal("hide");
    var message = "Thanks for your photo! We'll let you know when others can see it too.";
    $('.alert-wrapper').html('<div class="alert alert-info fade in"><button class="close" data-dismiss="alert">×</button>' + message + '</div>');
  });
})()
