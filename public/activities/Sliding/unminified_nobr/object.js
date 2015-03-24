function Menu() {
    this.objectItems = [];

    this.add = function (item) {
        this.objectItems[this.objectItems.length] = item;
    };

    this.draw = function() {
        var i;

        for (i = 0; i < this.objectItems.length; i++) {
            this.objectItems[i].draw();
        }
    };

    this.getItem = function (event) {
        if (canvas.offsetParent !== null) {
            parentOffsetLeft = canvas.offsetParent.offsetLeft;
            parentOffsetTop = canvas.offsetParent.offsetTop;
        }
        var cx = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft - canvas.offsetLeft - parentOffsetLeft,
            cy = event.clientY + document.body.scrollTop + document.documentElement.scrollTop - canvas.offsetTop - parentOffsetTop,
            i;

        for (i = 0; i < this.objectItems.length; i++) {
            if ((this.objectItems[i].x <= cx) && (this.objectItems[i].x + this.objectItems[i].w >= cx) && (this.objectItems[i].y <= cy) && (this.objectItems[i].y + this.objectItems[i].h >= cy)) {
                return this.objectItems[i];
            }
        }
    };
}

function clickCheck (event) {
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
                        clearTimeout(window['videoloop' + i]);
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
                        if (mode === "challenge") {
                            ctx.clearRect(WIDTH - WIDTH * 0.15, 0, WIDTH * 0.15, HEIGHT * 0.065);
                            if (seconds < hintTimePenalty) {
                                var temp = hintTimePenalty - seconds;
                                seconds = 60 - temp;
                                minutes -= 1;
                                return;
                            }
                            seconds -= hintTimePenalty;
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
                if (name === 'swap') {
                    if (mode === 'challenge') {
                        messagePage.draw(LANG_SWAP_NA, LANG_SWAP_NA2);
                        return;
                    }
                    if (swaps > 0) {
                        if (!swapHint) {
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
                if (name === 'showfull') {
                    if (mode === 'challenge') {
                        if (!timerStarted) {
                            return;
                        }
                    }

                    fullImagePage.draw();
                    if (mode === "classic") {
                        moves += fullImageMovePenalty;
                        object = new Menu();
                        ctx.clearRect(WIDTH - WIDTH * 0.15, HEIGHT * 0.07, WIDTH * 0.15, HEIGHT * 0.08);
                        object.add(new MyTextItem('movesp', '+' + fullImageMovePenalty, WIDTH - 10, HEIGHT * 0.1, HEIGHT * 0.05, 0 , 'right'));
                        object.draw();
                    }
                }
                return true;
            }
        }
    }
}

////////////////////////ITEMS/////////////////////////

function MyTextItem (id, text, x, y, ts, shadow, align, opacity) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.ts = ts;
    this.shadow = shadow;
    this.align = align;
    this.opacity = opacity;
    this.text = text;

    this.draw = function() {
        var mySplitResult = text.toString().split("\n"),
            i;

        if (!align) { align = 'center'; }
        ctx.font = 'bold '+ ts +'pt sans-serif';
        ctx.textAlign = align;
        ctx.textBaseline = 'middle';

        if (shadow !== 0 && shadow) {
            ctx.fillStyle = 'rgba(' + Config.color + ',1)';
            for (i = 0; i < mySplitResult.length; i++){
                ctx.fillText(mySplitResult[i], x + shadow, y + shadow);
                y += ts * 2;
            }
        }
        y = this.y;

        if (opacity) {
            ctx.fillStyle = 'rgba(' + Config.foreGround + ',' + opacity + ')';
        } else {
            ctx.fillStyle = 'rgba(' + Config.foreGround + ',1)';
        }
        for (i = 0; i < mySplitResult.length; i++){
            ctx.fillText(mySplitResult[i], x, y);
            y += ts * 2;
        }
        y = this.y;
        if (shadow !== 0 && shadow) {
            ctx.lineWidth = 1;
            ctx.strokeStyle = 'rgba(' + Config.backGround + ',1)';
            for(i = 0; i < mySplitResult.length; i++){
                ctx.strokeText(mySplitResult[i], x, y);
                y += ts * 2;
            }
        }
        y = this.y;
    };
}

function MyGridItem (id, x, y, w, h, nx, ny, color) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.nx = nx;
    this.ny = ny;
    this.color = color;
    if (!color) {
        color = 'rgba(' + Config.backGround + ',1)';
    }
    this.draw = function() {
        var i;

        ctx.lineWidth = 1;
        ctx.strokeStyle = color;
        ctx.strokeRect(x, y, w, h);
        ctx.strokeRect(x+w/nx, y, 0, h);
        for (i = 0; i < nx; i++) {
            ctx.strokeRect(x + ((nx - i) * (w / nx)), y, 0, h);
        }
        for (i = 0; i < ny; i++) {
            ctx.strokeRect(x, y + (ny - i) * (h / ny), w, 0);
        }
    };
}

function MyRectItem(id, x, y, w, h, color1) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.color1 = color1;
    this.draw = function() {
        ctx.fillStyle = color1;
        ctx.fillRect(this.x, this.y, this.w, this.h);
    };
}

function MyStrokeItem(id, x, y, w, h, color1, line) {
    this.id = id;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.color1 = color1;
    this.line = line;
    this.draw = function() {
        ctx.strokeStyle = color1;
        ctx.lineWidth = line;
        ctx.strokeRect(this.x, this.y, this.w, this.h);
    };
}

