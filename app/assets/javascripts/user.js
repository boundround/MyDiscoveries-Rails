$(document).ready(function() {
  console.log('popover');
  $('#profile-icon').popover();
  $('.user-avatar').on('click', function() {
    $('#user_avatar').click();
  });

  $('.user-avatar').hover(function() {
    $('.click-to-upload').toggle();
  });
});

