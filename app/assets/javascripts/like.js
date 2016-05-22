// console.log('like.js');
$(document).ready(function() {
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
    if ($(this)[0].dataset.liked === 'false'){
      $(this).find('.like-heart').removeClass('fa-heart-o').removeClass("like-heart").addClass('fa-heart').addClass('liked-heart');
      $(this)[0].dataset.liked = 'true';
      $.ajax({
        type: "POST",
        url: '/' + postPath + '/create',
        data: data
      });
    } else if ($(this)[0].dataset.liked === 'true') {
        $(this).find('.liked-heart').removeClass('fa-heart').removeClass('liked-heart').addClass('fa-heart-o').addClass('like-heart');
        $(this)[0].dataset.liked = 'false';
        $.ajax({
          type: "POST",
          _method: 'delete',
          url: '/' + postPath + '/destroy',
          data: data
        });
    } else {
      alert("You must be logged in to save favourites!");
    }
  });
});
