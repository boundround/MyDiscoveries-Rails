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
  });
})()
