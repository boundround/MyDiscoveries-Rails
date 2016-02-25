$(document).ready(function() {
  console.log('popover');
  $('#profile-icon').popover();
  $('.user-avatar').on('click', function() {
    $('#user_avatar').click();
  });

  $('.user-avatar').hover(function() {
    $('.click-to-upload').toggle();
  });

  $('#change-photo').on('click', function(){
    $('#user_avatar').trigger('click');
  });
});

$(document).ready(function(){

  $('.day').datepicker({
      format: "dd",
      viewMode: "day",
      minViewMode: "day",
      autoclose: true
  });
  $('.month').datepicker({
      format: "mm",
      viewMode: "months",
      minViewMode: "months",
      autoclose: true
  });
  $('.year').datepicker({
      format: "yyyy",
      viewMode: "years",
      minViewMode: "years",
      autoclose: true
  });
  $('.br_profile_modal select').selectpicker();

  $('[data-toggle="offcanvas"]').click(function () {
      $('header').toggleClass('active')
  });
  $("#owl-example").owlCarousel({
      itemsTablet:[767,2],
      itemsMobile:[500,1],
      autoPlay:true,
      navigation:true,
      navigationText: [
          "<i class='glyphicon glyphicon-menu-left'><</i>",
          "<i class='glyphicon glyphicon-menu-right'>></i>"
      ],
      afterInit: function(){
          $( "#owl-example .glyphicon-menu-left,#owl-example .glyphicon-menu-right" ).empty();
      }
  });

});


