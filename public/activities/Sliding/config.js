//Sliding Puzzle Configuration File

var Config = {
    //'R,G,B'
    color: '0, 180, 255',           // Main colors and gradients first color, Default: '0, 180, 255'
    color2: '0, 90, 122',           // Gradients second color, Default: '0, 90, 122'
    foreGround: '255, 255, 255',    // text, borders and size selector
    backGround: '0, 0, 0',          // background and grid
    //
    buttons: 'white',               // Button colors: 'white' or 'black'
    //
    fullScreen: true,               // true/false, false=run in fixed canvas, true=run in full window
    hintMovePenalty: 5,             // Hint Move Penalty (classic mode), Default: 5
    hintTimePenalty: 10,            // Hint Time Penalty (challenge mode), Default: 10
    fullImageMovePenalty: 10,       // Show Full Image Move Penalty (classic mode), Default: 10
    fullImageTimePenalty: 15,       // Show Full Image Time Penalty (challenge mode), Default: 15
    //
    quickMode: 1,                   // Quick mode without menu: 0=off,1=classic,2=challenge,3=fun (random image v1.2.4)
    versionCheck: false,            // true/false
    // v1.2.3
    simpleMode: true,              // Simple mode without buttons and timer - true/false
    // v1.2.4
    defaultPuzzleSize: 3,           // Default puzzle size (useful for quickMode)
    gestureStyle: 'tap',          // gestureStyle default setting: 'swipe' or 'tap' (same as in main menu swith at bottom, useful for quickMode with simpleMode which there is no menu)
    packNum: 3,                     // The number of image packs in images folder, the following packages should be named: pack0, pack1, pack2... and etc.
    // v1.2.7
    openOwnImages: true,            // Allow open own images
    videoFPS: 30,                   // Video Puzzle frame/second
    // v1.2.8
    imageForQuickMode: '',   // Image path for quickMode, use the word 'default' to use the default random image
    defaultImagePack: '0',          // You can specify the default image pack, (2 is the video pack by default)
    // v1.2.9
    nextButton: true,               // Next button for the quickMode

    winCallback: 'wonFunc'          // External function for saving scores or something like that

    /*
    Example winCallback:

    function wonFunc(score) {
        var moves = score.moves,
            hours = score.hours,
            minutes = score.minutes,
            seconds = score.seconds;

        // ajax request or something like that here
    }
    */
};
