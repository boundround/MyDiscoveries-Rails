$(document).ready(function(){
  var highlightMobileMenu = function() {
    if ($('body').find('.map-only-page').length > 0) {
      $('.home-item').parent().css("background-color","lightblue");
    } else if ($('body').find('.all-videos').length > 0) {
      $('.videos-item').parent().css("background-color","lightblue");
    } else if ($('body').find('.all-games').length > 0) {
      $('.games-item').parent().css("background-color","lightblue");
    } else if ($('body').find('.area-content').length > 0) {
      $('.about-item').parent().css("background-color","lightblue");
    } else if ($('body').find('.map-page').length > 0) {
      $('.cards-item').parent().css("background-color","lightblue");
    }
  }

  highlightMobileMenu();

  $('.inline-list').on('click', 'li', function(){
    $('.inline-list').find('a').css("background-color", "#f8f8f8");
    $(this).find('a').css("background-color", "lightblue");
  });

  $('#place-table').DataTable({
    // ajax: ...,
    // autoWidth: false,
    // pagingType: 'full_numbers',
    pageLength: 25
    // processing: true,
    // serverSide: true,

    // Optional, if you want full pagination controls.
    // Check dataTables documentation to learn more about available options.
    // http://datatables.net/reference/option/pagingType
  });

  $('#user-table').DataTable({
    // ajax: ...,
    // autoWidth: false,
    // pagingType: 'full_numbers',
    pageLength: 50
    // processing: true,
    // serverSide: true,

    // Optional, if you want full pagination controls.
    // Check dataTables documentation to learn more about available options.
    // http://datatables.net/reference/option/pagingType
  });

  $('#user-place-table').DataTable({
    // ajax: ...,
    // autoWidth: false,
    // pagingType: 'full_numbers',
    pageLength: 25,
    order: [[4, "desc"]]
    // processing: true,
    // serverSide: true,

    // Optional, if you want full pagination controls.
    // Check dataTables documentation to learn more about available options.
    // http://datatables.net/reference/option/pagingType
  });

  $('#photo-table').DataTable({
    "paging": false
  });
  $('#video-table').DataTable({
    "paging": false
  });
  $('#game-table').DataTable({
    "paging": false
  });
  $('#fun-fact-table').DataTable({
    "paging": false
  });
  $('#discount-table').DataTable({
    "paging": false,
    "ordering": false
  });

});

$(document).ready(function(){
  $('.form_datetime').datepicker({
    autoclose: true,
    todayBtn: true,
    pickerPosition: "bottom-left",
    format: 'dd-mm-yyyy'
  });
});
