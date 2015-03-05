"use strict";
var version = '1.4.1',
    language = window.navigator.userLanguage || window.navigator.language,
    canvas = document.getElementById('canvas'),
    ctx = canvas.getContext('2d'),
    $canvas = $('canvas'),
    $ctnest = $('#ctnest'),
    imagepackN = 0,
    NUM = 3,
    hintMovePenalty = 5,
    hintTimePenalty = 10,
    fullImageMovePenalty = 10,
    fullImageTimePenalty = 15,
    imagecount = 23,
    src = -1,
    dst = -1,
    place = [],
    animation = true,
    grid = true,
    swapped = false,
    hint = false,
    once = false,
    swapHint = false,
    customGame = false,
    lost = false,
    swipe = true,
    newHigh = false,
    cWon = false,
    timerStarted,
    Config,
    HEIGHT,
    WIDTH,
    PORTRAIT,
    BSIZE,
    mode,
    animIcon,
    showfullIcon,
    hintIcon,
    swapIcon,
    gridIcon,
    imageOn = 'b',
    imageOff = 'w',
    alertM,
    Menu,
    ImageMenuItem,
    MyImageItem,
    MyTextItem,
    MyGridItem,
    MyRectItem,
    videopuzzle,
    video,
    parentOffsetLeft = 0,
    parentOffsetTop = 0,
    x,
    fakeNeighS,
    fakeNeighD,
    cx,
    cy,
    imageW,
    imageH,
    kepW,
    kepH,
    ratio,
    SIZEX,
    SIZEY,
    scaledW,
    swaps,
    sourceRect,
    destinationRect,
    sourceImage,
    destinationImage,
    imageStroke,
    available_version,
    animoldicon,
    animold,
    hours = 0,
    minutes = 0,
    msecs = 0,
    seconds = 0,
    moves = 0,
    animv,
    packN,
    getScore,
    setScore,
    selectedImage,
    gamemode,
    maxW,
    activePage,
    clickCheck,
    videoendloop,
    inGameButtons,
    kep = new Image(),
    packIcon,
    openIcon,
    nextIcon,
    infoIcon,
    loadingS = true,
    hover,
    myT,
    MyD,
    delay = 0,
    loadingP = 0,
    loadingL = 0,
    mousePos,
    imageNumX = 6,
    imageNumY = 4,
    imageSizeW,
    imageSizeH,
    images,
    imagepacks,
    switchIcon = 'l',
    modeshow = 'classic',
    videoloop,
    LANG_LOADING,
    confLoaded = false,
    isFullImgHint = false,
    packPage,
    lostPage,
    classiciPage,
    challengeiPage,
    funiPage,
    infoPage,
    newGamePage,
    fullImagePage,
    imageSelectedPage,
    messagePage,
    imagePage,
    sizePage,
    mainPage,
    myD,
    //Functions
    generateVariables,
    loadjs,
    keveres,
    getXYD,
    getXYS,
    getN,
    isInt,
    scoreCallback,
    isWon,
    isEnd,
    scores,
    neighbors,
    drawHint,
    repaint,
    repaint2,
    startPuzzle,
    isTouchDevice,
    myTimer,
    move,
    setNUM,
    selectImage,
    versionCheck,
    loadAll,
    loading,
    handleFileSelect,
    myDelay,
    getMousePos,
    onloadImg,
    langLoad,
    confLoad,
    winCallback;

language = language.split('-', 1)[0];

generateVariables = function () {
    var i;
    for (i = 0; i < 24; i++) {
        window['pack' + i + 'A'] = false;
    }
};

generateVariables();

loadjs = function (filename, id, callback) {
    var done = false,
        script = document.createElement('script');

    loadjs.handleLoad = function () {
        if (!done) {
            console.log('Note: "' + filename + '" is loaded sucessfully!');

            done = true;
            if (callback) {
                callback(filename, "ok");
            }
        }
    };
    loadjs.handleReadyStateChange = function () {
        var state;

        if (!done) {
            state = script.readyState;
            if (state === "complete") {
                loadjs.handleLoad();
            }
        }
    };
    loadjs.handleError = function () {
        if (!done) {
            console.error('Error: "' + filename + '" is not loaded!');

            done = true;
            if (callback) {
                callback(filename, "error");
            }
        }
    };

    script.type = 'text/javascript';
    script.onload = loadjs.handleLoad;
    script.onreadystatechange = loadjs.handleReadyStateChange;
    script.onerror = loadjs.handleError;
    script.src = filename;

    if (id !== '') {
        script.id = id;
    }

    document.head.appendChild(script);
};

// keverés
keveres = function () {
    var rnd,
        tmp,
        i;

    for (i = 0; i < place.length; i++) {
        rnd = Math.floor(Math.random() * place.length);
        tmp = place[i];
        place[i] = place[rnd];
        place[rnd] = tmp;

        if (isEnd()) {
            keveres();
        }
    }
};

getXYD = function (n) {
    var x = (n % NUM) * SIZEX,
        y = Math.floor(n / NUM) * SIZEY;
    return {'x': x, 'y': y};
};

getXYS = function (n) {
    var x = (n % NUM) * imageW,
        y = Math.floor(n / NUM) * imageH;
    return {'x': x, 'y': y};
};

getN = function (x, y) {
    return Math.floor(y / SIZEY) * NUM + Math.floor(x / SIZEX);
};

isInt = function (value) {
    return ((parseFloat(value) === parseInt(value, 10)) && !isNaN(value));
};

scoreCallback = function () {
    return {
        'hours': setScore[0],
        'minutes': setScore[1],
        'seconds': setScore[2],
        'moves': setScore[3]
    };
};

isWon = function () {
    if (cWon === true) {
        getScore = scoreCallback();
        return true;
    }
    return false;
};

scores = function () {
    if (customGame) {
        return;
    }
    setScore = [];
    setScore[0] = hours;
    setScore[1] = minutes;
    setScore[2] = seconds;
    setScore[3] = moves;
    var highMoves = localStorage.getItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_moves'),
        highTime = localStorage.getItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_time'),
        timeSum = (hours * 60 * 60) + (minutes * 60) + seconds,
        highHour,
        highMin,
        highSec,
        highTimeSum;

    if (highTime) {
        highHour = highTime.split(':')[0];
        highMin = highTime.split(':')[1];
        highSec = highTime.split(':')[2];
        highTimeSum = (highHour * 60 * 60) + (highMin * 60) + highSec;
    }

    if (highMoves) {
        return;
    }

    if (gamemode === 'classic' && highMoves > moves) {
        localStorage.setItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_moves', moves);
        localStorage.setItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_time', hours + ':' + minutes + ':' + seconds);
        newHigh = true;
    } else if (gamemode === 'classic' && highMoves === moves && highTimeSum > timeSum) {
        localStorage.setItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_moves', moves);
        localStorage.setItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_time', hours + ':' + minutes + ':' + seconds);
        newHigh = true;
    } else if (gamemode === 'challenge' && highTimeSum < timeSum) {
        localStorage.setItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_moves', moves);
        localStorage.setItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_time', hours + ':' + minutes + ':' + seconds);
        newHigh = true;
    } else if (gamemode === 'challenge' && highTimeSum === timeSum && highMoves > moves) {
        localStorage.setItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_moves', moves);
        localStorage.setItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_time', hours + ':' + minutes + ':' + seconds);
        newHigh = true;
    } else if (gamemode === 'fun' && highMoves > moves) {
        localStorage.setItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_moves', moves);
        localStorage.setItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_time', hours + ':' + minutes + ':' + seconds);
        newHigh = true;
    } else if (gamemode === 'fun' && highMoves === moves && highTimeSum > timeSum) {
        localStorage.setItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_moves', moves);
        localStorage.setItem(packN + '_' + selectedImage + '_' + NUM + '_' + gamemode + '_time', hours + ':' + minutes + ':' + seconds);
        newHigh = true;
    }
};

