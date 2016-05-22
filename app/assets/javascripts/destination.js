$(document).ready(function() {
    var mq767 = window.matchMedia('(max-width:767px)');
    var mobileOwlCarouselsCreated = false;
    var screen = $(window);

    mq767.addListener(function(changed) {
        if (!changed.matches && mobileOwlCarouselsCreated) {
            $('.destination-page .carousel').owlCarousel().trigger('destroy.owl.carousel');
            mobileOwlCarouselsCreated = false;
        } else if (changed.matches && !mobileOwlCarouselsCreated) {
            createMobileOwlCarousel();
        }
    });

    var createMobileOwlCarousel = function() {
        $(".destination-page .carousel").owlCarousel({
            loop: false,
            items: 1,
            nav: true,
            navText: ["<div class='nav-prev'></div>", "<div class='nav-next'></div>"]
        });

        mobileOwlCarouselsCreated = true;
    };

    if (screen.width() < 768) {
        createMobileOwlCarousel();
    }

    $(".destination-page .large-owl-carousel").owlCarousel({
        loop: false,
        items: 1,
        nav: false,
        dots: true
    });

    $(".destination-page .fun-fact-carousel").owlCarousel({
        loop: false,
        items: 2,
        responsive: {
            0: {
                items: 1
            },
            991: {
                items: 2
            }
        },
        nav: true,
        navText: ["<div class='nav-prev'></div>", "<div class='nav-next'></div>"]
    });

    //init sub nav smooth scrolling
    smoothScroll.init({ offset: 60 });
    $(".sticky-container").sticky();

});
