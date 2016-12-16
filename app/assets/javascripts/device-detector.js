(function (win, doc) {

    'use strict';

    function getPlatform() {
        return 'ontouchstart' in doc ? 'platform-mobile' : 'platform-desktop';
    }

    function getDesktopOS() {

        var appVersion = win.navigator.appVersion;

        if (appVersion.indexOf('Win') !== -1) {
            return 'os-windows'
        }

        if (appVersion.indexOf('Mac') !== -1) {
            return 'os-macos'
        }

        if (appVersion.indexOf('X11') !== -1) {
            return 'os-unix';
        }

        if (appVersion.indexOf('Linux') !== -1) {
            return 'os-linux';
        }

        return 'os-unknown';

    }

    function getDesktopBrowser() {

        // Opera 8.0+
        if ((!!window.opr && !!opr.addons) || !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0) {
            return 'browser-opera';
        }

        // Firefox 1.0+
        if (typeof InstallTrigger !== 'undefined') {
            return 'browser-ff'
        }

        // Safari 3.0+ '[object HTMLElementConstructor]'
        if (
            Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0 || (function (p) {
                return p.toString() === '[object SafariRemoteNotification]';
            })(!window['safari'] || safari.pushNotification)
        ) {
            return 'browser-safari';
        }

        // Internet Explorer 6-11
        if (/*@cc_on!@*/false || !!document.documentMode) {
            return 'browser-ie';
        }

        // Edge 20+
        if (!!window.StyleMedia) {
            return 'browser-edge';
        }

        // Chrome 1+
        if (!!window.chrome && !!window.chrome.webstore) {
            return 'browser-chrome';
        }

    }

    function getMobileOS() {

        var ua = win.navigator.userAgent,
            isWP = /MSIE/.test(ua),
            isAndroid = (/android/i).test(ua),
            isIOS = /iPad|iPhone|iPod/.test(ua);

        if (isWP) {
            return 'mobile-wp';
        }

        if (isAndroid) {
            return 'mobile-android android-version-' + ua.toLowerCase().match(/android\s([0-9\.]*)/);
        }

        if (isIOS) {
            return 'mobile-ios';
        }

    }

    function getMobileBrowser() {
        /* add code if needed */
        return '';
    }

    function detectDevice() {

        var platform = getPlatform(),
            body = doc.body;

        switch (platform) {

            case 'platform-desktop':
                body.className += ' ' + [platform, getDesktopOS(), getDesktopBrowser()].join(' ');
                break;

            case 'platform-mobile':
                body.className += ' ' + [platform, getMobileOS(), getMobileBrowser()].join(' ');
                break;

        }

    }

    (function waitFor() {
        return doc.body ? detectDevice() : win.setTimeout(waitFor, 100);
    }());

}(window, window.document));