neighbors = function (src, dst) {
    var toLeft,
        toRight,
        s,
        d;

    if (swapHint) {
        return true;
    }

    if (swipe) {
        //egymás alatt
        if ((dst - src) % NUM === 0) {
            fakeNeighS = src;
            if (src < dst) {
                fakeNeighD = src + NUM;
            } else {
                fakeNeighD = src - NUM;
            }
            return true;
        }
        //egymás mellett
        toLeft = src % NUM;
        toRight = NUM - (toLeft + 1);

        if (src > dst) {
            if (src - dst <= toLeft) {
                fakeNeighS = src;
                fakeNeighD = src - 1;
            }
        } else {
            if (dst - src <= toRight) {
                fakeNeighS = src;
                fakeNeighD = src + 1;
            }
        }
        return true;
    }

    s = Math.min(src, dst);
    d = Math.max(src, dst);

    // egymás alatt vannak
    if (s + NUM === d) {
        return true;
    }
    // egymás mellett vannak, de nem új sorban
    return ((s % NUM + 1 === d % NUM) && (d - s !== NUM + 1) && (d - s < 6));
};

isEnd = function () {
    var i;
    for (i = 0; i < place.length; i++) {
        if (place[i] !== i) {
            return false;
        }
    }
    return true;
};

drawHint = function () {
    var edge,
        i;

    for (i = 0; i < place.length; i++) {
        if (i < NUM) { //felső
            edge = place.indexOf(i);
            ctx.fillStyle = '#ffff00';
            ctx.fillRect(getXYD(edge).x, getXYD(edge).y, SIZEX, SIZEY * 0.05);
        }
        if ((i + 1) % NUM === 0) { //jobb
            edge = place.indexOf(i);
            ctx.fillStyle = '#00ff00';
            ctx.fillRect(getXYD(edge).x + SIZEX * 0.95, getXYD(edge).y, SIZEX * 0.05, SIZEY);
        }
        if ((i % NUM) === 0) { //bal
            edge = place.indexOf(i);
            ctx.fillStyle = '#0000ff';
            ctx.fillRect(getXYD(edge).x, getXYD(edge).y, SIZEX * 0.05, SIZEY);
        }
        if ((NUM * (NUM - 1)) < i + 1) { //alsó
            edge = place.indexOf(i);
            ctx.fillStyle = '#ff0000';
            ctx.fillRect(getXYD(edge).x, getXYD(edge).y + SIZEY * 0.95, SIZEX, SIZEY * 0.05);
        }
    }
};

repaint2 = function () {
    var object0 = new Menu(),
        i;

    for (i = 0; i < place.length; i++) {
        object0.add(new MyImageItem(i, kep, getXYS(place[i]).x, getXYS(place[i]).y, imageW, imageH, getXYD(i).x, getXYD(i).y, SIZEX, SIZEY));
    }
    object0.draw();

    if (hint === true) {
        drawHint();
    }

    if (grid === true && !videopuzzle) {
        imageStroke = new MyGridItem('grid', 0, 0, scaledW, HEIGHT, NUM, NUM);
        imageStroke.draw();
    }
};

repaint = function () {
    var object,
        timerDraw,
        i;

    if (animation === false || alertM === true) {
        ctx.clearRect(0, 0, scaledW, HEIGHT);
        object = new Menu();

        for (i = 0; i < place.length; i++) {
            object.add(new MyImageItem(i, kep, getXYS(place[i]).x, getXYS(place[i]).y, imageW, imageH, getXYD(i).x, getXYD(i).y, SIZEX, SIZEY));
        }
        object.draw();

        if (hint === true) {
            drawHint();
        }

        if (grid === true && !videopuzzle) {
            imageStroke = new MyGridItem('grid', 0, 0, scaledW, HEIGHT, NUM, NUM);
            imageStroke.draw();
        }
        showfullIcon = imageOff;
    }

    object = new Menu();
    if (!Config.simpleMode) {
        ctx.clearRect(WIDTH - WIDTH * 0.15, HEIGHT * 0.07, WIDTH * 0.15, HEIGHT * 0.08);
        object.add(new MyTextItem('movesn', moves, WIDTH - 10, HEIGHT * 0.1, HEIGHT * 0.05, 0, 'right'));
        object.draw();
    }
    // animation >
    if (animation === true) {
        if (destinationImage) {
            sourceRect.draw();
            destinationRect.draw();
            destinationImage.draw();
        }
        if (sourceImage) {
            sourceImage.draw();
        }
    }
    // <
    if (mode === 'classic') {
        animIcon = animoldicon;
    }

    if (isEnd() && !videopuzzle) {
        ctx.drawImage(kep, 0, 0, scaledW, HEIGHT);
    }
    if (!Config.simpleMode) {
        if (!timerStarted) {
            timerDraw = new MyTextItem('timer', minutes + ':' + seconds, WIDTH - 10, HEIGHT * 0.04, HEIGHT * 0.05, 0, 'right');
            timerDraw.draw();
        }
    }
};

function buttonRepaint() {
    if (!Config.simpleMode) {
        inGameButtons = new Menu();

        inGameButtons.add(new ImageMenuItem('hint', 'images/hint_' + hintIcon + '.png', WIDTH - BSIZE * 1.2, HEIGHT * 0.20 - BSIZE / 2, BSIZE, BSIZE, 0));
        inGameButtons.add(new ImageMenuItem('timer', '', WIDTH * 0.9, 0, WIDTH * 0.1, HEIGHT * 0.1, 0));
        if (mode === 'classic') {
            inGameButtons.add(new ImageMenuItem('swap', 'images/swap_' + swapIcon + '.png', WIDTH - BSIZE * 1.2, HEIGHT * 0.35 - BSIZE / 2, BSIZE, BSIZE, 0, 0, swaps));
        } else {
            inGameButtons.add(new ImageMenuItem('swap', 'images/swap_' + swapIcon + '.png', WIDTH - BSIZE * 1.2, HEIGHT * 0.35 - BSIZE / 2, BSIZE, BSIZE, 0));
        }
        inGameButtons.add(new ImageMenuItem('showfull', 'images/full_' + showfullIcon + '.png', WIDTH - BSIZE * 1.2, HEIGHT * 0.50 - BSIZE / 2, BSIZE, BSIZE, 0));
        inGameButtons.add(new ImageMenuItem('grid', 'images/grid_' + gridIcon + '.png', WIDTH - BSIZE * 1.2, HEIGHT * 0.65 - BSIZE / 2, BSIZE, BSIZE, 0));
        if (parseInt(Config.quickMode, 10) === 0) {
            inGameButtons.add(new ImageMenuItem('back', 'images/back_' + imageOn + '.png', WIDTH - BSIZE * 1.2, HEIGHT - BSIZE * 1.2, BSIZE, BSIZE, 0));
        }
        if (parseInt(Config.quickMode, 10) !== 0 && Config.nextButton) {
            inGameButtons.add(new ImageMenuItem('nextimg', 'images/nextimg_' + imageOn + '.png', WIDTH - BSIZE * 1.2, HEIGHT - BSIZE * 1.2, BSIZE, BSIZE, 0));
        }
        inGameButtons.draw();
    }
}

