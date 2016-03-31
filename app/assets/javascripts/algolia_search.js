$(document).ready(function(){
  // removeResultDesktop();

  var APPLICATION_ID = 'KXOYK344AM';
  var SEARCH_ONLY_API_KEY = 'fce29aca7a9b823b9cacdbc1faa225e2';
  // var INDEX_NAME = 'place';
  // index
  // country_#{Rails.env}
  // primary_category_#{Rails.env}
  // place_#{Rails.env}
  // subcategory_#{Rails.env}

  // var INDEX_NAME = "place_development","primary_category_development","country_development","subcategory_development";
  var INDEX_NAME = 'place_production';
  var PARAMS = {
    hitsPerPage: 6,
    maxValuesPerFacet: 8,
  };

  // var br_place_markerCluster = null;

  var algolia = algoliasearch(APPLICATION_ID, SEARCH_ONLY_API_KEY);
  var algoliaHelper = algoliasearchHelper(algolia, INDEX_NAME, PARAMS);
  var algoliaHelperBottom = algoliasearchHelper(algolia, INDEX_NAME, PARAMS);
  var algoliaHelperInstantSearch= algoliasearchHelper(algolia, INDEX_NAME, PARAMS);

  var hideSearchResults = function(){
    $('.br15_search_result').show();
      $('.search-results-container').show();
      $('.search-results').show();
      $('.google-results-container').show();
      $('.google-results-container').append($('.pac-container'));
      // renderNoResults(content);
      $('.br15_header').slideDown(400,function(){google.maps.event.trigger(br_map, "resize");});
      $('#br15_map').removeClass('br15_min_h_530');
      $('.br15_map').addClass('br15_collapse');
  };

  // $searchInput = $('#search-box');
  $searchInput = $('.search-box');
  $searchInputBottom = $('.search-box-bottom');
  $searchInputIcon = $('#search-button');
  $main = $('main');
  $sortBySelect = $('#sort-by-select');
  $hits = $('.hits');
  $stats = $('#stats');
  $facets = $('#facets');
  // $pagination = $('#pagination');
  // $noResult = $('#no-result');
  $moreResult = $('.more-result-id');

  var hitTemplate = Hogan.compile($('#hit-template').text());
  // var statsTemplate = Hogan.compile($('#stats-template').text());
  var facetTemplate = Hogan.compile($('#facet-template').text());
  // var sliderTemplate = Hogan.compile($('#slider-template').text());
  // var paginationTemplate = Hogan.compile($('#pagination-template').text());
  // var noResultsTemplate = Hogan.compile($('#no-results-template').text());
  var moreResultsTemplate = Hogan.compile($('#more-results-template').text());

  //instant search
  $instantSearchInput= $("input.instant-search");
  $instantSearchHits= $instantSearchInput.closest('div#instant-search-container').find('div#instant-search-results div.hits');
  $instantSearchHits= $instantSearchInput.closest('div#instant-search-container').find('div#instant-search-results div.pagination');
  var instanthitTemplate = Hogan.compile($('#instant-hit-template').text());


  function searchCondition(query){
    if (query.length > 0){
      algoliaHelper.setQuery(query);
      algoliaHelper.search();
    } else {
      $('.search-results-container').hide();
    }
  }
  function searchConditionBottom(query){
    if (query.length > 0){
      algoliaHelperBottom.setQuery(query);
      algoliaHelperBottom.search();
    } else {
      $('.search-results-container').hide();
    }
  }

  function searchInstant(input)
  {
    query= input.val();
    if (query.length > 0)
    {
      algoliaHelperInstantSearch.setQuery(query);
      algoliaHelperInstantSearch.search();
    }
  }

  $searchInput
  .on('keyup', function() {
      var query = $(this).val();
      searchCondition(query);
  })
  .bind("paste", function(){
      var elem = $(this);
      setTimeout(function() {
        query = elem.val();
        searchCondition(query);
      }, 100);
  })
  .focus();



  $searchInputBottom
  .on('keyup', function() {
      var query = $(this).val();
      searchConditionBottom(query);
  })
  .bind("paste", function(){
      var elem = $(this);
      setTimeout(function() {
        query = elem.val();
        searchConditionBottom(query);
      }, 100);
  })
  .focus();

  $instantSearchInput
  .on('keyup', function() {
    searchInstant($(this))
  })
  .bind("paste", function(){
      var elem = $(this);
      setTimeout(function() {
        searchInstant($(this));
      }, 100);
  })
  .focus();


  // $searchInputBottom
  // .on('keyup', function() {
  //     var query = $(this).val();
  //     searchCondition(query);
  // })
  // .bind("paste", function(){
  //     var elem = $(this);
  //     setTimeout(function() {
  //       query = elem.val();
  //       searchCondition(query)
  //     }, 100);
  // })
  // .focus();

  // Search results
  algoliaHelper.on('result', function(content, state) {
    if (content.hits.length > 0){
      // $noResult.hide();
      $('.search-results-container').show();
      $('.search-results-bottom-container').hide();
      // $('.search-results').show();
      renderHits(content);
      renderMoreResults(content);
      rescueImage();
      console.log(content.query);
      console.log(state);
      // renderStats(content);
      // renderPagination(content);
    } else {
      // renderNoResults(content);
    }
  });
  algoliaHelperBottom.on('result', function(content, state){
    if (content.hits.length > 0){
          // $noResult.hide();
          $('.search-results-bottom-container').show();
          $('.search-results-container').hide();
          // $('.search-results').show();
          renderHits(content);
          renderMoreResults(content);
          rescueImage();
          console.log(content.query);
          console.log(state);
          // renderStats(content);
          // renderPagination(content);
        } else {
          // renderNoResults(content);
        }
  })

  algoliaHelperInstantSearch.on('result', function(content, state){
    renderInstantHits(content);
    console.log(content)
  })


  function renderInstantHits(content)
  {
    if (content.hits.length > 0)
    {
      console.log()
      $instantSearchHits.html(instanthitTemplate.render(content));
    }else
    {
      $instantSearchHits.html('No result for '+ content.query);
    }
  }


  function renderMoreResults(content){
    // alert("more result");
    // console.log(content.query);
    $moreResult.html(moreResultsTemplate.render(content));
  }

  // function renderNoResults(content){
  //   $noResult.html(noResultsTemplate.render(content));
  // }

  function renderHits(content) {
    $hits.html(hitTemplate.render(content));
  }

  function renderStats(content) {
    var stats = {
      nbHits: content.nbHits,
      nbHits_plural: content.nbHits !== 1,
      processingTimeMS: content.processingTimeMS
    };
    $stats.html(statsTemplate.render(stats));
  }
function rescueImage(){
      // $($(".hit-icon img")[0]).attr("src") == ""
    var img = $(".hit-icon img");
    $.each(img, function(index, val) {
       if ($(val).attr("src") == ""){
        // console.log($(val).attr("src") == "");
            $(val).attr('src', "https://d1w99recw67lvf.cloudfront.net/images/generic-hero-small.jpg");
            // console.log($(val).html());
       }
    });
}

  // function renderPagination(content) {
  //   var pages = [];
  //   if (content.page > 3) {
  //     pages.push({current: false, number: 1});
  //     pages.push({current: false, number: '...', disabled: true});
  //   }
  //   for (var p = content.page - 3; p < content.page + 3; ++p) {
  //     if (p < 0 || p >= content.nbPages) continue;
  //     pages.push({current: content.page === p, number: p + 1});
  //   }
  //   if (content.page + 3 < content.nbPages) {
  //     pages.push({current: false, number: '...', disabled: true});
  //     pages.push({current: false, number: content.nbPages});
  //   }
  //   var pagination = {
  //     pages: pages,
  //     prev_page: content.page > 0 ? content.page : false,
  //     next_page: content.page + 1 < content.nbPages ? content.page + 2 : false
  //   };
  //   $pagination.html(paginationTemplate.render(pagination));
  // }

  // NO RESULTS
  // ==========

  // function handleNoResults(content) {
  //   if (content.nbHits > 0) {
  //     $main.removeClass('no-results');
  //     return;
  //   }
  //   $main.addClass('no-results');

  //   var filters = [];
  //   var i;
  //   var j;
  //   for (i in algoliaHelper.state.facetsRefinements) {
  //     filters.push({
  //       class: 'toggle-refine',
  //       facet: i, facet_value: algoliaHelper.state.facetsRefinements[i],
  //       label: FACETS_LABELS[i] + ': ',
  //       label_value: algoliaHelper.state.facetsRefinements[i]
  //     });
  //   }
  //   for (i in algoliaHelper.state.disjunctiveFacetsRefinements) {
  //     for (j in algoliaHelper.state.disjunctiveFacetsRefinements[i]) {
  //       filters.push({
  //         class: 'toggle-refine',
  //         facet: i,
  //         facet_value: algoliaHelper.state.disjunctiveFacetsRefinements[i][j],
  //         label: FACETS_LABELS[i] + ': ',
  //         label_value: algoliaHelper.state.disjunctiveFacetsRefinements[i][j]
  //       });
  //     }
  //   }
  //   for (i in algoliaHelper.state.numericRefinements) {
  //     for (j in algoliaHelper.state.numericRefinements[i]) {
  //       filters.push({
  //         class: 'remove-numeric-refine',
  //         facet: i,
  //         facet_value: j,
  //         label: FACETS_LABELS[i] + ' ',
  //         label_value: j + ' ' + algoliaHelper.state.numericRefinements[i][j]
  //       });
  //     }
  //   }
  //   $hits.html(noResultsTemplate.render({query: content.query, filters: filters}));
  // }

  // $(document).on('click', '.go-to-page', function(e) {
  //   e.preventDefault();
  //   // $('html, body').animate({scrollTop: 0}, '500', 'swing');
  //   algoliaHelper.setCurrentPage(+$(this).data('page') - 1).search();
  // });

//#NewCode
// function searchRequest(){

//     $('#form-search').submit(function(event) {
//       event.preventDefault();
//       // alert("klik");
//       var query = $(this).find('input[name=query-top]').val();
//       // searchCondition(query);
//       algoliaHelper.setQuery(query);
//       algoliaHelper.search();
//     });
//       // Search results
//       algoliaHelper.on('result', function(content, state) {
//         if (content.hits.length > 0){
//           // alert("content > 0")
//           // window.location = "/results"

//           console.log(content);
//           console.log(content.index);
//           console.log(state);

//           var place_card = "<div class='col-xs-12 col-md-6'>"+
//                             "<div class='thumbnail'>"+
//                               "<div class='image-cat image-cat-left'>"+
//                                 "<img src='./img/images.jpg' alt=' class='img-responsive img-full-div'>"+
//                               "</div>"+
//                               "<div class='caption caption-right'>"+
//                                 "<h4 class='gray-font'>Sydney</h4>"+
//                                 "<h2>The Powerhouse Museum</h2>"+
//                               "</div>"+
//                               "<div class='details-dest'>"+
//                                 "<div class='left'>"+
//                                   "<a href='#'><i class='fa fa-male'></i> Do</a>"+
//                                   "<a href='#'>Museum</a>"+
//                                 "</div>"+
//                                 "<div class='right'>"+
//                                   "$$"+
//                                 "</div>"+
//                                 "</div>"+
//                               "</div>"+
//                             "</div>";
//       $("#area-card").append(place_card);
//       // console.log(place_card);

//         } else {
//           // alert("content < 0")

//         }
//       });
//     }
// searchRequest();

});

function removeResultDesktop(){
  // if ($(window).width() < 767) {
  //   var desktop_result = $("#desktop-result");
  //       html_desktop_result = $("#desktop-result").html();
  //       desktop_result.children().remove();
  //   }else{
  //     desktop_result.html(html_desktop_result);
  //   }

}

$(window).resize(function(event) {
  removeResultDesktop();
});
