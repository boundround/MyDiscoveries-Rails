$(document).ready(function(){
  if (document.getElementById('place-table')){
    var placeTable = $('#place-table').DataTable({
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

    tableTools = new $.fn.dataTable.TableTools( placeTable, {
        "buttons": [
          "copy",
          "csv",
          "xls",
          "pdf"
        ]
      } );

      $( tableTools.fnContainer() ).insertBefore('table#place-table');
    }

  $('#post-table').DataTable({
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

  $('#parent-table').DataTable({
    // ajax: ...,
    // autoWidth: false,
    // pagingType: 'full_numbers',
    // pageLength: 25
    // processing: true,
    // serverSide: true,
    "bPaginate": false
    // Optional, if you want full pagination controls.
    // Check dataTables documentation to learn more about available options.
    // http://datatables.net/reference/option/pagingType
  });

  $('#subcategory-table').DataTable({
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

  $('#transactions-table').DataTable({
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

  $('#leaderboard-table').DataTable({
    // ajax: ...,
    // autoWidth: false,
    // pagingType: 'full_numbers',
    pageLength: 50,
    order: [[1, "desc"]]
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