startPuzzle = function (mode) {
    var object,
        i;
    cWon = false;
    newHigh = false;

    if (parseInt(Config.quickMode, 10) !== 0) {
        if (videopuzzle) {
            video.addEventListener("canplay", function () {
                animation = false;
                $('#video').get(0).play();
            });
        }
    } else {
        if (videopuzzle) {
            animation = false;
            $('#video').get(0).play();
        }
    }
    startPuzzle.mode = mode;
    if (mode === 'challenge') {
        gamemode = 'challenge';
        if (NUM === 2) {
            msecs = 100;
            seconds = 2;
            minutes = 0;
        }
        if (NUM === 3) {
            msecs = 100;
            seconds = 15;
            minutes = 0;
        }
        if (NUM === 4) {
            msecs = 100;
            seconds = 35;
            minutes = 0;
        }
        if (NUM === 5) {
            msecs = 100;
            seconds = 20;
            minutes = 1;
        }
        if (NUM === 6) {
            msecs = 100;
            seconds = 40;
            minutes = 2;
        }
        if (NUM === 7) {
            msecs = 100;
            seconds = 40;
            minutes = 4;
        }
        if (NUM === 8) {
            msecs = 100;
            seconds = 30;
            minutes = 7;
        }
        if (NUM === 9) {
            msecs = 100;
            seconds = 30;
            minutes = 9;
        }
    }
    if (mode === 'classic') {
        gamemode = 'classic';
        swaps = NUM - 2;
    }
    if (mode === 'fun') {
        gamemode = 'fun';
        swaps = 1;
    }
    maxW = WIDTH * 0.8;
    if (Config.simpleMode) {
        maxW = WIDTH;
    }
    animoldicon = animIcon;
    animold = animation;
    moves = 0;
    ctx.clearRect(0, 0, WIDTH, HEIGHT);
    destinationImage = null;
    sourceImage = null;

    // feltöltés
    src = -1;
    dst = -1;
    place = [];

    for (i = 0; i < NUM * NUM; i++) {
        place[i] = i;
    }

    keveres();

    if (parseInt(Config.quickMode, 10) !== 0) {
        if (videopuzzle) {
            video.addEventListener("canplay", function () {
                imageW = video.videoWidth / NUM;
                imageH = video.videoHeight / NUM;
                kepW = Math.max(video.videoWidth, video.videoHeight);
                kepH = Math.min(video.videoWidth, video.videoHeight);
                ratio = kepW / kepH;
                scaledW = HEIGHT * ratio;

                if (Config.simpleMode) {
                    scaledW = maxW;
                }
                if (maxW < scaledW) {
                    scaledW = maxW;
                }

                SIZEX = scaledW / NUM;
                SIZEY = HEIGHT / NUM;
            });
        }
        if (!videopuzzle) {
            kep.onload = function () {
                imageW = kep.width / NUM;
                imageH = kep.height / NUM;
                kepW = Math.max(kep.width, kep.height);
                kepH = Math.min(kep.width, kep.height);
                ratio = kepW / kepH;
                scaledW = HEIGHT * ratio;

                if (Config.simpleMode) {
                    scaledW = maxW;
                }
                if (maxW < scaledW) {
                    scaledW = maxW;
                }

                SIZEX = scaledW / NUM;
                SIZEY = HEIGHT / NUM;

                if (animation === true) {
                    object = new Menu();
                    for (i = 0; i < NUM * NUM; i++) {
                        object.add(new MyImageItem(i, kep, getXYS(place[i]).x, getXYS(place[i]).y, imageW, imageH, getXYD(i).x, getXYD(i).y, SIZEX, SIZEY));
                    }
                    object.draw();

                    if (hint === true) {
                        drawHint();
                    }

                    if (grid === true && !videopuzzle) {
                        imageStroke = new MyGridItem('grid', 0, 0, scaledW, HEIGHT, NUM, NUM);
                        imageStroke.draw();
                    }
                }
            };
        }
    } else {
        if (videopuzzle) {
            imageW = video.videoWidth / NUM;
            imageH = video.videoHeight / NUM;
            kepW = Math.max(video.videoWidth, video.videoHeight);
            kepH = Math.min(video.videoWidth, video.videoHeight);
        }
        if (!videopuzzle) {
            imageW = kep.width / NUM;
            imageH = kep.height / NUM;
            kepW = Math.max(kep.width, kep.height);
            kepH = Math.min(kep.width, kep.height);
        }
        ratio = kepW / kepH;
        scaledW = HEIGHT * ratio;

        if (Config.simpleMode) {
            scaledW = maxW;
        }
        if (maxW < scaledW) {
            scaledW = maxW;
        }

        SIZEX = scaledW / NUM;
        SIZEY = HEIGHT / NUM;

        if (animation === true) {
            object = new Menu();
            for (i = 0; i < NUM * NUM; i++) {
                object.add(new MyImageItem(i, kep, getXYS(place[i]).x, getXYS(place[i]).y, imageW, imageH, getXYD(i).x, getXYD(i).y, SIZEX, SIZEY));
            }
            object.draw();

            if (hint === true) {
                drawHint();
            }

            if (grid === true && !videopuzzle) {
                imageStroke = new MyGridItem('grid', 0, 0, scaledW, HEIGHT, NUM, NUM);
                imageStroke.draw();
            }
        }
    }

    if (parseInt(Config.quickMode, 10) !== 0) {
        if (videopuzzle) {
            video.addEventListener("canplay", function () {
                repaint();
                buttonRepaint();
            });
        } else {
            repaint();
            buttonRepaint();
        }
    } else {
        if (videopuzzle) {
            repaint();
            buttonRepaint();
        } else {
            repaint();
            buttonRepaint();
        }
    }
    $canvas.unbind('click');
    $canvas.bind('click', function (event) {
        if (activePage !== 'game' || clickCheck(event)) {
            return;
        }
    });
};

setNUM = function (s) {
    NUM = parseInt(s, 10);
};

selectImage = function (img) {
    if (videopuzzle) {
        $('video').get(0).pause();
        $('#videosrc').attr('src', img);
        $('video').get(0).load();
    } else {
        kep.src = img;
    }
};



versionCheck = function () {
    if (available_version) {
        var vMajor = version.split('.')[0],
            vMinor = version.split('.')[1],
            vPatch = version.split('.')[2],
            vSum = 100 * vMajor + 10 * vMinor + vPatch,
            vAvailableMajor = available_version.split('.')[0],
            vAvailableMinor = available_version.split('.')[1],
            vAvailablePatch = available_version.split('.')[2],
            vAvailableSum = 100 * vAvailableMajor + 10 * vAvailableMinor + vAvailablePatch;
        if (parseInt(vAvailableSum, 10) > parseInt(vSum, 10)) {
            alert('New version available!\n\nAvailable Version: ' + available_version + '\nYour Version: ' + version + '\nDownload new version from: CodeCanyon.net');
        }
    }
};

