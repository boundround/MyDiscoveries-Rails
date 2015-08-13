$(document).ready(function(){
  console.log("sign_in cookie!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
  if ($.cookie('modal_shown') == null) {
    $.cookie('modal_shown', 'yes', {expires: 1});
    $('#navModal').modal('show');
  } else {
    $('#navModal').modal('hide');
  }
});
