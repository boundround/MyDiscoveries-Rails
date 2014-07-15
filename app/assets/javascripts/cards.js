$('#areaModal').on('shown.bs.modal', function (e) {
  var $container = $('#photos-masonry').imagesLoaded( function() {
    $container.isotope({
      layoutMode: 'masonry',
      itemSelector: '.item ',
      masonry: {
        columnWidth: $('#photos-masonry').find('.grid-sizer')[0]
      },
      getSortData: {
        priority: '.priority'
      },
      sortBy: ['priority', 'original-order']
    });

    $container.imagesLoaded(function () {
      $container.isotope({ layoutMode : 'masonry' });
    });

    $('.photo-card').on( 'click', function() {
      //close other expanded cards
      $(this).siblings('.game-card').find('.game-divider').empty();
      $(this).siblings('.video-card').find('.game-divider').empty();
      $(this).siblings('.photo-card').find('.game-divider').empty();
      $(this).siblings('.photo-card-expanded').removeClass('photo-card-expanded')
        .find('.fun-fact').hide().end().find('.game-thumbnail').show();
      $(this).siblings('.game-card-expanded').removeClass('game-card-expanded')
        .find('.game-thumbnail').show();


      //expand clicked photo card
      $(this).find('.fun-fact').show();
      $(this).addClass('photo-card-expanded');
      $container.isotope({ layoutMode : 'masonry' });
    });

    $('.game-card').on( 'click', function() {

      var gameURL = $(this).find('.game-data').data('url');
      var content = '<iframe class="game-frame" src="' + gameURL + '" ></iframe>'
      var divider = $(this).find('.game-divider');
      //expand clicked game card
      $(this).find('.game-thumbnail').hide();
      $(divider).empty();
      $(divider).append(content);
      $(this).addClass('game-card-expanded');
      $container.isotope({ layoutMode : 'masonry' });
    });

    $('.video-card').on( 'click', function() {

      var vimeoId = $(this).find('.video-data').data('video-id');
      var content = '<iframe class="vimeo-frame" src=\"//player.vimeo.com/video/' + vimeoId + '\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>'
      var divider = $(this).find('.game-divider');
      //expand clicked game card
      $(this).find('.game-thumbnail').hide();
      $(this).addClass('game-card-expanded');
      $(divider).empty();
      $(this).find('.game-divider').append(content);
      $container.isotope({ layoutMode : 'masonry' });
    });

    $('.photo-thumb').on('click', function() {
      var photoUrl = $(this).find('.photo-data').data('photo-url');
      var content = '<img src=' + photoUrl + ' class="photo-frame">';
      var divider = $(this).find('.game-divider');
      // remove photo thumbnail and populate expanded divider with large image
      $(this).find('.game-thumbnail').hide();
      $(this).addClass('photo-card-expanded');
      $(divider).empty();
      $(this).find('.game-divider').append(content);
      $container.isotope({ layoutMode : 'masonry' });
    });

  });

  $('#menu').on( 'click', 'a', function() {
    var filterValue = $(this).attr('data-filter');
    $container.isotope({ filter: filterValue });
  });

  var hash = $('.title').text();
  window.location.hash = hash;
  // window.onhashchange = function() {
  //   if (!location.hash){
  //     $(modal).modal('hide');
  //   }
  // }

  $('#areaModal').on('hide.bs.modal', function (e) {
    $container.isotope({ filter: '' });
    var hash = this.id;
    history.pushState('', document.title, window.location.pathname);
  });
})
// $('#showAreaModal').modal('show');
//
// $('#showAreaModal').on('shown.bs.modal', function (e) {
//   var $container = $('#photos-masonry');
//   // init
//   $container.imagesLoaded( function() {
//     $container.isotope({
//       layoutMode: 'masonry',
//       itemSelector: '.item ',
//       masonry: {
//         columnWidth: $container.find('.grid-sizer')[0]
//       }
//     });
//     $container.on( 'click', '.photo-card', function() {
//
//       $(this).find('.fun-fact').toggle();
//       $( this ).toggleClass('photo-card-expanded');
//       $container.isotope({ layoutMode : 'masonry' });
//     });
//
//     $container.on( 'click', '.game-card', function() {
//       //close expanded game card
//       $( this ).siblings('.game-card-expanded').toggleClass('game-card-expanded')
//       .find('.game-thumbnail').toggle();
//
//       $( this ).siblings('.game-card').find('.game-divider').empty();
//
//       //expand clicked game card
//       $(this).find('.game-thumbnail').toggle();
//       $( this ).toggleClass('game-card-expanded');
//       $(this).find('.game-divider').append('<iframe class="game-frame" src="http://09f1be2b4e79305414d1-e02ea5f9f7cbf68a786b2624900f7447.r95.cf4.rackcdn.com/games/Jigsaw/fiji.html"></iframe>');
//       $container.isotope({ layoutMode : 'masonry' });
//     });
//
//   });
//
//   $('#menu').on( 'click', 'a', function() {
//     var filterValue = $(this).attr('data-filter');
//     $container.isotope({ filter: filterValue });
//   });
// });
