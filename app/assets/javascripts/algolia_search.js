$(document).ready(function(){
  var APPLICATION_ID = 'KXOYK344AM';
  var SEARCH_ONLY_API_KEY = 'fce29aca7a9b823b9cacdbc1faa225e2';
  var INDEX_NAME = 'place';
  var PARAMS = {
    hitsPerPage: 6,
    maxValuesPerFacet: 8,
  };

  var algolia = algoliasearch(APPLICATION_ID, SEARCH_ONLY_API_KEY);
  var algoliaHelper = algoliasearchHelper(algolia, INDEX_NAME, PARAMS);

  $searchInput = $('#search-box');
  $searchInputIcon = $('#search-button');
  $main = $('main');
  $sortBySelect = $('#sort-by-select');
  $hits = $('#hits');
  $stats = $('#stats');
  $facets = $('#facets');
  $pagination = $('#pagination');

  var hitTemplate = Hogan.compile($('#hit-template').text());
  var statsTemplate = Hogan.compile($('#stats-template').text());
  var facetTemplate = Hogan.compile($('#facet-template').text());
  var sliderTemplate = Hogan.compile($('#slider-template').text());
  var paginationTemplate = Hogan.compile($('#pagination-template').text());
  var noResultsTemplate = Hogan.compile($('#no-results-template').text());

  $searchInput
  .on('keyup', function() {
    var query = $(this).val();
    console.log(query);
    if (query.length > 0){
      $('#br15_map').addClass('br15_min_h_530');
      $('.br15_map').removeClass('br15_collapse');
      $('.br15_header').slideUp(400,function(){google.maps.event.trigger(br_map, "resize");});
      $('.br15_search_result').show();
      $('.search-results').show();
      algoliaHelper.setQuery(query);
      algoliaHelper.search();
    } else {
      $('.search-results').hide();
      $('.br15_search_result').hide();
      $('.br15_header').slideDown(400,function(){google.maps.event.trigger(br_map, "resize");});
      $('#br15_map').removeClass('br15_min_h_530');
      $('.br15_map').addClass('br15_collapse');
    }
  })
  .focus();

  // Search results
  algoliaHelper.on('result', function(content, state) {
    console.log(content);
    renderHits(content);
    renderStats(content)
  });

  function renderHits(content) {
    console.log("rendering hits");
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

  // NO RESULTS
  // ==========

  function handleNoResults(content) {
    if (content.nbHits > 0) {
      $main.removeClass('no-results');
      return;
    }
    $main.addClass('no-results');

    var filters = [];
    var i;
    var j;
    for (i in algoliaHelper.state.facetsRefinements) {
      filters.push({
        class: 'toggle-refine',
        facet: i, facet_value: algoliaHelper.state.facetsRefinements[i],
        label: FACETS_LABELS[i] + ': ',
        label_value: algoliaHelper.state.facetsRefinements[i]
      });
    }
    for (i in algoliaHelper.state.disjunctiveFacetsRefinements) {
      for (j in algoliaHelper.state.disjunctiveFacetsRefinements[i]) {
        filters.push({
          class: 'toggle-refine',
          facet: i,
          facet_value: algoliaHelper.state.disjunctiveFacetsRefinements[i][j],
          label: FACETS_LABELS[i] + ': ',
          label_value: algoliaHelper.state.disjunctiveFacetsRefinements[i][j]
        });
      }
    }
    for (i in algoliaHelper.state.numericRefinements) {
      for (j in algoliaHelper.state.numericRefinements[i]) {
        filters.push({
          class: 'remove-numeric-refine',
          facet: i,
          facet_value: j,
          label: FACETS_LABELS[i] + ' ',
          label_value: j + ' ' + algoliaHelper.state.numericRefinements[i][j]
        });
      }
    }
    $hits.html(noResultsTemplate.render({query: content.query, filters: filters}));
  }

  $(document).on('click', '.go-to-page', function(e) {
    e.preventDefault();
    $('html, body').animate({scrollTop: 0}, '500', 'swing');
    algoliaHelper.setCurrentPage(+$(this).data('page') - 1).search();
  });

  // var googlePlaceSearch = function(request, response) {
  //   function initialize() {
  //     var service = new google.maps.places.AutocompleteService();
  //     service.getPlacePredictions({ input: request.term }, callback);
  //   }

  //   function callback(predictions, status) {
  //     if (status != google.maps.places.PlacesServiceStatus.OK) {
  //       console.log(status);
  //       return;
  //     }
  //     response( $.map( predictions, function( item ) {
  //       return {
  //         label: item.description,
  //         value: item.description,
  //         lat: -33.865143,
  //         lng: 151.2099,
  //         resultType: 'Google',
  //         placeId: item.place_id
  //       }
  //     }));
  //   }
  //   initialize();
  // }
});
