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
    hitsPerPage: 1,
    maxValuesPerFacet: 8,
  };

  // var br_place_markerCluster = null;

  var algolia = algoliasearch(APPLICATION_ID, SEARCH_ONLY_API_KEY);
  var algoliaHelper = algoliasearchHelper(algolia, INDEX_NAME, PARAMS);
  var algoliaHelperBottom = algoliasearchHelper(algolia, INDEX_NAME, PARAMS);

  var FACETS_ORDER_OF_DISPLAY = ['age_range', 'main_category', 'subcategory', 'weather', 'price', 'best_time_to_visit', 'accessibility'];
  var FACETS_LABELS = {main_category: 'Category', age_range: 'Age', subcategory:'Subcategory', weather: 'Weather', price: 'Price', best_time_to_visit: 'Best Time To Visit', accessibility: 'Accessibility'};

  var INSTANT_SEARCH_PARAMS = {
    hitsPerPage: 6,
    maxValuesPerFacet: 8,
    facets: ['area'],
    disjunctiveFacets: FACETS_ORDER_OF_DISPLAY
  };

  var algoliaHelperInstantSearch= algoliasearchHelper(algolia, INDEX_NAME, INSTANT_SEARCH_PARAMS);

  // var hideSearchResults = function(){
  //   $('.br15_search_result').show();
  //     $('.search-results-container').show();
  //     $('.search-results').show();
  //     $('.google-results-container').show();
  //     $('.google-results-container').append($('.pac-container'));
  //     // renderNoResults(content);
  //     $('.br15_header').slideDown(400,function(){google.maps.event.trigger(br_map, "resize");});
  //     $('#br15_map').removeClass('br15_min_h_530');
  //     $('.br15_map').addClass('br15_collapse');
  // };

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
  var hitTemplateHome = Hogan.compile($('#hit-template-home').text());
  // var statsTemplate = Hogan.compile($('#stats-template').text());
  var facetTemplate = Hogan.compile($('#facet-template').text());
  // var sliderTemplate = Hogan.compile($('#slider-template').text());
  // var paginationTemplate = Hogan.compile($('#pagination-template').text());
  // var noResultsTemplate = Hogan.compile($('#no-results-template').text());
  var moreResultsTemplate = Hogan.compile($('#more-results-template').text());

  //instant search
  $instantSearchInput= $("input.instant-search");
  if ($instantSearchInput.length)
  {
    searchInstant($instantSearchInput)

    $instantSearchFacet= $('#facets-instant-search')
    $instantSearchHits= $instantSearchInput.closest('div#instant-search-container').find('div#instant-search-results div.instant-hits-result');
    $instantSearchPagination= $instantSearchInput.closest('div#instant-search-container').find('div#instant-search-results div.pagination');

    var instanthitTemplate = Hogan.compile($('#instant-hit-template').text());
    var instantPaginationTemplate= Hogan.compile($('#instant-pagination-template').text());
    var instantfacetTemplate = Hogan.compile($('#instant-facet-template').text());
    var instantNoResultTemplate = Hogan.compile($('#instant-no-result-template').text());
  }
  function searchCondition(query){
    if (query.length > 0){
      algoliaHelper.setQuery(query);
      algoliaHelper.search();
    } else {
      // $('.search-results-container').hide();
    }
  }
  function searchConditionBottom(query){
    if (query.length > 0){
      algoliaHelperBottom.setQuery(query);
      algoliaHelperBottom.search();
      // console.log(query);
  
      // $('.search-bottom').show();
    } else {
      // $('.search-bottom').hide();
    }
  }

  function searchInstant(input)
  {
    query= input.val();
    algoliaHelperInstantSearch.setQuery(query);
    algoliaHelperInstantSearch.search();

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
      // console.log(query);
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

  // Search results
  algoliaHelper.on('result', function(content, state) {
    if (content.hits.length > 0){
      // $noResult.hide();
      $('#search-results-container').show();
      $('#search-results-bottom-container').hide();
      // $('.search-results').show();
      // renderHits(content);
      renderHitsHome(content);
      renderMoreResults(content);
      rescueImage();
      console.log(content.hits);
    } else {
      // renderNoResults(content);
    }
  });
  algoliaHelperBottom.on('result', function(content, state){
    if (content.hits.length > 0){
          // $noResult.hide();
          $('#search-results-bottom-container').show();
          $('#search-results-container').hide();
          renderHitsHome(content);
          renderMoreResults(content);
          rescueImage();
          console.log(content.hits);
        } else {
          // renderNoResults(content);
        }
  })

  algoliaHelperInstantSearch.on('result', function(content, state){
    viatorLink(content.hits);
    renderInstantHits(content);
    renderFacets(content, state);
    renderPagination(content, $instantSearchPagination ,instantPaginationTemplate);
    setImagesPosition();
  
  })


  function viatorLink(hits){
    $.each(hits, function(index, val) {
       if (val.viator_link == ""){
          val.viator_link = {
            klass: "hide"
          }
       }
    });
  }

  $(document).on('click', '.go-to-page-instant-search', function(e) {
    e.preventDefault();
    $('html, body').animate({scrollTop: 0}, '500', 'swing');
    algoliaHelperInstantSearch.setCurrentPage(+$(this).data('page') - 1).search();
  });

  $(document).on('click', '.instant-search-toggle-refine', function(e) {
    algoliaHelperInstantSearch.toggleRefine($(this).data('facet'), $(this).data('value')).search();
  });

  function renderInstantHits(content)
    {
      if (content.hits.length > 0)
      {
        $instantSearchHits.html(instanthitTemplate.render(content)); 
        $(".instant-hits-result-pagination").show();
      }else {       
        
        $instantSearchHits.html(instantNoResultTemplate.render(content));

        $(".show_form_request").click( function(){
          $("#search_request").show();
        });


          $("form#search_request").submit(function(event) {
              event.preventDefault();
              var form_value = ( $(this).serialize() );
              
                $(this).find("button").addClass('sending');
                $.ajax({
                  url: '/search_requests/create',
                  type: 'post',
                  dataType: 'json',
                  data: form_value,
                })
                .done(function(data) {
                  // console.log(data);
                  // console.log("done");
                  if (data.success == true) {
                      success = "<div class='alert alert-success alert-dismissible' role='alert'>"
                                  +"<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>"
                                  +"Thank you, Your request has been sent to <strong>info@boundround.com.</strong> &nbsp;&nbsp; <a href='/' style='color: #3c763d;'>Back to home</a>"
                                +"</div>" 
                      setTimeout(function(){
                        $("#search_request").find("button").removeClass('sending');
                      }, 1000);
                      setTimeout(function(){
                        $("#search_request").hide();
                      }, 1000);
                      setTimeout(function(){
                        $("#message-query").html(success);
                      }, 1000);

                  }else{
                    // console.log("error");
                    // console.log(data);
                    error = "<div class='alert alert-warning alert-dismissible' role='alert'>"
                                +"<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>"
                                +data.messages
                              +"</div>"
                    $("#message-query").html(error);
                    setTimeout(function(){
                        $("#search_request").find("button").removeClass('sending');
                      }, 1000);
                  };
                })
                .fail(function(data) {
                  // console.log("error");
                  // console.log(data);
                  error = "<div class='alert alert-warning alert-dismissible' role='alert'>"
                              +"<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>"
                              +data.statusText
                            +"</div>"
                  $("#message-query").html(error);
                  
                  
                });
          });

        $(".instant-hits-result-pagination").hide();

      }
      rescueImage();
      setImagesPosition();
    }

function renderFacets(content, state) {
  var facetsHtml = '';
  for (var facetIndex = 0; facetIndex < FACETS_ORDER_OF_DISPLAY.length; ++facetIndex) {
    var facetName = FACETS_ORDER_OF_DISPLAY[facetIndex];
    var facetResult = content.getFacetByName(facetName);
    if (!facetResult) continue;
    var facetContent = {};

    facetContent = {
      facet: facetName,
      title: FACETS_LABELS[facetName],
      values: content.getFacetValues(facetName, {sortBy: ['isRefined:desc', 'count:desc']}),
      disjunctive: $.inArray(facetName, PARAMS.disjunctiveFacets) !== -1
    };
    facetsHtml += instantfacetTemplate.render(facetContent);
    }
  $instantSearchFacet.html(facetsHtml);
    
}


  function renderPagination(content, paginate_el, pagination_template)
  {
    var pages = [];
    if (content.page > 3) {
      pages.push({current: false, number: 1});
      pages.push({current: false, number: '...', disabled: true});
    }
    for (var p = content.page - 3; p < content.page + 3; ++p) {
      if (p < 0 || p >= content.nbPages) continue;
      pages.push({current: content.page === p, number: p + 1});
    }
    if (content.page + 3 < content.nbPages) {
      pages.push({current: false, number: '...', disabled: true});
      pages.push({current: false, number: content.nbPages});
    }
    var pagination = {
      pages: pages,
      prev_page: content.page > 0 ? content.page : false,
      next_page: content.page + 1 < content.nbPages ? content.page + 2 : false
    };
    paginate_el.html(pagination_template.render(pagination));
  }


  function renderMoreResults(content){
    $moreResult.html(moreResultsTemplate.render(content));
  }

  function renderHits(content) {
    $hits.html(hitTemplate.render(content));
  }
  function renderHitsHome(content) {
    $hits.html(hitTemplateHome.render(content));
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
      var img = $(".hit-icon img");
      $.each(img, function(index, val) {
         if ($(val).attr("src") == ""){
              $(val).attr('src', "https://d1w99recw67lvf.cloudfront.net/images/generic-hero-small.jpg");
         }
      });
      img = $("img.rescue-image");
      $.each(img, function(index, val) {
         if ($(val).attr("src") == ""){
              $(val).attr('src', "https://d1w99recw67lvf.cloudfront.net/images/generic-hero-small.jpg");
         }
      });
  }
  function checkedFacet(){
    var input = $(".ischecked");
    $.each(input, function(index, val) {
      new_val = $(val).data("value").toLowerCase().replace(" /", "").replace(/\s+/g,"-").replace('/','-')
       if ( new_val ==  $(val).data("checked") ) {
          $(val).click();
       }
    });
    
  }
  setTimeout(function(){
    checkedFacet();
  }, 1500)
// function setImagesPosition(){
//   var outer = $(".outer-js"); //div outer image
//   // var image = $(".inner-js");
//   $.each(outer, function(index, val) {
//     var  outerHeight = $(val).height();
//        outerWidth = $(val).width();
//        inner = $(val).find(".inner-js") //image innner outer div
//     if ( inner.height() > outerHeight) {
//       margin = inner.height() - outerHeight;
//       margin = margin/2;
//       $(inner).css({"position":"relative","top":-margin});
//     }else{
//       $(inner).css({"position":"relative","width":"initial","height":"100%"});
//       setTimeout(function(){
//         margin = inner.width() - outerWidth;
//         margin = margin/2;
//         $(inner).css({"left":-margin});
//         // console.log(inner.width());
//         // console.log(outerWidth);
//       }, 1000);

//     }
//   });
// }


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