function MyImageItem(id, image, xs, ys, ws, hs, xd, yd, wd, hd) {
    var videoloop = [];
    var videoendloop;
    this.id = id;
    this.image = image;
    this.xs = xs;
    this.ys = ys;
    this.ws = ws;
    this.hs = hs;
    this.xd = xd;
    this.yd = yd;
    this.wd = wd;
    this.hd = hd;

    this.draw = function() {
        clearTimeout(window['videoloop' + this.id]);
        if (videopuzzle) {
            (function loopvideo() {
                if (!video.paused && !video.ended) {
                    ctx.drawImage(video, xs, ys, ws, hs, xd, yd, wd, hd);
                    if (hint) {
                        drawHint();
                    }
                    ctx.strokeRect(getXYD(src).x + SIZEX * 0.01, getXYD(src).y + SIZEY * 0.012, SIZEX - SIZEX * 0.02, SIZEY - SIZEY * 0.022);
                    window['videoloop' + id] = setTimeout(loopvideo, 1000 / Config.videoFPS); // fps
                }
            })();
        } else {
            ctx.drawImage(this.image, this.xs, this.ys, this.ws, this.hs, this.xd, this.yd, this.wd, this.hd);
        }
    };
}

function VideoMenuItem(name, x, y, w, h, g) {
    this.name = name;
    this.src = src;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.g = g;

    this.draw = function() {
        var grid = new MyGridItem('grid', x, y, w, h, NUM, NUM, 'rgba(' + Config.backGround + ',1)');
        (function loopend() {
            if (!video.paused && !video.ended) {
                ctx.drawImage(video, x, y, w, h);
                if (g === 1) {
                    grid.draw();
                }
                videoendloop = setTimeout(loopend, 1000 / Config.videoFPS); // fps
            }
        })();
    };
}

function ImageMenuItem(name, src, x, y, w, h, lw, grid1, text, d) {
    this.name = name;
    this.src = src;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.lw = lw;
    this.grid1 = grid1;
    this.text = text;
    this.d = d;
    if (!grid1) {
        this.grid1 = 0;
    }

    this.draw = function() {
        var image = new Image();

        image.src = src;
        image.onload = function() {
            ctx.clearRect(x, y, w, h);
            ctx.drawImage(image, x, y, w, h);

            if (text) {
                object3 = new Menu();
                object3.add(new MyTextItem('menutext', text, x + BSIZE / 2, y + BSIZE / 2, HEIGHT * 0.04, 0, 'center', '0.7'));
                object3.draw();
            }
            if (lw !== 0) {
                ctx.lineWidth = lw;
                ctx.strokeStyle = 'rgba(' + Config.foreGround + ',1)';
                ctx.strokeRect(x, y, w, h);
            }
                if (grid1 === 1) {
                var grid = new MyGridItem('grid', x, y, w, h, NUM, NUM, 'rgba(' + Config.backGround + ',1)');
                grid.draw();
            }
            if (d === 1) {
                myDelay(100);
            }
        };
    };
}

function SizeMenuItem(name, x, y, w, h, size) {
    this.name = name;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.size = size;

    this.draw = function() {
        var i;

        ctx.lineWidth = 1;
        ctx.font = 'bold 18pt sans-serif';
        ctx.textBaseline = 'top';
        ctx.textAlign = 'center';
        ctx.fillText(size + ' x ' + size, x + w/2, y + h + 10);
        ctx.fillStyle = 'rgba(' + Config.foreGround + ',1)';
        ctx.fillText(size + ' x ' + size, x + w / 2, y + h + 10);

        ctx.fillStyle = 'rgba(' + Config.color + ',1)';
        ctx.fillRect(x + 2, y + 2, w, h);
        ctx.fillStyle = 'rgba(' + Config.foreGround + ',1)';
        ctx.fillRect(x, y, w, h);

        ctx.strokeStyle = 'rgba(' + Config.color + ',1)';
        ctx.strokeRect(x, y, w, h);
        ctx.strokeRect(x + w / size, y, 0, h);
        for (i = 0; i < size; i++) {
            ctx.strokeRect(x + ((size - i) * (w / size)), y, 0, h);
        }
        for (i = 0; i < size; i++) {
            ctx.strokeRect(x, y + (size - i) * (h / size), w, 0);
        }

    };
}

function MenuItem(name, text, x, y, w, h, font, radius) {
    this.name = name;
    this.text = text;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.font = font;
    this.radius = radius;

    this.draw = function() {
        ctx.lineWidth = 1.5;
        ctx.strokeStyle = 'rgba('+Config.foreGround+',1)';
        ctx.font = 'bold ' + font + 'pt sans-serif';
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';

        var lingrad = ctx.createLinearGradient(0, this.y, 0, this.y+this.h);
        lingrad.addColorStop(0, 'rgba(' + Config.color + ',1)');
        lingrad.addColorStop(1, 'rgba(' + Config.color2 + ',1)');
        ctx.fillStyle = lingrad;

        ctx.beginPath();
        ctx.arc(this.x + radius, this.y + radius, radius, Math.PI, 3 * Math.PI / 2, false);
        ctx.lineTo(this.x + this.w - radius, this.y);
        ctx.arc(this.x + this.w - radius, this.y + radius, radius, 3 * Math.PI / 2, 0, false);
        ctx.lineTo(this.x + this.w, this.y + this.h - radius - radius);
        ctx.arc(this.x + this.w - radius, this.y + this.h - radius, radius, 0, Math.PI/2, false);
        ctx.lineTo(this.x + radius, this.y + this.h);
        ctx.arc(this.x + radius, this.y + this.h - radius, radius, Math.PI / 2, Math.PI, false);
        ctx.lineTo(this.x, this.y + radius);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();

        ctx.lineWidth = 1;

        ctx.fillStyle = 'rgba(' + Config.foreGround + ',1)';
        ctx.fillText(this.text.toUpperCase(), this.x + this.w / 2, this.y + this.h / 2);
    };
}