loadAll = function (id) {
    var lingrad = ctx.createLinearGradient(0, HEIGHT * 0.45, 0, HEIGHT * 0.55),
        i;

    loadAll.onloadImg = function () {
        loadingL += (WIDTH * 0.8) / imagecount;
        loadingP += 1;
        ctx.clearRect(0, 0, WIDTH, HEIGHT);
        ctx.fillRect(WIDTH * 0.1, HEIGHT * 0.45, loadingL, HEIGHT * 0.1);
        ctx.strokeRect(WIDTH * 0.1, HEIGHT * 0.45, WIDTH * 0.8, HEIGHT * 0.1);
        ctx.fillStyle = 'rgba(' + Config.foreGround + ',1)';
        ctx.fillText(LANG_LOADING, WIDTH / 2, HEIGHT / 2);
        ctx.fillStyle = lingrad;
        if (loadingP === imagecount) {
            mainPage.firstLoad();
        }
    };

    if (!LANG_LOADING) {
        ctx.fillStyle = '#fff';
        ctx.font = 'bold ' + canvas.width * 0.04 + 'px sans-serif';
        ctx.textBaseline = 'bottom';
        ctx.fillText('Error: language file not found!', 50, 100);
        return;
    }

    if (window['Pack' + id] !== undefined) {
        imagecount = window['Pack' + id].size;
    }

    $('#ctnest').css('background', 'rgba(' + Config.backGround + ',1)');
    if (videopuzzle) {
        mainPage.draw();
        return;
    }

    ctx.strokeStyle = 'rgba(' + Config.foreGround + ',1)';

    lingrad.addColorStop(0, 'rgba(' + Config.color + ',1)');
    lingrad.addColorStop(1, 'rgba(' + Config.color2 + ',1)');
    ctx.fillStyle = lingrad;
    ctx.font      = "normal 36px sans-serif";
    ctx.textBaseline = "middle";
    ctx.textAlign = "center";
    ctx.strokeRect(WIDTH * 0.1, HEIGHT * 0.45, WIDTH * 0.8, HEIGHT * 0.1);
    ctx.fillStyle = 'rgba(' + Config.foreGround + ',1)';
    ctx.fillText(LANG_LOADING, WIDTH / 2, HEIGHT / 2);
    ctx.fillStyle = lingrad;

    for (i = 1; i <= imagecount; i++) {
        window['img' + i] = new Image();
        window['img' + i].src = 'images/pack' + packN + '/pack' + packN + '_' + i + '.jpg';

        window['img' + i].onload = loadAll.onloadImg();
    }
    loadingP = 0;
    loadingL = 0;
};

loading = function (id) {
    if ($('#pack' + packN).length === 0) {
        loadjs("images/pack" + packN + "/conf.js", 'pack' + packN);
    } else {
        loadAll(id);
    }

    $('#pack' + packN).load(function(){
        loadAll(id);
    });
};

handleFileSelect = function (evt) {
    var files = evt.target.files,
        f = files[0],
        reader;

    if (!f.type.match('image.*') && !f.name.match('\.ogg') && !f.name.match('\.mp4')) {
        return;
    }

    reader = new FileReader();

    reader.onload = (function (theFile) {
        return function (e) {
            customGame = true;
            localStorage.setItem('myimg', e.target.result); // localStorage.myimg

            if (f.name.match('\.ogg')) {
                videopuzzle = true;
                $('video').get(0).pause();
                $('#videosrc').attr('src', localStorage.myimg);
                $('video').get(0).load();
                video = document.getElementById('video');
                mainPage.draw();
            } else if (f.name.match('\.mp4')) {
                videopuzzle = true;
                $('video').get(0).pause();
                $('#videosrc').attr('src', localStorage.myimg);
                $('#videosrc').attr('type', 'video/mp4');
                $('video').get(0).load();
                video = document.getElementById('video');
                mainPage.draw();
            } else {
                videopuzzle = false;
                $('#video').get(0).pause();
            }

            kep.src = localStorage.myimg;
            mainPage.draw();
        };
    })(f);
    reader.readAsDataURL(f);
};

myDelay = function (ms) {
    if (delay === 2) {
        clearTimeout(myD);
        object_delayed.draw();
        delay = 0;
        return;
    }
    delay += 1;
    myD = setTimeout('myDelay()',ms);
};

myTimer = function (param) {
    if (param === 'pause') {
        clearTimeout(myT);
        timerStarted = false;
    }
    if (mode !== 'challenge') {
        if (msecs === 100) {
            seconds += 1;
            msecs = 0;
        }
        if (seconds === 60) {
            minutes += 1;
            seconds = 0;
        }
        if (minutes === 60) {
            hours += 1;
            minutes = 0;
        }
        if (param === 'stop') {
            timerStarted = false;
            msecs = 0;
            seconds = 0;
            minutes = 0;
            hours = 0;
            clearTimeout(myT);
            return;
        }
        if (param === 'start') {
            timerStarted = true;
            msecs += 10;
            myT = setTimeout('myTimer("start")', 100);
        }
    }
    if (mode === 'challenge') {
        if (param === 'stop') {
            timerStarted = false;
            msecs = 0;
            seconds = 0;
            minutes = 0;
            hours = 0;
            clearTimeout(myT);
            return;
        }
        if (minutes === 0 && seconds === 0 && msecs === 0) {
            clearTimeout(myT);
            lostPage.draw();
            lost = true;
            return;
        }
        if (msecs === -10) {
            seconds -= 1;
            msecs = 100;
        }
        if (seconds === -1) {
            minutes -= 1;
            seconds = 59;
        }
        if (param === 'start') {
            timerStarted = true;
            msecs -= 10;
            myT = setTimeout('myTimer("start")', 100);
        }
    }
    if (!Config.simpleMode) {
        ctx.clearRect(WIDTH - WIDTH * 0.15, 0, WIDTH * 0.15, HEIGHT * 0.065);
        var timerDraw = new MyTextItem('timer', minutes + ':' + seconds, WIDTH - 10, HEIGHT * 0.04, HEIGHT * 0.05, 0, 'right');
        timerDraw.draw();
    }
};

getMousePos = function (canvas, event) {
    // get canvas position
    var obj = canvas,
        top = 0,
        left = 0,
        mouseX,
        mouseY;

    while (obj && obj.tagName !== 'BODY') {
        top += obj.offsetTop;
        left += obj.offsetLeft;
        obj = obj.offsetParent;
    }

    // return relative mouse position
    mouseX = event.clientX - left + window.pageXOffset;
    mouseY = event.clientY - top + window.pageYOffset;
    return {
        x: mouseX,
        y: mouseY
    };
};

move = function (obj, xd1, yd1, xd2, yd2, t) {
    var dx = (xd2 - xd1) * (40 / t),
        dy = (yd2 - yd1) * (40 / t),
        timer;

    obj.xd = xd1;
    obj.yd = yd1;

    timer = setInterval(function () {
        if (t > 0) {
            obj.xd += dx;
            obj.yd += dy;
            if (!lost) {
                repaint();
            }
        }
        t -= 40;

        if (t <= -80) {
            clearInterval(timer);
            obj.xd = xd2;
            obj.yd = yd2;

            if (!lost) {
                repaint();
                repaint2();
            }
            if (isEnd() && !lost) {
                ctx.drawImage(kep, 0, 0, scaledW, canvas.height);
                myTimer('pause');
                if (newHigh) {
                    messagePage.draw(LANG_NEWHIGHSCORE, LANG_SOLVED + ' ' + moves);
                } else {
                    messagePage.draw(LANG_CONGRATS, LANG_SOLVED + ' ' + moves);
                }
/*
                if (Config.simpleMode) {
                    inGameButtons = new Menu();
                    inGameButtons.add(new MenuItem('nextimg', LANG_NEXT, scaledW/2-WIDTH*0.2, HEIGHT*0.05, WIDTH*0.4, HEIGHT*0.13, HEIGHT*0.04, 5));
                    inGameButtons.draw();
                }
*/
                if (!cWon) {
                    cWon = true;
                    scores();
                    winCallback();
                }
                return;
            }
            if (grid && !lost) {
                imageStroke = new MyGridItem('grid', 0, 0, scaledW, canvas.height, NUM, NUM);
                imageStroke.draw();
            }
        }
    }, 40);
};

