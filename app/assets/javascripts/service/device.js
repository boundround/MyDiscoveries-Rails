(function (win, doc, app) {

    var DESKTOP_WIDTH = 1200;

    function Device() {

        var device = this;

        device._attr = {
            width: 0,
            height: 0,
            orientation: '_',
            isTouch: false,
            isMobile: false,
            DPR: 1
        };

        device.bindEventListeners();

        device.set('isTouch', 'ontouchstart' in doc);
        device.set('DPR', win.devicePixelRatio || 1);

        device.detectScreen();

    }

    Device.prototype.get = function (key) {
        return this._attr[key];
    };


    Device.prototype.set = function (key, value) {
        return this._attr[key] = value;
    };

    Device.prototype.bindEventListeners = function () {

        var device = this;

        function onResize() {
            return device.onResize();
        }

        device.set('onResize', onResize);

        window.addEventListener('resize', onResize, false);

    };

    Device.prototype.unBindEventListeners = function () {

        var device = this,
            win = device.get('win'),
            onResize = device.get('onResize');

        window.removeEventListener('resize', onResize, false);

    };

    Device.prototype.onResize = function () {

        var device = this,
            oldOrientation = device.get('orientation'),
            oldIsMobile = device.get('isMobile'),
            orientation, isMobile;

        device.detectScreen();

        orientation = device.get('orientation');
        isMobile = device.get('isMobile');

        app.mediator.publish('resize', {
            width: device.get('width'),
            height: device.get('height'),
            orientation: orientation,
            isMobile: isMobile,
            orientationChanged: oldOrientation !== orientation,
            isMobileChanged: oldIsMobile !== isMobile
        });

    };

    Device.prototype.detectScreen = function () {

        var device = this,
            // width = doc.documentElement.clientWidth,
            // height = doc.documentElement.clientHeight,
            width = win.innerWidth,
            height = win.innerHeight,
            isMobile = DESKTOP_WIDTH >= width,
            orientation = width > height ? '_' : '|';

        device.set('width', width);
        device.set('height', height);
        device.set('orientation', orientation);
        device.set('isMobile', isMobile);

    };

    Device.prototype.destroy = function () {

        var device = this;

        device.unBindEventListeners();

        device._attr = {};

    };

    app.Device = Device;

    app.device = new Device();

}(window, document, (window.app || (window.app = {}))));