function MenuItemHover(name, x, y, w, h, radius) {
    this.name = name;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    this.draw = function() {
        ctx.lineWidth = 1;
        ctx.fillStyle = 'rgba(' + Config.foreGround + ',0.3)';
        ctx.strokeStyle = 'rgba(' + Config.backGround + ',1)';

        ctx.beginPath();
        ctx.arc(this.x + radius, this.y + radius, radius, Math.PI, 3 * Math.PI / 2, false);
        ctx.lineTo(this.x + this.w - radius, this.y);
        ctx.arc(this.x + this.w - radius, this.y + radius, radius, 3 * Math.PI / 2, 0, false);
        ctx.lineTo(this.x + this.w, this.y + this.h - radius - radius);
        ctx.arc(this.x + this.w - radius, this.y + this.h - radius, radius, 0, Math.PI / 2, false);
        ctx.lineTo(this.x + radius, this.y + this.h);
        ctx.arc(this.x + radius, this.y + this.h - radius, radius, Math.PI / 2, Math.PI, false);
        ctx.lineTo(this.x, this.y + radius);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();
    };
}

////////////////////////PAGES/////////////////////////

function LostPage() {
    var object;
    this.draw = function() {
        var i;
        for (i = 0; i < NUM*NUM; i++){
            clearTimeout(window['videoloop'+i]);
        }
        activePage = 'game';
        ctx.fillStyle = 'rgba('+Config.backGround+',0.8)';
        ctx.fillRect(0,0,canvas.width,canvas.height);
        object = new Menu();
        object.add(new MyTextItem('timeup', LANG_TIMEISUP, scaledW/2, HEIGHT*0.4, WIDTH*0.05, 2));
        object.add(new MenuItem('retry', LANG_RETRY, scaledW/2-WIDTH*0.2, HEIGHT*0.05, WIDTH*0.4, HEIGHT*0.13, HEIGHT*0.04, 5));
        object.add(new MenuItem('backm', LANG_B_MENU, scaledW/2-WIDTH*0.2, HEIGHT*0.82, WIDTH*0.4, HEIGHT*0.13, HEIGHT*0.04, 5));
        object.draw();
        $canvas.unbind('click');
        $canvas.bind('click', function(event){
            if (!object.getItem(event)) {
                return;
            }
            switch (object.getItem(event).name){
                case 'retry':
                    hint = false;
                    hintIcon = imageOff;
                    swapHint = false;
                    swapIcon = imageOff;
                    lost = false;
                    myTimer('stop');
                    animation = true;
                    swaps=1;
                    startPuzzle('challenge');
                    break;
                case 'backm':
                    hint = false;
                    hintIcon = imageOff;
                    swapHint = false;
                    swapIcon = imageOff;
                    lost = false;
                    myTimer('stop');
                    mainPage.draw();
                    animation = true;
                    swaps=1;
                    break;
                default: break;
            }
        });
    };
}

