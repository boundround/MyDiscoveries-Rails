$(document).ready(function(){
  $('.entire-review').on("click", function(e){
    console.log("clicked");
    var contentContainer = $(this).parent().siblings().parent().find('.review-content');
    var review = $(this).data("entire-review");
    if ($(this).data("size") == "contracted"){
      $(contentContainer).html(review);
      $(this).html("See less");
      $(this).data("size", "expanded");
    } else if ($(this).data("size") == "expanded"){
      $(contentContainer).html(review.substr(0, 281) + "...");
      $(this).html("See entire review");
      $(this).data("size", "contracted");
    }
  });

  $('#publish-review-button').on('click', function(){
    $('#myModal3').modal("hide");
  })
});