winCallback = function () {
    if (window[Config.winCallback]) {
        window[Config.winCallback](scoreCallback());
    }
};

clickCheck = function (event) {
    var name,
        object,
        i;

    if (inGameButtons !== undefined) {
        if (inGameButtons.getItem(event)) {
            name = inGameButtons.getItem(event).name;

            if (inGameButtons.getItem(event).name === name) {
                if (name === 'back') {
                    $('video').get(0).pause();
                    hint = false;
                    hintIcon = imageOff;
                    swapHint = false;
                    swapIcon = imageOff;
                    lost = false;
                    myTimer('stop');
                    mainPage.draw();
                    animation = true;
                    swaps = 1;

                    for (i = 0; i < NUM * NUM; i++) {
                        clearTimeout(window['videoloop' + i]);
                    }
                }
                if (name === 'nextimg') {
                    $('video').get(0).pause();
                    hint = false;
                    hintIcon = imageOff;
                    swapHint = false;
                    swapIcon = imageOff;
                    lost = false;
                    myTimer('stop');
                    animation = true;
                    swaps = 1;

                    for (i = 0; i < NUM * NUM; i++){
                        clearTimeout(window['videoloop'+i]);
                    }

                    firstImage('nextimg');
                    return;
                }
                if (isEnd() || lost) {
                    return;
                }
                if (name === 'timer') {
                    if (timerStarted) {
                        myTimer('pause');
                        messagePage.draw(LANG_PAUSED, LANG_T_CONTINUE);
                    }
                }
                if (name === 'animation') {
                    if (!animation) {
                        animation = true;
                        animIcon = imageOn;
                        animold = true;
                        animoldicon = imageOn;
                        swapHint = false;
                        swapIcon = imageOff;
                        buttonRepaint();
                    } else {
                        animation = false;
                        animIcon = imageOff;
                        animold = false;
                        animoldicon = imageOff;
                        buttonRepaint();
                    }
                }
                if (name === 'grid') {
                    if (!grid) {
                        grid = true;
                        gridIcon = imageOn;
                        buttonRepaint();
                        repaint2();
                    } else {
                        grid = false;
                        gridIcon = imageOff;
                        buttonRepaint();
                        repaint2();
                    }
                }
                if (name === 'hint') {
                    if (!hint) {
                        if (mode === 'challenge' && seconds < hintTimePenalty && minutes === 0) {
                            return;
                        }
                        if (mode === 'challenge') {
                            if (!timerStarted) {
                                return;
                            }
                        }
                        hint = true;
                        hintIcon = imageOn;
                        if (mode === "classic") {
                            moves += hintMovePenalty;
                            object = new Menu();
                            ctx.clearRect(WIDTH - WIDTH * 0.15, HEIGHT * 0.07, WIDTH * 0.15, HEIGHT * 0.08);
                            object.add(new MyTextItem('movesp', '+' + hintMovePenalty, WIDTH - 10, HEIGHT * 0.1, HEIGHT * 0.05, 0 , 'right'));
                            object.draw();
                        }
                        if (mode == "challenge") {
                            ctx.clearRect(WIDTH-WIDTH*0.15, 0, WIDTH*0.15, HEIGHT*0.065);
                            if (seconds < hintTimePenalty) {
                                var temp = hintTimePenalty - seconds;
                                seconds=60-temp;
                                minutes-=1;
                                return;
                            }
                            seconds-=hintTimePenalty;
                        }
                        buttonRepaint();
                        repaint2();
                    } else {
                        hint = false;
                        hintIcon = imageOff;
                        buttonRepaint();
                        repaint2();
                    }
                }
                if (name == 'swap') {
                    if (mode == 'challenge') {
                        messagePage.draw(LANG_SWAP_NA, LANG_SWAP_NA2);
                        return;
                    }
                    if (swaps > 0) {
                        if (swapHint == false) {
                            swapped = false;
                            swapHint = true;
                            swapIcon = imageOn;
                            animation = false;
                            animIcon = imageOff;
                            buttonRepaint();
                            repaint2();
                        } else {
                            swapped = true;
                            swapHint = false;
                            swapIcon = imageOff;
                            animation = animold;
                            animIcon = animoldicon;
                            buttonRepaint();
                            repaint2();
                        }
                    } else {
                        messagePage.draw(LANG_SWAP_OUT);
                    }
                }
                if (name == 'showfull') {
                    if (mode == 'challenge') {
                        if (!timerStarted) {
                            return;
                        }
                    }

                    fullImagePage.draw();
                    if (mode=="classic") {
                        moves+=fullImageMovePenalty
                        object = new Menu();
                        ctx.clearRect(WIDTH-WIDTH*0.15, HEIGHT*0.07, WIDTH*0.15, HEIGHT*0.08);
                        object.add(new MyTextItem('movesp', '+'+fullImageMovePenalty, WIDTH-10, HEIGHT*0.1, HEIGHT*0.05, 0 ,'right'));
                        object.draw();
                    }
                }
                return true;
            }
        }
    }
}




$canvas.bind('click', function (event) {
    if (activePage !== 'game' || clickCheck(event)) {
        return false;
    }
});

isTouchDevice = function () {
    return document.documentElement.hasOwnProperty('ontouchstart') || document.documentElement.hasOwnProperty('onmsgesturechange');
//	return (('ontouchstart' in window) || (navigator.maxTouchPoints > 0) || (navigator.msMaxTouchPoints > 0));
};

var mobile = isTouchDevice(),
    eventdown = mobile ? "touchstart" : "mousedown",
    eventup = mobile ? "touchend" : "mouseup";

