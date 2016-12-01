(function (win) {

    win.util = {

        waitFor: function (testFn, maxTime) {

            var timeCheck = 10;

            return new Promise(function (resolve, reject) {

                setTimeout(function checkMe() {

                    if (testFn()) {
                        resolve();
                        return;
                    }

                    maxTime -= timeCheck;

                    if (maxTime <= 0) {
                        reject();
                        return;
                    }

                    setTimeout(checkMe, timeCheck);

                }, timeCheck);

            });

        }

    }

}(window));