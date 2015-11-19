$(document).ready(function(){
  var APPLICATION_ID = 'KXOYK344AM';
  var SEARCH_ONLY_API_KEY = 'fce29aca7a9b823b9cacdbc1faa225e2';
  var INDEX_NAME = 'place';
  var PARAMS = {
    hitsPerPage: 6,
    maxValuesPerFacet: 8,
  };

  var br_place_markerCluster = null;

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
    if (query.length > 0){
      algoliaHelper.setQuery(query);
      algoliaHelper.search();
    } else {
      $('.search-results').hide();
      $('.search-results-container').hide();
      $('.google-results-container').hide();
      $('.br15_search_result').hide();
      $('.br15_header').slideDown(400,function(){google.maps.event.trigger(br_map, "resize");});
      $('#br15_map').removeClass('br15_min_h_530');
      $('.br15_map').addClass('br15_collapse');
      //animate map overlay
    }
  })
  .focus();

  // Search results
  algoliaHelper.on('result', function(content, state) {
    if (content.hits.length > 0){
      $('#br15_map').addClass('br15_min_h_530');
      $('.br15_map').removeClass('br15_collapse');
      $('.br15_header').slideUp(400,function(){google.maps.event.trigger(br_map, "resize");});
      $('.br15_search_result').show();
      $('.search-results').show();
      $('.search-results-container').show();
      $('.google-results-container').show();
      $('.google-results-container').append($('.pac-container'));
      renderHits(content);
      $('#magnifying-glass').on('click', function(){
        var data = $('.hit-result')[0];
        var link = $(data).data("link");
        window.location = link;
      });

      //This function lives in br_google_maps
      if ($('#br15_map').length){
        updateMapWithAlgoliaSearchResults(content);
      }

      renderStats(content);
      renderPagination(content);
    } else {
      // $('.search-results').hide();
      // $('.search-results-container').hide();
      // $('.br15_search_result').hide();
      $('.google-results-container').append($('.pac-container'));
      $('.br15_header').slideDown(400,function(){google.maps.event.trigger(br_map, "resize");});
      $('#br15_map').removeClass('br15_min_h_530');
      $('.br15_map').addClass('br15_collapse');
    }
  });

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

  function renderPagination(content) {
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
    $pagination.html(paginationTemplate.render(pagination));
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
    // $('html, body').animate({scrollTop: 0}, '500', 'swing');
    algoliaHelper.setCurrentPage(+$(this).data('page') - 1).search();
  });

  $("#search-box").geocomplete({
    types: ['establishment'],
    map: "#place-holder"
  }).bind("geocode:result", function(event, result){
    console.log(result);
    createNewPlaceFromGooglePlaces(result);
  });

  var createNewPlaceFromGooglePlaces = function(googleSearchResult, userIP){
    var map2 = new google.maps.Map(document.getElementById('place-holder'));
    var service = new google.maps.places.PlacesService(map2);
    var placeDetails;
    var request = {
      placeId: googleSearchResult.place_id
    };
    service.getDetails(request, function(place, status) {
      if (status == google.maps.places.PlacesServiceStatus.OK) {
        console.log(place);
        console.log(place.name.toLowerCase());
        $.ajax({
          beforeSend: function(){
            console.log("checking BR places");
            var allPlaces = [];
            var allAreas = [];
            // var allBoundRoundPlaces;
            $.ajax({
                url: '/areas/mapdata.json',
                success: function(data) {
                  allAreas = data["features"];

                  $.ajax({
                    url: '/places/mapdata.json',
                    success: function(data) {
                      allPlaces = data["features"];
                      allCountries = data["countries"];
                      window.allBoundRoundPlaces = allPlaces.concat(allAreas).concat(allCountries);

                      for (var i = 0; i < allBoundRoundPlaces.length; i++){
                        if (place.name.toLowerCase().trim() == allBoundRoundPlaces[i].properties.title.toLowerCase().trim()){
                          window.location.href = allBoundRoundPlaces[i].properties.url;
                        }
                      }
                    }
                  });
                }
              });
          },
          url: "/places/user_create.js",
          type: "POST",
          data: { place: {display_name: place.name, display_address: place.formatted_address,
                  latitude: place.geometry.location.lat(), longitude: place.geometry.location.lng(),
                  phone_number: place.formatted_phone_number, website: place.website,
                  place_id: googleSearchResult.place_id, user_created: true, subscription_level: "basic"}, address_components: place.address_components },
          success: function(data){
            if (data.place_id !== "error"){
              window.location.href = data.place_id;
            } else {
              alert("Please try your search again");
            }
          }
        });
      }
    });
  }

});