canvas.addEventListener(eventdown, function (event) {
    var check,
        touch,
        object,
        temp,
        i;

    this.getCoords = function () {
        if (mobile) {
            for (i = 0; i < event.touches.length; i++) {
                check = event.touches[i].clientX;
                if (check) {
                    if (canvas.offsetParent !== null) {
                        parentOffsetLeft = canvas.offsetParent.offsetLeft;
                        parentOffsetTop = canvas.offsetParent.offsetTop;
                    }
                    touch = event.touches[i];
                    cx = touch.clientX + document.body.scrollLeft + document.documentElement.scrollLeft - canvas.offsetLeft - parentOffsetLeft;
                    cy = touch.clientY + document.body.scrollTop + document.documentElement.scrollTop - canvas.offsetTop - parentOffsetTop;
                }
            }
        } else {
            if (canvas.offsetParent !== null) {
                parentOffsetLeft = canvas.offsetParent.offsetLeft;
                parentOffsetTop = canvas.offsetParent.offsetTop;
            }
            cx = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft - canvas.offsetLeft - parentOffsetLeft;
            cy = event.clientY + document.body.scrollTop + document.documentElement.scrollTop - canvas.offsetTop - parentOffsetTop;
        }
    };

    if (swipe && !swapHint) {
        if (activePage !== 'game') {
            return;
        }

        this.getCoords();

        if (alertM === 1) {
            repaint();
            buttonRepaint();
            alertM = 0;
            if (!timerStarted && !isEnd()) {
                myTimer('start');
            }
            if (videopuzzle) {
                clearTimeout(videoendloop);
            }
            return false;
        }

        if (lost) {
            return false;
        }

        if (isEnd()) {
            return false;
        }

        //out of image
        if (cx > scaledW) {
            return false;
        }
        // no src piece
        if (src === -1) {
            if (!timerStarted) {
                myTimer("start");
            }
            src = getN(cx, cy);
            ctx.fillStyle = 'rgba(' + Config.color + ', 0.5)';
            ctx.strokeStyle = 'rgba(' + Config.color + ', 0.5)';
            ctx.lineWidth = SIZEX * 0.02;
            if (!videopuzzle) {
                ctx.strokeStyle = 'rgba(' + Config.color + ', 0.5)';
                ctx.fillRect(getXYD(src).x, getXYD(src).y, SIZEX, SIZEY);
            }
            if (mode === 'classic' && swapped) {
                animation = animold;
                swapped = false;
            }
            return false;
        }

        // has src piece
        if (src >= 0) {
            dst = getN(cx, cy);
            // if src = dst, then remove selection
            if (src === dst || src !== dst) {
                repaint();
                if (animation) {
                    object = new Menu();
                    for (i = 0; i < place.length; i++) {
                        object.add(new MyImageItem(i, kep, getXYS(place[i]).x, getXYS(place[i]).y, imageW, imageH, getXYD(i).x, getXYD(i).y, SIZEX, SIZEY));
                    }
                    object.draw();
                    if (hint === true) {
                        drawHint();
                    }
                    if (grid === true && !videopuzzle) {
                        imageStroke = new MyGridItem('grid', 0, 0, scaledW, HEIGHT, NUM, NUM);
                        imageStroke.draw();
                    }
                }
                src = -1;
                dst = -1;
                return false;
            }

            // if neighbors, then swap
            if (neighbors(src, dst)) {
                if (mode === 'classic') {
                    if (swapHint) {
                        swaps -= 1;
                        swapHint = false;
                        swapIcon = imageOff;
                        swapped = true;
                    }
                }
                if (mode !== "fun") {
                    hint = false;
                    hintIcon = imageOff;
                    buttonRepaint();
                }
                // animation >
                if (animation === true) {
                    sourceRect = new MyRectItem('sourcerect', getXYD(src).x, getXYD(src).y, SIZEX, SIZEY, 'rgba(' + Config.backGround + ', 1)');
                    destinationRect = new MyRectItem('destinationrect', getXYD(dst).x, getXYD(dst).y, SIZEX, SIZEY, 'rgba(' + Config.backGround + ', 1)');
                    sourceImage = new MyImageItem('source', kep, getXYS(place[src]).x, getXYS(place[src]).y, imageW, imageH, getXYD(src).x, getXYD(src).y, SIZEX, SIZEY);
                    destinationImage = new MyImageItem('destination', kep, getXYS(place[dst]).x, getXYS(place[dst]).y, imageW, imageH, getXYD(dst).x, getXYD(dst).y, SIZEX, SIZEY);
                    move(sourceImage, getXYD(src).x, getXYD(src).y, getXYD(dst).x, getXYD(dst).y, 160);
                    move(destinationImage, getXYD(dst).x, getXYD(dst).y, getXYD(src).x, getXYD(src).y, 160);
                }
                // <
                temp = place[src];
                place[src] = place[dst];
                place[dst] = temp;
                moves += 1;

                repaint();

                dst = -1;
                src = -1;
                fakeNeighS = -1;
                fakeNeighD = -1;

                if (isEnd() && animation === false && !lost) {
                    if (videopuzzle) {
                        for (i = 0; i < NUM * NUM; i++) {
                            clearTimeout(window['videoloop' + i]);
                        }
                        (function loopend() {
                            if (!video.paused && !video.ended) {
                                ctx.drawImage(video, 0, 0, scaledW, canvas.height);
                                if (newHigh) {
                                    messagePage.draw(LANG_NEWHIGHSCORE, LANG_SOLVED + ' ' + moves);
                                } else {
                                    messagePage.draw(LANG_CONGRATS, LANG_SOLVED + ' ' + moves);
                                }
                                videoendloop = setTimeout(loopend, 1000 / Config.videoFPS);
                            }
                        })();
                    } else {
                        if (newHigh) {
                            messagePage.draw(LANG_NEWHIGHSCORE, LANG_SOLVED + ' ' + moves);
                        } else {
                            messagePage.draw(LANG_CONGRATS, LANG_SOLVED + ' ' + moves);
                        }
                    }
                    myTimer('pause');
                    if (!cWon) {
                        cWon = true;
                        scores();
                        winCallback();
                    }
                }

                return false;
            }

            dst = -1;
            src = -1;
            fakeNeighS = -1;
            fakeNeighD = -1;
            messagePage.draw(LANG_ADJACENT);
        }
        return false;
    } else {
        if (activePage !== 'game') {
            return;
        }
        this.getCoords();

        if (alertM === 1) {
            repaint();
            buttonRepaint();
            alertM = 0;
            if (!timerStarted && !isEnd()) {
                myTimer('start');
            }
            if (isEnd() && videopuzzle) {
                clearTimeout(videoendloop);
            }
            return false;
        }

        if (lost) {
            return false;
        }

        if (isEnd()) {
            return false;
        }

        //képen kívüli rész
        if (cx > scaledW) {
            return false;
        }
        // nincs forrás kiválasztva
        if (src === -1) {
            if (!timerStarted) {
                myTimer("start");
            }
            src = getN(cx, cy);
            ctx.fillStyle = 'rgba(' + Config.color + ',0.5)';
            ctx.strokeStyle = 'rgba(' + Config.color + ',0.5)';
            ctx.lineWidth = SIZEX * 0.02;
            if (!videopuzzle) {
                ctx.fillRect(getXYD(src).x, getXYD(src).y, SIZEX, SIZEY);
            }
            if (mode === 'classic' && swapped) {
                animation = animold;
                swapped = false;
            }
            return false;
        }

        // ha van forrás kiválasztva
        if (src >= 0) {
            dst = getN(cx, cy);
            // ha forrás = cél, akkor kijelölés megszüntetése
            if (src === dst) {
                repaint();
                if (animation) {
                    object = new Menu();
                    for (i = 0; i < place.length; i++) {
                        object.add(new MyImageItem(i, kep, getXYS(place[i]).x, getXYS(place[i]).y, imageW, imageH, getXYD(i).x, getXYD(i).y, SIZEX, SIZEY));
                    }
                    object.draw();
                    if (hint === true) {
                        drawHint();
                    }
                    if (grid === true && !videopuzzle) {
                        imageStroke = new MyGridItem('grid', 0, 0, scaledW, HEIGHT, NUM, NUM);
                        imageStroke.draw();
                    }
                }
                src = -1;
                dst = -1;
                return false;
            }

            // ha szomszédok, akkor csere
            if (neighbors(src, dst)) {
                if (mode === 'classic') {
                    if (swapHint) {
                        swaps -= 1;
                        swapHint = false;
                        swapIcon = imageOff;
                        swapped = true;
                    }
                }
                if (mode !== "fun") {
                    hint = false;
                    hintIcon = imageOff;
                    buttonRepaint();
                }
                // animation >
                if (animation === true) {
                    sourceRect = new MyRectItem('sourcerect', getXYD(src).x, getXYD(src).y, SIZEX, SIZEY, 'rgba(' + Config.backGround + ', 1)');
                    destinationRect = new MyRectItem('destinationrect', getXYD(dst).x, getXYD(dst).y, SIZEX, SIZEY, 'rgba(' + Config.backGround + ', 1)');
                    sourceImage = new MyImageItem('source', kep, getXYS(place[src]).x, getXYS(place[src]).y, imageW, imageH, getXYD(src).x, getXYD(src).y, SIZEX, SIZEY);
                    destinationImage = new MyImageItem('destination', kep, getXYS(place[dst]).x, getXYS(place[dst]).y, imageW, imageH, getXYD(dst).x, getXYD(dst).y, SIZEX, SIZEY);
                    move(sourceImage, getXYD(src).x, getXYD(src).y, getXYD(dst).x, getXYD(dst).y, 160);
                    move(destinationImage, getXYD(dst).x, getXYD(dst).y, getXYD(src).x, getXYD(src).y, 160);
                }
                // <
                temp = place[src];
                place[src] = place[dst];
                place[dst] = temp;
                moves += 1;

                repaint();

                src = -1;
                dst = -1;

                if (isEnd() && animation === false && !lost) {
                    if (videopuzzle) {
                        for (i = 0; i < NUM * NUM; i++) {
                            clearTimeout(window['videoloop' + i]);
                        }
                        (function loopend() {
                            if (!video.paused && !video.ended) {
                                ctx.drawImage(video, 0, 0, scaledW, canvas.height);
                                if (newHigh) {
                                    messagePage.draw(LANG_NEWHIGHSCORE, LANG_SOLVED + ' ' + moves);
                                } else {
                                    messagePage.draw(LANG_CONGRATS, LANG_SOLVED + ' ' + moves);
                                }
                                videoendloop = setTimeout(loopend, 1000 / Config.videoFPS);
                            }
                        })();
                    } else {
                        if (newHigh) {
                            messagePage.draw(LANG_NEWHIGHSCORE, LANG_SOLVED + ' ' + moves);
                        } else {
                            messagePage.draw(LANG_CONGRATS, LANG_SOLVED + ' ' + moves);
                        }
                    }
                    myTimer('pause');
                    if (!cWon) {
                        cWon = true;
                        scores();
                        winCallback();
                    }
                }

                return false;
            }

            dst = -1;
            src = -1;
            messagePage.draw(LANG_ADJACENT);
        }
        return false;
    }
});

