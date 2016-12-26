(function (win, doc, app) {

    "use strict";

    var device = app.device;

    var swipers = [];

    var cfg = {
        normal: {
            scrollbar: '.swiper-scrollbar',
            scrollbarHide: true,
            slidesPerView: 'auto',
            spaceBetween: 0,
            grabCursor: false,
            preventClicks: false
        },
        centered: {
            scrollbar: '.swiper-scrollbar',
            scrollbarHide: true,
            slidesPerView: 'auto',
            spaceBetween: 0,
            grabCursor: false,
            preventClicks: false,
            // diff of normal
            centeredSlides: true
        },
        double: {
            scrollbar: '.swiper-scrollbar',
            scrollbarHide: true,
            slidesPerView: 'auto',
            spaceBetween: 0,
            grabCursor: false,
            preventClicks: false,
            // diff of normal
            nextButton: '.horizontal-slider__right-arrow',
            prevButton: '.horizontal-slider__left-arrow'
        }
    };


    function init() {

        destroy();

        if (!device.get('isMobile')) {
            return;
        }

        var nodes = $('.js-horizontal-scroll, .js-horizontal-scroll--centered-slides');

        swipers = Array.prototype.map.call(nodes, function (node) {

            var $node = $(node);

            $node.addClass('added-swiper');

            if ($node.hasClass('js-horizontal-scroll')) {
                return new Swiper($node, cfg.normal);
            }

            if ($node.hasClass('js-horizontal-scroll--centered-slides')) {
                return new Swiper($node, cfg.centered);
            }

        });

    }

    function destroy() {
        swipers.forEach(function (swiper) {
            swiper.wrapper.parent().removeClass('added-swiper');
            swiper.destroy(false, true);
        });
    }

    app.mediator.subscribe('init-swiper', init);

    app.mediator.subscribe('resize', function (deviceData) {
        return deviceData.isMobileChanged && init();
    });

}(window, document, (window.app || (window.app = {}))));
