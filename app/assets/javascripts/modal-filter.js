(function (win, doc, app) {

    "use strict";

    function ModalFilter($parent, $node, $button) {

        var modalFilter = this;

        modalFilter._$parent = $parent;
        modalFilter._$node = $node;
        modalFilter._$button = $button;
        modalFilter._$background = modalFilter._createBackground();
        modalFilter._$popup = modalFilter._createPopup();
        modalFilter._isOpen = false;

        modalFilter.subscribe = null;
        modalFilter.publish = null;
        modalFilter.publishApply = null;
        modalFilter.unsubscribe = null;

        modalFilter.bindEventListeners();

        modalFilter._change$nodeState(app.device.get('isMobile') ? 'mobile' : 'desktop');

    }

    ModalFilter.prototype.bindEventListeners = function () {

        var modalFilter = this;
        app.mediator.installTo(modalFilter);

        modalFilter.subscribe('resize', function (deviceData) {
            return deviceData.isMobileChanged && modalFilter._change$nodeState(deviceData.isMobile ? 'mobile' : 'desktop');
        });

        modalFilter._$button.on('click', function () {
            modalFilter._isOpen ? modalFilter.hideModal() : modalFilter.showModal();
        });

    };

    ModalFilter.prototype._change$nodeState = function (type) {

        var modalFilter = this;

        switch (type) {

            case 'mobile':
                modalFilter._$popup.append(modalFilter._$node);
                break;

            case 'desktop':
                modalFilter.hideModal();
                modalFilter._$parent.append(modalFilter._$node);
                break;

        }

    };

    ModalFilter.prototype.showModal = function () {

        var modalFilter = this;
        modalFilter._$background.removeClass('hidden');
        modalFilter._$popup.removeClass('hidden');
        modalFilter._isOpen = true;

    };

    ModalFilter.prototype.hideModal = function () {

        var modalFilter = this;
        modalFilter._$background.addClass('hidden');
        modalFilter._$popup.addClass('hidden');
        modalFilter._isOpen = false;

    };

    ModalFilter.prototype._createBackground = function () {

        var $background = $('<div class="modal-filter__background hidden"></div>');

        $background.on('touchmove', function (e) {
            e.preventDefault();
        });

        $('body').append($background);

        return $background;

    };

    ModalFilter.prototype._createPopup = function () {

        var $popup = $('<div class="modal-filter__popup hidden"></div>');

        $('body').append($popup);

        return $popup;

    };

    app.ModalFilter = ModalFilter;

}(window, document, (window.app || (window.app = {}))));
