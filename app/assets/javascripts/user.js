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

$(document).ready(function(){
    // var circle = new ProgressBar.Circle('#circle', {
    //     color: '#fff',
    //     strokeWidth: 10,
    //     fill: '#a459a0'
    // });
    // circle.animate(1);

    // var circle2 = new ProgressBar.Circle('#circle2', {
    //     color: '#fff',
    //     strokeWidth:10,
    //     fill: '#a459a0'
    // });
    // circle2.animate(1);

    // var circle3 = new ProgressBar.Circle('#circle3', {
    //     color: '#fff',
    //     strokeWidth: 6,
    //     fill: '#f07656',
    //     trailWidth: 6,
    //     trailColor: '#a459a0',
    //     duration: 1500,
    //     text: {
    //         value: ''
    //     }
    // });

    // var circle_m = new ProgressBar.Circle('#circle_m', {
    //     color: '#ebebeb',
    //     strokeWidth: 10,
    //     fill: '#a459a0'
    // });
    // circle_m.animate(1);

    // var circle2_m = new ProgressBar.Circle('#circle2_m', {
    //     color: '#ebebeb',
    //     strokeWidth:10,
    //     fill: '#a459a0'
    // });
    // circle2_m.animate(1);

    // circle3.animate(0.75);

    // var circle3_m = new ProgressBar.Circle('#circle3_m', {
    //     color: '#ebebeb',
    //     strokeWidth: 6,
    //     fill: '#f07656',
    //     trailWidth: 6,
    //     trailColor: '#a459a0',
    //     duration: 1500,
    //     text: {
    //         value: ''
    //     }
    // });
    // circle3_m.animate(0.75);

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


