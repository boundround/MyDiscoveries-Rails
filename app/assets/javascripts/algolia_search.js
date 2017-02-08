function fixMobileOverflowTags() {

    var card = $(".dest-thing.search.cs-dest-thing-search");

    $.each(card, function(index, val) {
        var tag = $(val).find(".tags.tags-result");
        if ($(window).width() <= 320) {
            if (tag.height() > 35) {
                $(val).css({
                    height: '535px'
                });
            } else if (tag.height() > 71) {
                $(val).css({
                    height: '544px'
                });
            }
        } else if ($(window).width() <= 425) {
            if (tag.height() > 35) {
                $(val).css({
                    height: '488px'
                });
            } else if (tag.height() > 71) {
                $(val).css({
                    height: '544px'
                });
            }
        }
    });
}

$(window).resize(function(event) {
    fixMobileOverflowTags();
});

$(document).ready(function() {
    var production_environment = document.querySelector('#environment').dataset.environment;
    var APPLICATION_ID = 'KXOYK344AM';
    var SEARCH_ONLY_API_KEY = 'b2a5d8937365f59e1b2301b45fb1ae35';
    var INDEX_NAME = 'mydiscoveries_' + production_environment;

    if($('.app-wrap > div').data('page') == "offer" && $('.app-wrap > div').data('controller') == "index" ){
        var INDEX_NAME_BOTTOM = 'mydiscoveries_offers_' + production_environment;
    }else{
        var INDEX_NAME_BOTTOM = 'mydiscoveries_' + production_environment;
    }
    var PARAMS = {
        hitsPerPage: 3,
        maxValuesPerFacet: 8,
    };


    var algolia = algoliasearch(APPLICATION_ID, SEARCH_ONLY_API_KEY);
    var algoliaHelper = algoliasearchHelper(algolia, INDEX_NAME, PARAMS);
    var algoliaHelperBottom = algoliasearchHelper(algolia, INDEX_NAME, PARAMS);
    var algoliaHelperMobile = algoliasearchHelper(algolia, INDEX_NAME, PARAMS);

    var FACETS_ORDER_OF_DISPLAY = ['where_destinations', 'subcategory', 'tags'];
    var FACETS_LABELS = {
        subcategory: 'Subcategory',
        tags: 'Places Visited'
    };

    var INSTANT_SEARCH_PARAMS = {
        hitsPerPage: 6,
        maxValuesPerFacet: 8,
        facets: ['is_area'],
        disjunctiveFacets: FACETS_ORDER_OF_DISPLAY
    };

    var algoliaHelperInstantSearch = algoliasearchHelper(algolia, INDEX_NAME_BOTTOM, INSTANT_SEARCH_PARAMS);

    $searchInput = $('.search-box');
    $searchInputBottom = $('.search-box-bottom');
    $searchInputMobile = $('.search-box-mobile');
    $searchInputIcon = $('#search-button');
    $main = $('main');
    $sortBySelect = $('#sort-by-select');
    $hits = $('.hits');
    $stats = $('#stats');
    $facets = $('#facets');
    $moreResultHome = $('.more-result-id-home');
    $moreResultNav = $('.more-result-id-nav');

    var hitTemplate = Hogan.compile($('#hit-template').text());
    var hitTemplateHome = Hogan.compile($('#hit-template-home').text());
    var facetTemplate = Hogan.compile($('#facet-template').text());
    var moreResultsTemplateNav = Hogan.compile($('#more-results-template-nav').text());
    var moreResultsTemplateHome = Hogan.compile($('#more-results-template-home').text());

    //instant search
    $instantSearchInput = $("input.instant-search");
    if ($instantSearchInput.length) {
        searchInstant($instantSearchInput)

        $instantSearchFacet = $('#facets-instant-search')
        $instantSearchFacet2 = $('#facets-instant-search2')
        $instantSearchFacet3 = $('#facets-instant-search3')
        $instantSearchHits = $instantSearchInput.closest('div#instant-search-container').find('div#instant-search-results div.instant-hits-result');
        $instantSearchPagination = $instantSearchInput.closest('div#instant-search-container').find('div#instant-search-results div.pagination');

        var instanthitTemplate = Hogan.compile($('#instant-hit-template').text());
        var instantPaginationTemplate = Hogan.compile($('#instant-pagination-template').text());
        var instantfacetTemplate = Hogan.compile($('#instant-facet-template').text());
        var instantNoResultTemplate = Hogan.compile($('#instant-no-result-template').text());
    }

    function searchCondition(query) {
        if (query.length > 0) {
            algoliaHelper.setQuery(query);
            algoliaHelper.search();
        } else {}
    }

    function searchConditionBottom(query) {
        if (query.length > 0) {
            algoliaHelperBottom.setQuery(query);
            algoliaHelperBottom.search();
        }
    }

    function searchConditionMobile(query) {
        if (query.length > 0) {
            algoliaHelperMobile.setQuery(query);
            algoliaHelperMobile.search();
        }
    }

    function searchInstant(input) {
        query = input.val();
        algoliaHelperInstantSearch.setQuery(query);
        algoliaHelperInstantSearch.search();
    }

    $searchInput
        .on('keyup', function(e) {
            var query = $(this).val();
            searchCondition(query);
            if(query == "" && e.keyCode == 8){
                $('#search-results-container').hide();
            }
        })
        .bind("paste", function() {
            var elem = $(this);
            setTimeout(function() {
                query = elem.val();
                searchCondition(query);
            }, 100);
        })
        .focus();
    $searchInputMobile
        .on('keyup', function() {
            var query = $(this).val();
            searchConditionMobile(query);
        })
        .bind("paste", function() {
            var elem = $(this);
            setTimeout(function() {
                query = elem.val();
                searchConditionMobile(query);
            }, 100);
        })
        .focus();
    $searchInputBottom
        .on('keyup', function(e) {
            var query = $(this).val();
            searchConditionBottom(query);
            if(query == "" && e.keyCode == 8){
                $('.search-results-container').hide();
            }
        })
        .bind("paste", function() {
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
        .bind("paste", function() {
            var elem = $(this);
            setTimeout(function() {
                searchInstant($(this));
            }, 100);
        })
        .focus();
    algoliaHelper.on('result', function(content, state) {
        if (content.hits.length > 0) {
            $('#search-results-container').show();
            $('#search-results-bottom-container').hide();
            renderHitsHome(content);
            renderMoreResultsNav(content);
            rescueImage();
        }
    });
    algoliaHelperBottom.on('result', function(content, state) {
        if (content.hits.length > 0) {
            $('#search-results-bottom-container').show();
            $('#search-results-container').hide();
            renderHitsHome(content);
            renderMoreResultsHome(content);
            rescueImage();
        }
    });

    algoliaHelperMobile.on('result', function(content, state) {
        if (content.hits.length > 0) {
            $('#search-results-mobile-container').show();
            $('#search-results-container').hide();
            renderHitsHome(content);
            renderMoreResultsHome(content);
            rescueImage();
        }
    });

    algoliaHelperInstantSearch.on('result', function(content, state) {
        viatorLink(content.hits);
        seText(content.hits);
        renderInstantHits(content);
        renderFacets(content, state);
        renderPagination(content, $instantSearchPagination, instantPaginationTemplate);
        setImagesPosition();
        subCats();
        fixMobileOverflowTags();
        clearTagHtml();
        setTimeout(function(){
            bucketlist();
            addToFav();
        }, 1000)
    })

    function viatorLink(hits) {
        $.each(hits, function(index, val) {
            if (val.viator_link == "") {
                val.viator_link = {
                    klass: "hide"
                }
            }
        });
    }

    function subCats() {
        var tags = $(".tags-result");
        $.each(tags, function(index, val) {
            if ($(val).data("tags").length > 0) {
                tag = $(val).data("tags").split(",");
                $.each(tag, function(index2, val2) {
                    $(val).append("<div class='tag'><div class='v-center'>" + val2 + "</div></div>");
                });
            }
        });
    }

    function bucketlist(){
        var user_offers = $('#dataBucketOffer').data('bucketlist'),
            user_places = $('#dataBucketPlace').data('bucketlist'),
            user_regions = $('#dataBucketRegion').data('bucketlist'),
            user_stories = $('#dataBucketStory').data('bucketlist'),
            offer_cards = $('[data-klass="offer"]'),
            place_cards = $('[data-klass="place"]');
            region_cards = $('[data-klass="region"]');
            story_cards = $('[data-klass="story"]');

            if(user_offers != undefined || user_offers != ""){
              $.each(offer_cards, function(){
                var id_offer = $(this).data('place-id')
                if(user_offers.includes(id_offer)){
                  $(this).addClass('search-page-card__to-bucket-list--liked').data('liked', 'true')
                }
              })
            }
            if(user_places != undefined){
              $.each(place_cards, function(){
                var id_place = $(this).data('place-id')
                if(user_places.includes(id_place)){
                  $(this).addClass('search-page-card__to-bucket-list--liked').data('liked', 'true')
                }
              })
            }
            if(user_regions != undefined){
              $.each(region_cards, function(){
                var id_region = $(this).data('place-id')
                if(user_regions.includes(id_region)){
                  $(this).addClass('search-page-card__to-bucket-list--liked').data('liked', 'true')
                }
              })
            }
            if(user_stories != undefined){
              $.each(story_cards, function(){
                var id_story = $(this).data('place-id')
                if(user_stories.includes(id_story)){
                  $(this).addClass('search-page-card__to-bucket-list--liked').data('liked', 'true')
                }
              })
            }
    }

    function clearTagHtml(){
        setTimeout(function(){
            $('.search-page-card__info-side.search-page-card__info-side--right').each(function(){
                var wrap_text = $(this).find(".search-page-card__description"),
                    text_old_h2 = $(this).find("h2")
                    text_old_h3 = $(this).find("h3").not('.search-page-card__header')
                    text_old_p = $(this).find("p").not('.search-page-card__description').not('.search-page-card__short-details-key').not('.search-page-card__short-details-value')
                    text_old_span = $(this).find("span").not('.search-page-card__category-item')
                    text_new = "";
                if(text_old_h2.length > 0){
                    text_old_h2.hide();
                    text_new += (text_old_h2.text()+" ")
                }
                if(text_old_h3.length > 0){
                    text_old_h3.hide();
                    text_new += (text_old_h3.text()+" ")
                }
                if(text_old_span.length > 0){
                    text_old_span.hide();
                    text_new += (text_old_span.text()+" ")
                }
                if(text_old_p.length > 0){
                    text_old_p.hide();
                    text_new += (text_old_p.text()+" ")
                }

                text_new = text_new.substr(0,200)+" ...";
                if(text_old_h2.length > 0 || text_old_h3.length > 0 || text_old_span.length > 0 || text_old_p.length > 0){
                    wrap_text.append(text_new);
                }
            })
        }, 100)
    }

    function seText(hits) {
        $.each(hits, function(index, val) {
            val.description = val.description.substring(0, 235) + '...';
        });
    }

    $(document).on('click', '.go-to-page-instant-search', function(e) {
        e.preventDefault();
        $('html, body').animate({
            scrollTop: 0
        }, '500', 'swing');
        algoliaHelperInstantSearch.setCurrentPage(+$(this).data('page') - 1).search();
    });

    $(document).on('click', '.instant-search-toggle-refine', function(e) {
        algoliaHelperInstantSearch.toggleRefine($(this).data('facet'), $(this).data('value')).search();
    });

    $(document).on('click', 'a.search-results-card,.dest-thing.search.cs-dest-thing-search a', function(e) {
        $.post('/searchables/algolia-click/' + $(this).data('object-id'));
    });

    function renderInstantHits(content) {
        if (content.hits.length > 0) {
            $.each(content.hits, function(){
                if($(this)[0].where_destinations == "Offers"){
                    $(this)[0]["is_offer"] = true
                    $(this)[0]["is_story"] = false
                }else if($(this)[0].where_destinations == "Stories"){
                    $(this)[0]["is_offer"] = false
                    $(this)[0]["is_story"] = true
                }else{
                    $(this)[0]["is_offer"] = false
                    $(this)[0]["is_story"] = false
                }
                if($(this)[0].objectID.includes("_")){
                    $(this)[0]["ID"] = $(this)[0].objectID.split('_')[1]
                    $(this)[0]["object"] = $(this)[0].objectID.split('_')[0]
                }else{
                    $(this)[0]["ID"] = $(this)[0].objectID
                }
            })
            $instantSearchHits.html(instanthitTemplate.render(content));
            $(".instant-hits-result-pagination").show();
        } else {

            $instantSearchHits.html(instantNoResultTemplate.render(content));

            $(".show_form_request").click(function() {
                $("#search_request").show();
            });


            $("form#search_request").submit(function(event) {
                event.preventDefault();
                var form_value = ($(this).serialize());

                $(this).find("button").addClass('sending');
                $.ajax({
                        url: '/search_requests/create',
                        type: 'post',
                        dataType: 'json',
                        data: form_value,
                    })
                    .done(function(data) {


                        if (data.success == true) {
                            success = "<div class='alert alert-success alert-dismissible' role='alert'>" +
                                "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>" +
                                "Thank you, Your request has been sent to <strong>info@boundround.com.</strong> &nbsp;&nbsp; <a href='/' style='color: #3c763d;'>Back to home</a>" +
                                "</div>"
                            setTimeout(function() {
                                $("#search_request").find("button").removeClass('sending');
                            }, 1000);
                            setTimeout(function() {
                                $("#search_request").hide();
                            }, 1000);
                            setTimeout(function() {
                                $("#message-query").html(success);
                            }, 1000);

                        } else {


                            error = "<div class='alert alert-warning alert-dismissible' role='alert'>" +
                                "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>" +
                                data.messages +
                                "</div>"
                            $("#message-query").html(error);
                            setTimeout(function() {
                                $("#search_request").find("button").removeClass('sending');
                            }, 1000);
                        };
                    })
                    .fail(function(data) {


                        error = "<div class='alert alert-warning alert-dismissible' role='alert'>" +
                            "<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>" +
                            data.statusText +
                            "</div>"
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
        var facetsHtml2 = '';
        var facetsHtml3 = '';
        for (var facetIndex = 0; facetIndex < FACETS_ORDER_OF_DISPLAY.length; ++facetIndex) {
            var facetName = FACETS_ORDER_OF_DISPLAY[facetIndex];
            var facetResult = content.getFacetByName(facetName);
            if (!facetResult) continue;

            if (facetResult.name == 'where_destinations'){
                var facetContent2 = {};

                facetContent2 = {
                    facet: facetName,
                    title: FACETS_LABELS[facetName],
                    values: content.getFacetValues(facetName, {
                        sortBy: ['isRefined:desc', 'count:desc']
                    }),
                    disjunctive: $.inArray(facetName, PARAMS.disjunctiveFacets) !== -1
                };

                facetContent2.values.sort(function(a, b){
                  return a.name.localeCompare(b.name);
                })

                facetsHtml2 += instantfacetTemplate.render(facetContent2);
            }else if (facetResult.name == 'age_range'){
                var facetContent3 = {};

                facetContent3 = {
                    facet: facetName,
                    title: FACETS_LABELS[facetName],
                    values: content.getFacetValues(facetName, {
                        sortBy: ['isRefined:desc', 'count:desc']
                    }),
                    disjunctive: $.inArray(facetName, PARAMS.disjunctiveFacets) !== -1
                };

                facetContent3.values.sort(function(a, b){
                  return a.name.localeCompare(b.name);
                })

                facetsHtml3 += instantfacetTemplate.render(facetContent3);
            }else {
                var facetContent = {};

                facetContent = {
                    facet: facetName,
                    title: FACETS_LABELS[facetName],
                    values: content.getFacetValues(facetName, {
                        sortBy: ['isRefined:desc', 'count:desc']
                    }),
                    disjunctive: $.inArray(facetName, PARAMS.disjunctiveFacets) !== -1
                };

                facetContent.values.sort(function(a, b){
                  return a.name.localeCompare(b.name);
                })

                facetsHtml += instantfacetTemplate.render(facetContent);
            }
        }

        $instantSearchFacet.html(facetsHtml);
        $instantSearchFacet2.html(facetsHtml2);
        $instantSearchFacet3.html(facetsHtml3);
    }


    function renderPagination(content, paginate_el, pagination_template) {
        var pages = [];
        if (content.page > 3) {
            pages.push({
                current: false,
                number: 1
            });
            pages.push({
                current: false,
                number: '...',
                disabled: true
            });
        }
        for (var p = content.page - 3; p < content.page + 3; ++p) {
            if (p < 0 || p >= content.nbPages) continue;
            pages.push({
                current: content.page === p,
                number: p + 1
            });
        }
        if (content.page + 3 < content.nbPages) {
            pages.push({
                current: false,
                number: '...',
                disabled: true
            });
            pages.push({
                current: false,
                number: content.nbPages
            });
        }
        var pagination = {
            pages: pages,
            prev_page: content.page > 0 ? content.page : false,
            next_page: content.page + 1 < content.nbPages ? content.page + 2 : false
        };
        paginate_el.html(pagination_template.render(pagination));
    }


    function renderMoreResultsNav(content) {
        $moreResultNav.html(moreResultsTemplateNav.render(content));
    }

    function renderMoreResultsHome(content) {
        $moreResultHome.html(moreResultsTemplateHome.render(content));
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

    function rescueImage() {
        var img = $(".hit-icon img");
        $.each(img, function(index, val) {
            if ($(val).attr("src") == "") {
                $(val).attr('src', "https://d1w99recw67lvf.cloudfront.net/images/generic-hero-small.jpg");
            }
        });
        img = $("img.rescue-image");
        $.each(img, function(index, val) {
            if ($(val).attr("src") == "") {
                $(val).attr('src', "https://d1w99recw67lvf.cloudfront.net/images/generic-hero-small.jpg");
            }
        });
    }

    function checkedFacet() {
        var input = $(".ischecked");
        $.each(input, function(index, val) {
            new_val = $(val).data("value").toLowerCase().replace(" /", "").replace(/\s+/g, "-").replace('/', '-')
            if (new_val == $(val).data("checked")) {
                $(val).click();
            }
        });

    }
    setTimeout(function() {
        checkedFacet();
    }, 1500)

    $(".brief-background").click(function(event) {
        $("#search-results-bottom-container").hide();
    });

    $searchInputBottom.click(function(event) {
        if ($(this).val().length) {
            $("#search-results-bottom-container").show();
        }
        $("#search-results-container").hide();
    });

    $searchInput.click(function(event) {
        if ($(this).val().length) {
            $("#search-results-container").show();
        }
        $("#search-results-bottom-container").hide();

    });

    $(".app-wrap").click(function(event) {
        $("#search-results-container").hide();
    });

});
