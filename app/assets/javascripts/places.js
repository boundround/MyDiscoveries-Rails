// Add to Wishlist
function addToFav(){
$('#place-favorite').on('click', function(e){
  e.preventDefault();
  e.stopPropagation();
  var userId = $(this).data("user-id");
  var placeId = $(this).data("place-id");
  data = {};
  data["places_user"] = { user_id: userId, place_id: placeId };
  if(userId === "no-user"){
    alert("You must be logged in to add to your wishlist!");
  } else if ($(this).data("liked") === false) {
    $.ajax({
      type: "POST",
      url: '/places_users/create',
      data: data,
      success: console.log('LIKE SAVED')
    });
    $(this).text("Remove from wishlist");
    $(this).data("liked", true);
  } else if ($(this).data("liked") === true) {
    $.ajax({
      type: "POST",
      _method: 'delete',
      url: '/places_users/destroy',
      data: data,
      success: console.log('LIKE DELETED')
    });
    $(this).text("Add to wishlist");
    $(this).data("liked", false);
  }
});
}

$(document).ready(function() {
   addToFav(); 
});