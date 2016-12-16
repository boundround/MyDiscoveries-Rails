(function (win, doc, app) {

    "use strict";

    var channels = {};

    function subscribe(channel, fn) {

        if (!channels.hasOwnProperty(channel)) {
            channels[channel] = [];
        }

        channels[channel].push({context: this, callback: fn});

        return this;

    }

    function publishApply(channel, args) {

        var list = channels[channel],
            i, len, item;

        if (!list) {
            return this;
        }

        for (i = 0, len = list.length; i < len; i += 1) {
            item = list[i];
            item.callback.apply(item.context, args);
        }

        return this;

    }

    function publish(channel, arg0, arg1, arg2, arg3, arg4) {

        var list = channels[channel],
            i, len, item;

        console.log(channel, arg0, arg1, arg2, arg3, arg4);

        if (!list) {
            return this;
        }


        switch (arguments.length) {

            case 1:

                for (i = 0, len = list.length; i < len; i += 1) {
                    item = list[i];
                    item.callback.call(item.context);
                }

                break;

            case 2:

                for (i = 0, len = list.length; i < len; i += 1) {
                    item = list[i];
                    item.callback.call(item.context, arg0);
                }

                break;

            case 3:

                for (i = 0, len = list.length; i < len; i += 1) {
                    item = list[i];
                    item.callback.call(item.context, arg0, arg1);
                }

                break;

            case 4:

                for (i = 0, len = list.length; i < len; i += 1) {
                    item = list[i];
                    item.callback.call(item.context, arg0, arg1, arg2);
                }

                break;

            case 5:

                for (i = 0, len = list.length; i < len; i += 1) {
                    item = list[i];
                    item.callback.call(item.context, arg0, arg1, arg2, arg3);
                }

                break;

            case 6:

                for (i = 0, len = list.length; i < len; i += 1) {
                    item = list[i];
                    item.callback.call(item.context, arg0, arg1, arg2, arg3, arg4);
                }

                break;

        }

        return this;

    }

    function filterFunction(item) {
        return item.context !== this;
    }

    function unsubscribe(channel) {

        var ch, obj = this;

        if (!channel) {

            for (ch in channels) {
                obj.unsubscribe(ch);
            }

            return obj;

        }

        if (channels.hasOwnProperty(channel)) {
            channels[channel] = channels[channel].filter(filterFunction, obj);
        }

        return obj;

    }

    app.mediator = {
        subscribe: subscribe,
        publish: publish,
        publishApply: publishApply,
        unsubscribe: unsubscribe,
        installTo: function (obj) {
            obj.subscribe = subscribe;
            obj.publish = publish;
            obj.publishApply = publishApply;
            obj.unsubscribe = unsubscribe;
        },
        uninstallFrom: function (obj) {
            obj.subscribe = null;
            obj.publish = null;
            obj.publishApply = null;
            obj.unsubscribe = null;
        }
    };

}(window, document, (window.app || (window.app = {}))));
