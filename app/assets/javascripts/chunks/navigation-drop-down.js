$(function () {

    "use strict";

    var $navigationDropDown = $('.js-navigation-drop-down');
    var $mobileHeaderDropDownContainer = $('.js-mobile-header-drop-down_container');
    var nodeMobileHeaderDropDownContainer = $mobileHeaderDropDownContainer.get(0);
    var $mobileHeaderSearchWrapper = $('.js-mobile-header__search-wrapper');
    var $mobileHeaderDropDown = $('.js-mobile-header-drop-down');
    var $headerDropDownBackground = $('.js-header-drop-down-background');
    var $mobileHeaderDropDownBackground = $('.js-mobile-header-drop-down-background');
    var $mobileHeader = $('.js-mobile-header');
    var $mobileShowHideSearch = $('.js-mobile-show-hide-search');
    var $mobileHeaderMenuButton = $('.js-mobile-header__menu-button');

    function showNavigationDropDown() {
        $navigationDropDown.removeClass('hidden');
        $headerDropDownBackground.removeClass('hidden')
    }

    function hideNavigationDropDown() {
        $navigationDropDown.addClass('hidden');
        $headerDropDownBackground.addClass('hidden')
    }


    function hideMobileSearchWrapper() {

        if ($mobileHeaderSearchWrapper.hasClass('hidden')) {
            return;
        }

        $mobileShowHideSearch.trigger('click');

    }

    function hideMobileMenu() {

        if ($mobileHeaderDropDown.hasClass('hidden')) {
            return;
        }

        $mobileHeaderMenuButton.trigger('click');

    }

    $navigationDropDown
        .on('mouseover', showNavigationDropDown)
        .on('mouseout', hideNavigationDropDown);

    $('.js-change-navigation-drop-down')
        .on('mouseover', showNavigationDropDown)
        .on('mouseout', hideNavigationDropDown);

    $('.js-mobile-header-drop-down--to-right').on('click', function () {
        TweenLite.killTweensOf(nodeMobileHeaderDropDownContainer);
        TweenLite.to(nodeMobileHeaderDropDownContainer, 1, {x: '-50%', ease: Back.easeOut.config(1)});
    });

    $('.js-mobile-header-drop-down--to-left').on('click', function () {
        TweenLite.killTweensOf(nodeMobileHeaderDropDownContainer);
        TweenLite.to(nodeMobileHeaderDropDownContainer, 1, {x: '0%', ease: Back.easeOut.config(1)});
    });

    $mobileShowHideSearch.on('click', function () {
        hideMobileMenu();
        $mobileHeaderSearchWrapper.toggleClass('hidden');
    });

    $mobileHeaderMenuButton.on('click', function () {
        hideMobileSearchWrapper();
        $mobileHeaderDropDown.toggleClass('hidden');
        $mobileHeaderDropDownBackground.toggleClass('hidden');
        $mobileHeader.toggleClass('mobile-header--open');
        $mobileHeaderMenuButton.toggleClass('mobile-header__menu-button--open');
    });

    $mobileHeaderDropDownBackground.on('touchmove', function (e) {
        e.preventDefault();
    });

});