function ClassiciPage() {
    var object;
    this.draw = function() {
        activePage = 'classici';
        ctx.fillStyle = 'rgba('+Config.backGround+',0.8)';
        ctx.fillRect(0,0,canvas.width,canvas.height);
        object = new Menu();
        object.add(new ImageMenuItem('classicim', 'images/classic.jpg', 0, 0, WIDTH, HEIGHT, 0, 0, '', 1));
        object.draw();
        object_delayed = new Menu();
        object_delayed.add(new MyTextItem('i1',LANG_IC_TIMER + '\n' + LANG_I_TIMER2, WIDTH*0.45, HEIGHT*0.07, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i2',LANG_IC_EDGES + '\n' + hintMovePenalty + ' ' + LANG_I_MOVE_PENALTY, WIDTH*0.45, HEIGHT*0.26, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i3',LANG_IC_SWAP, WIDTH*0.45, HEIGHT*0.45, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i4',LANG_I_FULLIMAGE + '\n' + fullImageMovePenalty + ' ' + LANG_I_MOVE_PENALTY, WIDTH*0.45, HEIGHT*0.65, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i5',LANG_I_GRID, WIDTH*0.45, HEIGHT*0.9, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i6',LANG_I_EXIT, WIDTH*0.95, HEIGHT*0.96, WIDTH*0.018, 0, 'right'));
        $canvas.unbind('click');
        $canvas.bind('click', function(event){
            infoPage.draw();
        });
    };
}

function ChallengeiPage() {
    var object;
    this.draw = function() {
        activePage = 'challengei';
        ctx.fillStyle = 'rgba('+Config.backGround+',0.8)';
        ctx.fillRect(0,0,canvas.width,canvas.height);
        object = new Menu();
        object.add(new ImageMenuItem('challengeim', 'images/challenge.jpg', 0, 0, WIDTH, HEIGHT, 0, 0, '', 1));
        object.draw();
        object_delayed = new Menu();
        object_delayed.add(new MyTextItem('i1',LANG_I_TIMER + '\n' + LANG_I_TIMER2, WIDTH*0.45, HEIGHT*0.07, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i2',LANG_IC_EDGES + '\n' + hintTimePenalty + ' ' + LANG_I_SEC_PENALTY, WIDTH*0.45, HEIGHT*0.26, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i3',LANG_ICH_SWAP_NA, WIDTH*0.45, HEIGHT*0.45, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i4',LANG_I_FULLIMAGE +  '\n' + fullImageTimePenalty + ' ' + LANG_I_SEC_PENALTY, WIDTH*0.45, HEIGHT*0.65, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i5',LANG_I_GRID, WIDTH*0.45, HEIGHT*0.9, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i6',LANG_I_EXIT, WIDTH*0.95, HEIGHT*0.96, WIDTH*0.018, 0, 'right'));
        $canvas.unbind('click');
        $canvas.bind('click', function(event){
            infoPage.draw();
        });
    }
}

function FuniPage() {
    var object;
    this.draw = function() {
        activePage = 'funi';
        ctx.fillStyle = 'rgba('+Config.backGround+',0.8)';
        ctx.fillRect(0,0,canvas.width,canvas.height);
        object = new Menu();
        object.add(new ImageMenuItem('funim', 'images/fun.jpg', 0, 0, WIDTH, HEIGHT, 0, 0, '', 1));
        object.draw();
        object_delayed = new Menu();
        object_delayed.add(new MyTextItem('i1',LANG_I_TIMER + '\n' + LANG_I_TIMER2, WIDTH*0.45, HEIGHT*0.07, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i2',LANG_I_EDGES, WIDTH*0.45, HEIGHT*0.3, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i3',LANG_IF_SWAP, WIDTH*0.45, HEIGHT*0.45, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i4',LANG_I_FULLIMAGE, WIDTH*0.45, HEIGHT*0.65, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i5',LANG_I_GRID, WIDTH*0.45, HEIGHT*0.9, WIDTH*0.018, 0));
        object_delayed.add(new MyTextItem('i6',LANG_I_EXIT, WIDTH*0.95, HEIGHT*0.96, WIDTH*0.018, 0, 'right'));
        $canvas.unbind('click');
        $canvas.bind('click', function(event){
            infoPage.draw();
        });
    };
}

function PackPage() {
    var object;

    this.draw = function() {
        var imagepackCustom,
            i,
            j,
            p;

        if (videopuzzle) {
            $('video').get(0).pause();
            clearTimeout(videoendloop);
        }
        function showImagePacks() {
            imagepacks = 0;
            imageSizeW = canvas.width/imageNumX;
            imageSizeH = canvas.height/imageNumY;
            activePage = 'pack';
            ctx.fillStyle = 'rgba('+Config.backGround+',0.8)';
            ctx.fillRect(0,0,canvas.width,canvas.height);
            object = new Menu();
            for (j = 0; j < imageNumY; j++){
                for (i = (j)*imageNumX; i < ((j+1)*imageNumX); i++){
                    if (imagepacks < imagepackN) {
                        imagepacks++;
                        if (window['Pack'+i] !== undefined) {
                            object.add(new MenuItem('pack'+i, window['Pack'+i].name, 0+(i-j*imageNumX)*imageSizeW, j*imageSizeH, imageSizeW, imageSizeH, HEIGHT*0.035, 5));
                        }
                    }
                }
            }
            object.draw();
        }
        for (p = 1; p < imagepackN; p++){
            if ($('#pack'+p).length === 0) {
                loadjs("images/pack"+p+"/conf.js", 'pack'+p);
            } else {
                showImagePacks();
            }
        }
        imagepackCustom = imagepackN-1;
        $('#pack'+imagepackCustom).load(function(){
            showImagePacks();
        });
        $canvas.unbind('click');
        $canvas.bind('click', function(event){

            if (!object.getItem(event)) {
                mainPage.draw();
                return;
            }

            for (i = 0; i < imagepackN; i++){
                if (object.getItem(event).name === 'pack'+i){
                    if (activePage === 'pack') {
                        if (packN !== i) {
                            packN = i;
                            if (window['Pack'+i].type && window['Pack'+i].type === 'video') {
                                videopuzzle = true;
                                imagecount = window['Pack'+i].size;
                            } else {
                                videopuzzle = false;
                            }
                            firstImage();
                            loading(i);
                            return;
                        }
                        mainPage.draw();
                    }
                }
            }
        });
    };
}
function InfoPage() {
    var object;

    this.draw = function() {
        if (videopuzzle) {
            $('video').get(0).pause();
            clearTimeout(videoendloop);
        }
        activePage = 'info';
        ctx.fillStyle = 'rgba('+Config.backGround+',0.8)';
        ctx.fillRect(0,0,canvas.width,canvas.height);
        object = new Menu();
        object.add(new MyTextItem('title',LANG_ABOUT_TITLE, WIDTH/2, HEIGHT*0.1, WIDTH*0.03, 0));
        object.add(new ImageMenuItem('icon', 'images/icon.png', WIDTH/2-BSIZE*WIDTH*0.0015/2, HEIGHT*0.35, BSIZE*WIDTH*0.0015, BSIZE*WIDTH*0.0015, 0));
        object.add(new MyTextItem('about','Sliding Puzzle '+version, WIDTH/2, HEIGHT*0.25, WIDTH*0.03, 0));
        object.add(new MyTextItem('about','© 2012 Nagy Dániel Péter - Andy1210\n e-mail: andy1210@gmail.com', WIDTH/2, HEIGHT*0.6, WIDTH*0.02, 0));
        object.add(new MyTextItem('helptitle',LANG_HELP, WIDTH/2, HEIGHT*0.85, WIDTH*0.025, 0));
        object.add(new MenuItem('classici', LANG_CLASSIC_M, WIDTH*0.1, HEIGHT*0.9, WIDTH*0.2, HEIGHT*0.08, HEIGHT*0.022, 5));
        object.add(new MenuItem('challengei', LANG_CHALLENGE_M, WIDTH*0.4, HEIGHT*0.9, WIDTH*0.2, HEIGHT*0.08, HEIGHT*0.022, 5));
        object.add(new MenuItem('funi', LANG_FUN_M, WIDTH*0.7, HEIGHT*0.9, WIDTH*0.2, HEIGHT*0.08, HEIGHT*0.022, 5));
        object.draw();
        $canvas.unbind('click');
        $canvas.bind('click', function(event){
            if (!object.getItem(event)) {
                mainPage.draw();
                return;
            }
            switch (object.getItem(event).name){
                case 'classici':
                    classiciPage.draw();
                    break;
                case 'challengei':
                    challengeiPage.draw();
                    break;
                case 'funi':
                    funiPage.draw();
                    break;
                default: break;
            }
        });
    };
}

function FullImagePage() {

	this.draw = function() {
        var i;

		if (!isFullImgHint) {
			if (videopuzzle) {
				for (i = 0; i < NUM*NUM; i++){
					clearTimeout(window['videoloop'+i]);
				}
				(function loopend() {
					if (!video.paused && !video.ended) {
						ctx.drawImage(video, 0, 0, scaledW, canvas.height);
						videoendloop = setTimeout(loopend, 1000 / Config.videoFPS); // fps
					}
				})();
			} else {
				ctx.drawImage(kep, 0, 0, scaledW, HEIGHT);
			}
			alertM = 1;
			showfullIcon = imageOn;
			buttonRepaint();
			isFullImgHint = true;
		} else {
			isFullImgHint = false;
		}
	};
}

function MessagePage() {
    var object;

    this.draw = function(line1,line2) {
        this.line1 = line1;
        this.line2 = line2;
        ctx.fillStyle = 'rgba('+Config.backGround+',0.5)';
        ctx.fillRect(0,0,canvas.width,canvas.height);
        object = new Menu();
        if (!line2) {
            object.add(new MyTextItem('alert', line1, scaledW/2, HEIGHT*0.5, WIDTH*0.030, 0));
        } else {
            object.add(new MyTextItem('alert', line1, scaledW/2, HEIGHT*0.4, WIDTH*0.030, 0));
            object.add(new MyTextItem('alert2', line2, scaledW/2, HEIGHT*0.6, WIDTH*0.027, 0));
        }
        object.draw();
        alertM = 1;
    };
}


function ImageSelectedPage() {
    var object;

    this.draw = function() {
        activePage = 'selected';
        ctx.fillStyle = 'rgba('+Config.backGround+',0.5)';
        ctx.fillRect(0,0,canvas.width,canvas.height);
        object = new Menu();
        if (videopuzzle) {
            $('video').get(0).play();
            object.add(new VideoMenuItem('selected', 10, 10, WIDTH*0.7, HEIGHT-20));
        } else {
            object.add(new ImageMenuItem('selected','images/pack'+packN+ '/pack'+packN+'_'+selectedImage+'.jpg', 10, 10, WIDTH*0.7, HEIGHT-20, 5));
        }
        object.add(new MenuItem('ok', LANG_SELECT, WIDTH*0.75, HEIGHT*0.1, WIDTH*0.21, HEIGHT*0.2, HEIGHT*0.05, 5));
        object.add(new MenuItem('cancel', LANG_CANCEL, WIDTH*0.75, HEIGHT*0.7, WIDTH*0.21, HEIGHT*0.2, HEIGHT*0.05, 5));
        object.draw();
        $canvas.unbind('click');
        $canvas.bind('click', function(event){
            if (!object.getItem(event)) {
                return;
            }
            switch (object.getItem(event).name){
                case 'ok':
                    if (videopuzzle) {
                        $('video').get(0).pause();
                        clearTimeout(videoendloop);
                    } else {
                        selectImage('images/pack'+packN+ '/pack'+packN+'_'+selectedImage+'.jpg');
                    }
                    mainPage.draw();
                    customGame = false;
                    break;
                case 'cancel':
                    if (videopuzzle) {
                        $('video').get(0).pause();
                        clearTimeout(videoendloop);
                    }
                    imagePage.draw();
                    break;
                default: break;
            }
        });
    };
}

function ImagePage() {
    var object;

    this.draw = function() {
        var i,
            j;

        if (videopuzzle) {
            $('video').get(0).pause();
            clearTimeout(videoendloop);
        }
        imageSizeW = canvas.width/imageNumX;
        imageSizeH = canvas.height/imageNumY;
        activePage = 'image';
        ctx.fillStyle = 'rgba('+Config.backGround+',0.5)';
        ctx.fillRect(0,0,canvas.width,canvas.height);
        var loadingi = new MyTextItem('loadingi', LANG_LOADING_IMAGES, WIDTH/2, HEIGHT*0.5, WIDTH*0.030, 0)
        loadingi.draw();

        function drawImageObjects() {
			videopuzzle = (window['Pack'+packN].type === 'video');

            images=0;
            object = new Menu();
            for (j = 0; j < imageNumY; j++){
                for (i = (j)*imageNumX+1; i < ((j+1)*imageNumX+1); i++){
                    if (images < imagecount) {
                        images++;
                        if (videopuzzle) {
                            object.add(new ImageMenuItem(i, '', 0 + (i - 1 - j * imageNumX) * imageSizeW, j * imageSizeH, imageSizeW, imageSizeH, 2));
                            object.add(new MyRectItem('rect', 0 + (i - 1 - j * imageNumX) * imageSizeW, j * imageSizeH, imageSizeW, imageSizeH, '#000'));
                            object.add(new MyStrokeItem('stroke', 0 + (i - 1 - j * imageNumX) * imageSizeW, j * imageSizeH, imageSizeW, imageSizeH, '#fff'));
                            object.add(new MyTextItem('title', i, 0 + (i - 1 - j * imageNumX) * imageSizeW + imageSizeW / 2, j * imageSizeH+imageSizeH / 2, WIDTH * 0.05, 0));
                        } else {
                            object.add(new ImageMenuItem(i, 'images/pack'+packN+'/pack'+packN+'_'+i+'.jpg', 0+(i-1-j*imageNumX)*imageSizeW, j*imageSizeH, imageSizeW, imageSizeH, 2));
                        }
                    }
                }
            }
            object.add(new MenuItem('cancel', LANG_CANCEL, WIDTH-imageSizeW, HEIGHT-imageSizeH, imageSizeW, imageSizeH, HEIGHT*0.04, 5));
            object.draw();
        }
        var ti = 400;
        var timer2 = setInterval(function(){
            ti -= 40;
            if (ti <= 0) {
                clearInterval(timer2);
                drawImageObjects();
            }
        }, 40);
        $canvas.unbind('click');
        $canvas.bind('click', function(event){
            for (i = 0; i < imageNumX * imageNumY + 1; i++) {
                if (!object.getItem(event)) {
                    return;
                }
                if (object.getItem(event).name) {
                    if (object.getItem(event).name === i) {
                        selectedImage = i;
                        if (activePage === 'image') {
                            if (videopuzzle) {
                                selectImage('images/pack'+packN+ '/pack'+packN+'_'+selectedImage+'.ogg');
                                //mainPage.draw();
                                imageSelectedPage.draw();
                            } else {
                                imageSelectedPage.draw();
                            }
                        }
                    }
                    if (object.getItem(event).name === 'cancel') {
                        mainPage.draw();
                        return;
                    }
                }
            }
        });
    };
}

function SizePage() {
    var object;

    this.draw = function() {
        var i;

        if (videopuzzle) {
            $('video').get(0).pause();
            clearTimeout(videoendloop);
        }
        activePage = 'size';
        ctx.fillStyle = 'rgba('+Config.backGround+',0.8)';
        ctx.fillRect(0,0,canvas.width,canvas.height);
        object = new Menu();
        object.add(new SizeMenuItem('2', WIDTH/5.5, HEIGHT/5, WIDTH/10, WIDTH/10, 2));
        object.add(new SizeMenuItem('3', (WIDTH/5.5)*2, HEIGHT/5, WIDTH/10, WIDTH/10, 3));
        object.add(new SizeMenuItem('4', (WIDTH/5.5)*3, HEIGHT/5, WIDTH/10, WIDTH/10, 4));
        object.add(new SizeMenuItem('5', (WIDTH/5.5)*4, HEIGHT/5, WIDTH/10, WIDTH/10, 5));
        object.add(new SizeMenuItem('6', WIDTH/5.5, HEIGHT/1.8, WIDTH/10, WIDTH/10, 6));
        object.add(new SizeMenuItem('7', (WIDTH/5.5)*2, HEIGHT/1.8, WIDTH/10, WIDTH/10, 7));
        object.add(new SizeMenuItem('8', (WIDTH/5.5)*3, HEIGHT/1.8, WIDTH/10, WIDTH/10, 8));
        object.add(new SizeMenuItem('9', (WIDTH/5.5)*4, HEIGHT/1.8, WIDTH/10, WIDTH/10, 9));
        object.draw();
        $canvas.unbind('click');
        $canvas.bind('click', function (event){
            if (!object.getItem(event)) {
                return;
            }
            for (i = 1; i < 10; i++){
                if (parseInt(object.getItem(event).name, 10) === i) {
                    setNUM(i);
                    mainPage.draw();
                    return;
                }
            }

        });
    };
}

function NewGamePage() {
    var object;
    this.draw = function() {
        if (videopuzzle) {
            $('video').get(0).pause();
            clearTimeout(videoendloop);
        }
        if (Config.versionCheck) {
            versionCheck();
        }
        ctx.fillStyle = 'rgba('+Config.backGround+',0.8)';
        ctx.fillRect(0,0,canvas.width,canvas.height);
        activePage = 'newgame';
        object = new Menu();
        object.add(new MenuItem('classic', LANG_CLASSIC, WIDTH/2-WIDTH*0.2, HEIGHT*0.15, WIDTH*0.4, HEIGHT*0.13, HEIGHT*0.04, 5));
        object.add(new MenuItem('challenge', LANG_CHALLENGE, WIDTH/2-WIDTH*0.2, HEIGHT*0.3, WIDTH*0.4, HEIGHT*0.13, HEIGHT*0.04, 5));
        object.add(new MenuItem('fun', LANG_FUN, WIDTH/2-WIDTH*0.2, HEIGHT*0.45, WIDTH*0.4, HEIGHT*0.13, HEIGHT*0.04, 5));
        object.add(new MenuItem('cancel', LANG_CANCEL, WIDTH/2-WIDTH*0.2, HEIGHT*0.7, WIDTH*0.4, HEIGHT*0.13, HEIGHT*0.04, 5));
        object.draw();
        $canvas.unbind('click');
        $canvas.bind('click', function (event){
            if (!object.getItem(event)) {
                return;
            }
            if (activePage !== 'newgame') {
                return;
            }
            switch (object.getItem(event).name){
                case 'classic':
                    startPuzzle('classic');
                    activePage = 'game';
                    break;
                case 'challenge':
                    startPuzzle('challenge');
                    activePage = 'game';
                    break;
                case 'fun':
                    startPuzzle('fun');
                    activePage = 'game';
                    break;
                case 'cancel':
                    mainPage.draw();
                    break;
                default: break;
            }
        });
    };
}

function MainPage() {
    var object,
        modeName;

    this.firstLoad = function() {
        firstImage(null, this.draw);
    };

    this.draw = function() {

        cWon = false;
        activePage = 'main';
        ctx.clearRect(0, 0, WIDTH, HEIGHT);
        var highMoves = localStorage.getItem(packN+'_'+selectedImage+'_'+NUM+'_'+modeshow+'_moves');
        var highTime = localStorage.getItem(packN+'_'+selectedImage+'_'+NUM+'_'+modeshow+'_time');
        if (modeshow === 'classic') {
            modeName = LANG_CLASSIC;
        }
        if (modeshow === 'challenge') {
            modeName = LANG_CHALLENGE;
        }
        if (modeshow === 'fun') {
            modeName = LANG_FUN;
        }
        if (!highMoves) {
            highMoves = LANG_NA;
            highTime = LANG_NA;
        }
        object = new Menu();
        object.add(new MyStrokeItem('selectedimagerect', WIDTH*0.6, HEIGHT*0.312, (WIDTH+HEIGHT)*0.182, (HEIGHT*0.162)*2.2, 'rgba('+Config.color+',1)',2));
        if (videopuzzle) {
            $('video').get(0).play();
            object.add(new VideoMenuItem('selected', WIDTH*0.6+3, HEIGHT*0.312+3,(WIDTH+HEIGHT)*0.182-6, (HEIGHT*0.162)*2.2-6,1));
        } else {
            object.add(new ImageMenuItem('selectedimage', kep.src, WIDTH*0.6+3, HEIGHT*0.312+3, (WIDTH+HEIGHT)*0.182-6, (HEIGHT*0.162)*2.2-6, 1, 1));
        }
        if (!customGame) {
            object.add(new MyTextItem('modename', modeName + ' ' + LANG_MODE + ' ' + LANG_SCORES, WIDTH/1.63, HEIGHT*0.71, HEIGHT*0.03, 0, 'left'));
            object.add(new MyTextItem('besttime', LANG_BEST+': ', WIDTH/1.63, HEIGHT*0.745, HEIGHT*0.03, 0, 'left'));
            object.add(new MyTextItem('besttime2', highTime, WIDTH/1.63+WIDTH*0.15, HEIGHT*0.745, HEIGHT*0.03, 0, 'left'));
            object.add(new MyTextItem('bestmoves', LANG_MOVES+': ', WIDTH/1.63, HEIGHT*0.78, HEIGHT*0.03, 0, 'left'));
            object.add(new MyTextItem('bestmoves2', highMoves, WIDTH/1.63+WIDTH*0.15, HEIGHT*0.78, HEIGHT*0.03, 0, 'left'));
            object.add(new ImageMenuItem('next', 'images/next_'+nextIcon+'.png', WIDTH/1.19, HEIGHT*0.735, BSIZE, BSIZE, 0));
        }
        object.add(new MyTextItem('title','Sliding Puzzle', WIDTH/2, HEIGHT*0.15, WIDTH*0.09, 2));
        object.add(new MenuItem('new', LANG_NEWGAME, WIDTH/2-WIDTH*0.43, HEIGHT*0.32, WIDTH*0.4, HEIGHT*0.13, HEIGHT*0.04, 5));
        object.add(new MenuItem('image', LANG_SELECT_I, WIDTH/2-WIDTH*0.43, HEIGHT*0.48, WIDTH*0.4, HEIGHT*0.13, HEIGHT*0.04, 5));
        object.add(new MenuItem('size', LANG_SELECT_S, WIDTH/2-WIDTH*0.43, HEIGHT*0.64, WIDTH*0.4, HEIGHT*0.13, HEIGHT*0.04, 5));
        object.add(new ImageMenuItem('info', 'images/info_'+infoIcon+'.png', BSIZE*0.2, HEIGHT-BSIZE*1.2, BSIZE, BSIZE, 0));
        object.add(new MyTextItem('swipe','Swipe', WIDTH/2-BSIZE*1.5, HEIGHT-BSIZE*0.8, WIDTH*0.015, 0));
        object.add(new ImageMenuItem('switch', 'images/switch_'+switchIcon+'.png', WIDTH/2-BSIZE*0.3, HEIGHT-BSIZE*1.1, BSIZE*1.5, BSIZE*0.7, 0));
        object.add(new MyTextItem('tap','Tap', WIDTH/2+BSIZE*2, HEIGHT-BSIZE*0.8, WIDTH*0.015, 0));
        object.add(new ImageMenuItem('pack', 'images/pack_'+packIcon+'.png', WIDTH-BSIZE*1.2, HEIGHT-BSIZE*1.2, BSIZE, BSIZE, 0));
        if (Config.openOwnImages) {
            object.add(new ImageMenuItem('open', 'images/open_'+openIcon+'.png', WIDTH-BSIZE*3, HEIGHT-BSIZE*1.25, BSIZE, BSIZE, 0));
        }
        object.draw();
        $canvas.unbind('click');
        $canvas.bind('click', function(event){
            if (!object.getItem(event)) {
                return;
            }
            switch (object.getItem(event).name){
                case 'new':
                    newGamePage.draw();
                    break;
                case 'size':
                    sizePage.draw();
                    break;
                case 'image':
                    imagePage.draw();
                    break;
                case 'info':
                    infoPage.draw();
                    break;
                case 'pack':
                    packPage.draw();
                    break;
                case 'open' :
                    $('#myimage').trigger('click');
                    document.getElementById('myimage').addEventListener('change', handleFileSelect, false);
                    break;
                case 'next':
                    if (modeshow === 'classic') {
                        modeshow = 'challenge';
                        mainPage.draw();
                        break;
                    }
                    if (modeshow === 'challenge') {
                        modeshow = 'fun';
                        mainPage.draw();
                        break;
                    }
                    if (modeshow === 'fun') {
                        modeshow = 'classic';
                        mainPage.draw();
                        break;
                    }
                    break;
                case 'switch':
                    if (switchIcon === 'l') {
                        switchIcon = 'r';
                        swipe = false;
                    } else {
                        switchIcon = 'l';
                        swipe = true;
                    }
                    mainPage.draw();
                    break;
                default: break;
            }
        });
    };
}

function firstImage(mod, callback) {
    if (mod === 'nextimg') {
        videopuzzle = false;
    }

    if (videopuzzle) {
        $('video').get(0).pause();
        $('#videosrc').attr('src','images/pack'+packN+'/pack'+packN+'_1.ogg');
        $('video').get(0).load();
        console.log($('video').get(0));
        video = document.getElementById('video');
    } else {
        if (confLoaded) {
            if (Config.quickMode !== 0) {
                var randPack = Math.floor(Math.random() * Config.packNum);
                $('#randPack'+randPack).remove();
                loadjs('images/pack'+randPack+'/conf.js', 'randPack'+randPack);
                $('#randPack'+randPack).load(function(){
                    var randNum = Math.floor(Math.random() * window['Pack'+randPack].size) + 1;
                    if (window['Pack'+randPack].type && window['Pack'+randPack].type === 'video') {
                        videopuzzle = true;
                        $('video').get(0).pause();
                        $('#videosrc').attr('src', 'images/pack' + randPack + '/pack' + randPack + '_' + randNum + '.ogg');
                        $('video').get(0).load();
                        video = document.getElementById('video');
                        videopuzzle = true;
                    } else {
                        kep.src = 'images/pack' + randPack + '/pack' + randPack + '_' + randNum + '.jpg';
                        if (callback) {
                            callback();
                        }
                    }

                    if (Config.quickMode === 1) {
                        startPuzzle('classic');
                        activePage = 'game';
                        return;
                    }
                    if (Config.quickMode === 2) {
                        startPuzzle('challenge');
                        activePage = 'game';
                        return;
                    }
                    if (Config.quickMode === 3) {
                        startPuzzle('fun');
                        activePage = 'game';
                    }
                });
            } else {
                $('#defaultPack').remove();
                loadjs('images/pack'+packN+'/conf.js', 'defaultPack');
                $('#defaultPack').load(function(){
                    if (window['Pack'+packN].type && window['Pack'+packN].type === 'video') {
                        videopuzzle = true;
                        $('video').get(0).pause();
                        $('#videosrc').attr('src','images/pack'+packN+'/pack'+packN+'_1.ogg');
                        $('video').get(0).load();
                        video = document.getElementById('video');
                        videopuzzle = true;
                    } else {
                        kep.src = 'images/pack'+packN+'/pack'+packN+'_1.jpg';
                        if (callback) {
                            callback();
                        }
                    }
                });

            }
        }
    }
    selectedImage = 1;
}

packPage = new PackPage();
lostPage = new LostPage();
classiciPage = new ClassiciPage();
challengeiPage = new ChallengeiPage();
funiPage = new FuniPage();
infoPage = new InfoPage();
newGamePage = new NewGamePage();
fullImagePage = new FullImagePage();
imageSelectedPage = new ImageSelectedPage();
messagePage = new MessagePage();
imagePage = new ImagePage();
sizePage = new SizePage();
mainPage = new MainPage();
activePage='main';

function showMain() {
    if (Config.quickMode === 1) {
        activePage = 'game';
        return;
    }
    if (Config.quickMode === 2) {
        activePage = 'game';
        return;
    }
    if (Config.quickMode === 3) {
        activePage = 'game';
        return;
    }
    if (PORTRAIT) {
        ctx.clearRect(0, 0, WIDTH, HEIGHT);
        ctx.textAlign = 'center';
        ctx.textBaseline = 'middle';
        ctx.font = 'bold '+ WIDTH * 0.03 + 'pt sans-serif';
        ctx.fillStyle = 'rgba(' + Config.foreGround + ',1)';
        ctx.fillText(LANG_WINDOW_SMALL, WIDTH / 2, HEIGHT / 2);
    } else {
        if (loadingS) {
            loading(packN);
        } else {
            mainPage.draw();
        }
    }
}