canvas.addEventListener('touchmove', function (event) {
    var check,
        touch,
        i;
    event.preventDefault();

    for (i = 0; i < event.touches.length; i++) {
        check = event.touches[i].clientX;
        if (check) {
            if (canvas.offsetParent !== null) {
                parentOffsetLeft = canvas.offsetParent.offsetLeft;
                parentOffsetTop = canvas.offsetParent.offsetTop;
            }
            touch = event.touches[i];
            cx = touch.clientX + document.body.scrollLeft + document.documentElement.scrollLeft - canvas.offsetLeft - parentOffsetLeft;
            cy = touch.clientY + document.body.scrollTop + document.documentElement.scrollTop - canvas.offsetTop - parentOffsetTop;
        }
    }
});

canvas.addEventListener(eventup, function (event) {
    var object,
        temp,
        i;

    if (swipe) {
        if (activePage !== 'game') {
            return;
        }

        if (!mobile) {
            if (canvas.offsetParent !== null) {
                parentOffsetLeft = canvas.offsetParent.offsetLeft;
                parentOffsetTop = canvas.offsetParent.offsetTop;
            }
            cx = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft - canvas.offsetLeft - parentOffsetLeft;
            cy = event.clientY + document.body.scrollTop + document.documentElement.scrollTop - canvas.offsetTop - parentOffsetTop;
        }

        if (swapHint) {
            return;
        }

        if (alertM === 1) {
            return false;
        }

        if (lost) {
            return false;
        }

        if (isEnd()) {
            return false;
        }

        if (cx > scaledW) {
            src = -1;
            dst = -1;
            fakeNeighD = -1;
            repaint();
            repaint2();
            return;
        }

        // nincs forrás kiválasztva
        if (src === -1) {
            return false;
        }

        // ha van forrás kiválasztva
        if (src >= 0) {
            dst = getN(cx, cy);
            // ha forrás = cél, akkor kijelölés megszüntetése
            if (src === dst) {
                repaint();
                if (animation) {
                    object = new Menu();
                    for (i = 0; i < place.length; i++) {
                        object.add(new MyImageItem(i, kep, getXYS(place[i]).x, getXYS(place[i]).y, imageW, imageH, getXYD(i).x, getXYD(i).y, SIZEX, SIZEY));
                    }
                    object.draw();
                    if (hint === true) {
                        drawHint();
                    }
                    if (grid === true && !videopuzzle) {
                        imageStroke = new MyGridItem('grid', 0, 0, scaledW, HEIGHT, NUM, NUM);
                        imageStroke.draw();
                    }
                }
                src = -1;
                dst = -1;
                fakeNeighS = -1;
                fakeNeighD = -1;
                return false;
            }

            // ha szomszédok, akkor csere
            if (neighbors(src, dst)) {
                if (mode === 'classic') {
                    if (swapHint) {
                        swaps -= 1;
                        swapHint = false;
                        swapIcon = imageOff;
                        swapped = true;
                    }
                }
                if (mode !== "fun") {
                    hint = false;
                    hintIcon = imageOff;
                    buttonRepaint();
                }
                // animation >
                if (animation === true) {
                    sourceRect = new MyRectItem('sourcerect', getXYD(fakeNeighS).x, getXYD(fakeNeighS).y, SIZEX, SIZEY, 'rgba(' + Config.backGround + ', 1)');
                    destinationRect = new MyRectItem('destinationrect', getXYD(fakeNeighD).x, getXYD(fakeNeighD).y, SIZEX, SIZEY, 'rgba(' + Config.backGround + ', 1)');
                    sourceImage = new MyImageItem('source', kep, getXYS(place[fakeNeighS]).x, getXYS(place[fakeNeighS]).y, imageW, imageH, getXYD(fakeNeighS).x, getXYD(fakeNeighS).y, SIZEX, SIZEY);
                    destinationImage = new MyImageItem('destination', kep, getXYS(place[fakeNeighD]).x, getXYS(place[fakeNeighD]).y, imageW, imageH, getXYD(fakeNeighD).x, getXYD(fakeNeighD).y, SIZEX, SIZEY);
                    move(sourceImage, getXYD(fakeNeighS).x, getXYD(fakeNeighS).y, getXYD(fakeNeighD).x, getXYD(fakeNeighD).y, 160);
                    move(destinationImage, getXYD(fakeNeighD).x, getXYD(fakeNeighD).y, getXYD(fakeNeighS).x, getXYD(fakeNeighS).y, 160);
                }
                // <
                temp = place[fakeNeighS];
                place[fakeNeighS] = place[fakeNeighD];
                place[fakeNeighD] = temp;
                moves += 1;

                repaint();

                src = -1;
                dst = -1;
                fakeNeighS = -1;
                fakeNeighD = -1;

                if (isEnd() && animation === false) {
                    if (videopuzzle) {
                        for (i = 0; i < NUM * NUM; i++) {
                            clearTimeout(window['videoloop' + i]);
                        }
                        (function loopend() {
                            if (!video.paused && !video.ended) {
                                ctx.drawImage(video, 0, 0, scaledW, canvas.height);
                                if (newHigh) {
                                    messagePage.draw(LANG_NEWHIGHSCORE, LANG_SOLVED + ' ' + moves);
                                } else {
                                    messagePage.draw(LANG_CONGRATS, LANG_SOLVED + ' ' + moves);
                                }
                                videoendloop = setTimeout(loopend, 1000 / Config.videoFPS);
                            }
                        })();
                    } else {
                        if (newHigh) {
                            messagePage.draw(LANG_NEWHIGHSCORE, LANG_SOLVED + ' ' + moves);
                        } else {
                            messagePage.draw(LANG_CONGRATS, LANG_SOLVED + ' ' + moves);
                        }
                    }
                    myTimer('pause');
                    if (!cWon) {
                        cWon = true;
                        scores();
                        winCallback();
                    }
                }
                return false;
            }

            dst = -1;
            src = -1;
            fakeNeighD = -1;
            fakeNeighS = -1;
            messagePage.draw(LANG_ADJACENT);
        }
        return false;
    }
});

