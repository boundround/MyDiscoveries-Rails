var LIKE = {
  like: function(){
  console.log('like.js');
  $('.like-icon').on('click', function(e){
    e.preventDefault();
    var oldImage = $(this).attr('src');
    var switchImage = $(this).data('switchImage');
    var postPath = $(this).data('postPath');
    var postType = $(this).data('postType');
    var data = {};
    switch(postType){
      case "photos_user":
        data[postType] = {user_id: $(this).data("user"), photo_id: $(this).data("contentId")};
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
    console.log($(this).data('liked'));
    if ($(this)[0].dataset.liked === 'false'){
      $(this).attr('src', switchImage);
      $(this).data('switchImage', oldImage);
      $(this)[0].dataset.liked = 'true';
      $.ajax({
        type: "POST",
        url: '/' + postPath + '/create',
        data: data,
        success: console.log('LIKE SAVED')
      });
    } else if ($(this)[0].dataset.liked === 'true') {
        $(this).attr('src', switchImage);
        $(this).data('switchImage', oldImage);
        $(this)[0].dataset.liked = 'false';
        $.ajax({
          type: "POST",
          _method: 'delete',
          url: '/' + postPath + '/destroy',
          data: data,
          success: console.log('LIKE DELETED')
        });
    } else {
      alert("You must be logged in to save favorites!");
    }
  });
};
