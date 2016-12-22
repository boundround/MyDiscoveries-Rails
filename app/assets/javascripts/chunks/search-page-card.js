$(function () {

    "use strict";

    var app = window.app,
        ModalFilter = app.ModalFilter;

    // add to bucket list
    $('.js-search-page-card__to-bucket-list').on('click', function () {
        $(this).toggleClass('search-page-card__to-bucket-list--liked');
    });

    $('.js-show-more-card-info').on('click', function () {
        $(this).parents('.search-page-card').toggleClass('search-page-card--show-more-info');
    });

    $('.js-filter-category-opener').on('click', function () {
        $(this).parents('.search-page-filter__field-set').toggleClass('search-page-filter__field-set--mobile-opened');
    });

    new ModalFilter(
        $('.js-search-page-filter-wrapper'),
        $('.js-modal-filter-popup-wrapper'),
        $('.js-show-hide-filter-result-button')
    );

});