window.onresize = function() {
    var maxW,
        i;

    if (Config.fullScreen) {
        if (videopuzzle) {
            clearTimeout(videoendloop);
        }
        WIDTH = $(window).width();
        HEIGHT = $(window).height();
        $ctnest.css('width', WIDTH);
        $ctnest.css('height', HEIGHT);
        $canvas.attr('width', WIDTH);
        $canvas.attr('height', HEIGHT);
        PORTRAIT = (WIDTH < HEIGHT);

        maxW = WIDTH * 0.8;
        if (PORTRAIT) {
            maxW = WIDTH;
        }
        if (Config.simpleMode) {
            maxW = WIDTH;
        }
        BSIZE = HEIGHT * 0.1;
        if (BSIZE > 48) {
            BSIZE = 48;
        }

        if (videopuzzle) {
            imageW = video.videoWidth / NUM;
            imageH = video.videoHeight / NUM;
            kepW = Math.max(video.videoWidth, video.videoHeight);
            kepH = Math.min(video.videoWidth, video.videoHeight);
        } else {
            imageW = kep.width / NUM;
            imageH = kep.height / NUM;
            kepW = Math.max(kep.width, kep.height);
            kepH = Math.min(kep.width, kep.height);
        }
        ratio = kepW / kepH;

        scaledW = HEIGHT * ratio;
        if (maxW < scaledW) {
            scaledW = maxW;
        }
        if (Config.simpleMode) {
            scaledW = maxW;
        }
        SIZEX = scaledW / NUM;
        SIZEY = HEIGHT / NUM;

				//Bound Round change, allow portrait for full screen phone
        if (0/*PORTRAIT*/) {
            ctx.clearRect(0, 0, WIDTH, HEIGHT);
            messagePage.draw(LANG_WINDOW_SMALL);
            if (videopuzzle) {
                for (i = 0; i < NUM * NUM; i++) {
                    clearTimeout(window['videoloop' + i]);
                }
                clearTimeout(videoendloop);
            }
            return;
        }

        if (activePage === 'main') {
            mainPage.draw();
            return;
        }
        if (activePage === 'selected') {
            imageSelectedPage.draw();
            return;
        }
        if (activePage === 'image') {
            imagePage.draw();
            return;
        }
        if (activePage === 'pack') {
            packPage.draw();
            return;
        }
        if (activePage === 'size') {
            sizePage.draw();
            return;
        }
        if (activePage === 'info') {
            infoPage.draw();
            return;
        }
        if (activePage === 'newgame') {
            newGamePage.draw();
            return;
        }
        if (activePage === 'game') {
            if (animation === true) {
                animation = false;
                animv = true;
            }
            repaint();
            repaint2();
            buttonRepaint();
            if (animv === true) {
                animation = true;
                animv = false;
            }
        }
    }
};

langLoad = function (filename, status) {
    if (status === 'ok') {
        showMain();
    }
    if (status === 'error') {
        console.log('Note: Language file "' + filename + '" is not found! The default language is loaded!');
        showMain();
    }
};

//Bound Round Environment Startup Code
var imagePath;
var puzzleSize;

function initPuzzle(image, size) {
	imagePath = image;
	puzzleSize = size;
	loadjs("config.js", 'config', confLoad);
}

confLoad = function (filename, status) {
    if (status === 'ok') {
        loadjs("lang/"+language+".js", 'lang',langLoad);

        $('body').append('<input class="filebrowse" type="file" id="myimage" name="myimage">');
        $('.filebrowse').hide();

        if (Config.versionCheck) {
            loadjs("http://darktl.com/puzzle/version.js", 'version');
        }
        if (Config.fullScreen) {
            WIDTH = $(window).width();
            HEIGHT = $(window).height();
            $ctnest.css('width', WIDTH);
            $ctnest.css('height', HEIGHT);
            $canvas.attr('width', WIDTH);
            $canvas.attr('height', HEIGHT);

            $ctnest.css({
                position : 'fixed',
                top : '0',
                left : '0'
            });

            $canvas.css({
                position : 'fixed',
                top : '0',
                left : '0'
            });
        } else {
            WIDTH = $canvas.width();
            HEIGHT = $canvas.height();
            $ctnest.css('width', WIDTH);
            $ctnest.css('height', HEIGHT);
        }

        PORTRAIT = (WIDTH < HEIGHT);

        maxW = WIDTH*0.8;
        BSIZE = HEIGHT*0.1;
        if (BSIZE > 48) {
            BSIZE = 48;
        }
        hintMovePenalty = Config.hintMovePenalty;
        hintTimePenalty = Config.hintTimePenalty;
        fullImageMovePenalty = Config.fullImageMovePenalty;
        fullImageTimePenalty = Config.fullImageTimePenalty;
				//Bound Round Environment
				//        NUM = Config.defaultPuzzleSize;
//        NUM = Config.defaultPuzzleSize;
        NUM = puzzleSize;
        if (NUM < 2) {
            NUM = 2;
        }
        if (NUM > 20) {
            NUM = 20;
        }
        if (Config.gestureStyle === 'tap') {
            swipe = false;
            switchIcon = 'r';
        } else {
            swipe = true;
            switchIcon = 'l';
        }
        imagepackN = Config.packNum;
        confLoaded = true;

        $('#ctnest').css('background', 'rgba(' + Config.backGround + ',1)');

        if (Config.buttons === 'black') {
            imageOn = 'b';
            imageOff = 'w';
        } else {
            imageOn = 'w';
            imageOff = 'b';
        }

        hintIcon = imageOff;
        animIcon = imageOn;
        gridIcon = imageOn;
        swapIcon = imageOff;
        showfullIcon = imageOff;
        packIcon = imageOn;
        openIcon = imageOn;
        nextIcon = imageOn;
        infoIcon = imageOn;

        if (Config.quickMode && Config.imageForQuickMode !== 'default') {
					//Bound Round Environment
					//            kep.src = Config.imageForQuickMode;
            kep.src = imagePath;
            if (Config.quickMode == "1") {
                startPuzzle('classic');
                activePage = 'game';
                return;
            }
            if (Config.quickMode == "2") {
                startPuzzle('challenge');
                activePage = 'game';
                return;
            }
            if (Config.quickMode == "3") {
                startPuzzle('fun');
                activePage = 'game';
                return;
            }
        } else {
            packN=Config.defaultImagePack;
            firstImage();
        }
    }
    if (status === 'error') {
        console.log('Error: Connfig file "' + filename + '" is not found!');
        ctx.fillStyle = '#fff';
        ctx.font = 'bold ' + canvas.width * 0.07 + 'px sans-serif';
        ctx.textBaseline = 'bottom';
        ctx.fillText('Error: config.js not found!', 50, 100);
    }
};

//Disable default for Bound Round Environment
//loadjs("config.js", 'config', confload);
