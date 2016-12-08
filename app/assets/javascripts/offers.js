(function () {

    "use strict";

    function init() {

        $('.js-show-hide-info-block').on('click', function () {
            $(this).parent().toggleClass('deal-data-card--open-card');
        });

    }

    $(window).on('load', init);

}());
