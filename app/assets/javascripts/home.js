$(document).ready(function(){
    var mq767 = window.matchMedia('(max-width:767px)');
    var mq991 = window.matchMedia('(max-width:991px)');

    var mobileOwlCarouselsCreated = false;
    var tabletOwlCarouselsCreated = false;
    var screen = $(window);

    mq767.addListener(function(changed){
        if(!changed.matches && mobileOwlCarouselsCreated){
            $('.home-page .carousel').owlCarousel().trigger('destroy.owl.carousel');
            mobileOwlCarouselsCreated = false;
        }
        else if(changed.matches && !mobileOwlCarouselsCreated){
            createMobileOwlCarousel();
        }
    });

    mq991.addListener(function(changed){
        if(!changed.matches){
            $('.home-page .activity-carousel').owlCarousel().trigger('destroy.owl.carousel');
            tabletOwlCarouselsCreated = false;
        }
        else if(changed.matches){
            createTabletOwlCarousel();
            tabletOwlCarouselsCreated = true;
        }
    });

    var createTabletOwlCarousel = function(){
        $(".home-page .activity-carousel").owlCarousel({
            loop:false,
            items: 2,
            responsive: {
                0: {
                    items: 1
                },
                768: {
                    items: 2
                }
            },
            nav: true,
            navText: ["<div class='nav-prev'></div>","<div class='nav-next'></div>"]
        });
    }

    var createMobileOwlCarousel = function(){
        $(".home-page .carousel").owlCarousel({
            loop:false,
            items: 1,
            nav: true,
            navText: ["<div class='nav-prev'></div>","<div class='nav-next'></div>"]
        });

        mobileOwlCarouselsCreated = true;
    };

    if(screen.width() < 768){
        createMobileOwlCarousel();
    }

    if(screen.width() < 991){
        createTabletOwlCarousel();
    }
});

// (function(){

//     // var bannerSearchResults = $(".banner-wrapper .search-results");

//     // function showSearchResults() {
//     //     bannerSearchResults.removeClass("hide");
//     // }

//     // function hideSearchResults() {
//     //     bannerSearchResults.addClass("hide");
//     // }

//     // var searchInput = $(".banner-wrapper input.search");

//     //todo delete this. it's for demo purposes to show search result.
//     // searchInput.focus(function(event) {
//     //     showSearchResults();
//     // });

//     //todo delete this. it's for demo purposes to hide search result.
//     // $(".brief-background").click(function(event) {
//     //     hideSearchResults();
//     // });
// })();