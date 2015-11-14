$(document).ready(function(){
  if ($.cookie('modal_shown') == null) {
    var date = new Date();
    var minutes = 720;
    date.setTime(date.getTime() + (minutes * 60 * 1000));
    $.cookie('modal_shown', 'yes', {expires: date});
    //$('#navModal').modal('show');
    $('#signInModal').modal('show');
  } else {
    //$('#navModal').modal('hide');
    $('#signInModal').modal('hide');
  }
});
