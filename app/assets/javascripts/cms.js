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

      $('#place-table thead th').each( function () {
          var title = $(this).text();
          $(this).html( '<input type="text" placeholder="Search '+title+'" />' );
      } );

      // Apply the search
      placeTable.columns().every( function () {
          var that = this;

          $( 'input', this.header() ).on( 'keyup change', function () {
              if ( that.search() !== this.value ) {
                  that
                      .search( this.value )
                      .draw();
              }
          } );
      } );
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

  if (document.querySelector('.form_datetime')){
    $('.form_datetime').datepicker({
      autoclose: true,
      todayBtn: true,
      pickerPosition: "bottom-left",
      format: 'dd-mm-yyyy'
    });
  }

  if (document.querySelector('#place_meta_description')){
    countChars('#place_meta_description', '#shortDescriptionCharCount');
    countChars('#place_description', '#descriptionCharCount');

    $('#place_meta_description').on('keyup', function(){
      countChars('#place_meta_description', '#shortDescriptionCharCount');
    });

    setTimeout(function(){
      var wysiEditor = $('.wysihtml5-sandbox').contents().find('body')[0];
      $(wysiEditor).on("keyup",function() {
          var len = wysiEditor.innerHTML.length;
          document.querySelector('#descriptionCharCount').innerHTML = len;
      });
    }, 1000);
  }

  if (document.querySelector('#attraction_meta_description')){
    countChars('#attraction_meta_description', '#shortDescriptionCharCount');
    countChars('#attraction_description', '#descriptionCharCount');

    $('#attraction_meta_description').on('keyup', function(){
      countChars('#attraction_meta_description', '#shortDescriptionCharCount');
    });

    setTimeout(function(){
      var wysiEditor = $('.wysihtml5-sandbox').contents().find('body')[0];
      $(wysiEditor).on("keyup",function() {
          var len = wysiEditor.innerHTML.length;
          document.querySelector('#descriptionCharCount').innerHTML = len;
      });
    }, 1000);
  }
  function countChars(countfrom,displayto) {
    var len = document.getElementById(countfrom).value.length;
    document.getElementById(displayto).innerHTML = len;
  }

  if (document.querySelector('#seo-title')){
    countChars("seo-title", "seo-title-count");
    countChars("meta-description", "meta-description-count");
    $("#seo-title").on("keyup", function(){
      countChars("seo-title", "seo-title-count");
    });

    $("#meta-description").on("keyup", function(){
      countChars("meta-description", "meta-description-count");
    });
  }
});
