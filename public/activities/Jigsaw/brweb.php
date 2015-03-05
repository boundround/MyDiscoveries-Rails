<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=9" />
    <title>Jigsaw Puzzle</title>
    <!--[if lt IE 9]><script type="text/javascript" src="js/bin/flashcanvas.js"></script><![endif]-->
    <link rel="stylesheet" href="css/modal.css" type="text/css" charset="utf-8" />
    <link rel="stylesheet" href="css/style.css" type="text/css" charset="utf-8" />
    <link rel="stylesheet" href="css/buttons.css" type="text/css" charset="utf-8" />
    <meta name="viewport" content="width=device-width; height=device-height; initial-scale=1.0; maximum-scale=1.0;"/>
</head>
<body>

<!-- JIGSAW CANVAS -->
<div id="canvas-wrap">
    <canvas id="canvas"></canvas>
    <canvas class="hide" id="image"></canvas>
    <canvas class="hide" id="image-preview"></canvas>
</div>

<!-- GAME OPTIONS -->
<div id="game-options">
<ul>
    <li><b id="clock" class="button">00:00:00</b></li>
    <li><a href="#" id="SHOW_EDGE" class="button left" title="Show edge pieces only">Border</a></li>
    <li><a href="#" id="SHOW_MIDDLE" class="button middle" title="Show middle pieces only">Middle</a></li>
    <li><a href="#" id="SHOW_ALL" class="button right" title="Show all pieces">All</a></li>
    <li><a href="#" id="JIGSAW_SHUFFLE" class="button left" title="Shuffle">Shuffle</a></li>
    <li><a href="#" id="SHOW_PREVIEW" class="button middle" title="Preview">Preview</a></li>
    <li><a href="#" id="SHOW_HELP" class="button help right" title="Help">Help</a></li>
    <!-- INSERT CUSTOM BUTTONS -->
    
    <!-- END INSERT CUSTOM BUTTONS -->
    <li>
        <div class="styled-select">
            <select id="set-parts" selected-index="8">
            </select>
        </div>
    </li>
    <!-- Insert custom buttons here -->
    <li id="create"><a href="#" class="button add" id="SHOW_FILEPICKER" title="Create puzzle" >Create puzzle</a></li>
</ul>
<br class="clear"/>
</div>

<!-- MODAL WINDOW -->
<div class="hide" id="overlay"></div>
<div id="modal-window" class="hide">
    <div id="modal-window-msg"></div>
    <a href="#" id="modal-window-close" class="button">Close</a>
</div>

<!-- CONGRATULATION -->
<div id="congrat" class="hide">
    <h1>Congratulations!</h1>
    <h2>You solved it in</h2>
    <h3><span id="time"></span></h3>
    <form method="post" class="hide" action="" target="save-score" onsubmit="jigsaw.UI.close_lightbox();">
        <label>
        Your Name: <input type="text" name="name" />
        </label>
        <input type="submit" value="Save score" />
        <input type="hidden" id="time-input" name="time"/>
    </form>
</div>

<!-- CREATE PUZZLE -->
<div class="hide" id="create-puzzle">
    <h1>Choose an image</h1>
    <form id="image-form" id="add-image-form">
        <input type="file" id="image-input">
        <p id="image-error">that's not an image</p>
        <p id="dnd"><i>Or drag one from your computer</i></p>
    </form>
</div>

<!-- HELP -->
<div id="help" class="hide">
    <h2>How to play</h2>
    <ul>
        <li>Change the number of pieces with the selector on the top.<br/>
            <img src="images/selector.png"/>
        </li>
        
        <li>Use left/right arrows, or right click to rotate a piece.</li>

        <li>Toggle between edge or middle pieces:<br>
            <img src="images/toggle.png"/>
        </li>
    </ul>
    
    <h3>Good luck.</h3>
</div>

<form class="hide" method="post" id="redirect-form">
    <input type="text" name="time" id="t" />
    <input type="text" name="parts" id="p" />
</form>
<iframe class="hide" src="about:blank" id="save-score" name="save-score"></iframe>
<!-- SCRIPTS ROMPECABEZAS -->
<script src="js/event-emiter.min.js"></script>
<script src="js/canvas-event.min.js"></script>
<script src="js/canvas-puzzle.min.js"></script>
<script src="../jQuery/jquery.mobile-1.3.2.min.js"></script>
<script src="js/canvas-size.js"></script>
<!--[if lt IE 9]><script type="text/javascript" src="js/canvas-puzzle.ie.min.js"></script><![endif]-->
<script>
var puzzle;
var changeImage = function(imagePath) {
    puzzle.eventBus.emit(jigsaw.Events.JIGSAW_SET_IMAGE, imagePath);
}

var changeNumberOfPieces = function(count) {
    puzzle.eventBus.emit(jigsaw.Events.PARTS_NUMBER_CHANGED, count);
    puzzle.eventBus.emit(jigsaw.Events.RENDER_REQUEST);
}

var requestRender = function(count) {
    puzzle.eventBus.emit(jigsaw.Events.RENDER_REQUEST);
}

var shuffleImage = function() {
    puzzle.eventBus.emit(jigsaw.Events.JIGSAW_SHUFFLE);
}

var renderCompleted = function() {
    setTimeout(function() { shuffleImage(); }, 1000);
}

var initPuzzle = function(imagePath, piecesCount) {
    puzzle = new jigsaw.Jigsaw({
                               defaultImage: imagePath,
                               defaultPieces: piecesCount,
                               spread: .5,
                               piecesNumberTmpl: "%d Pieces"
                               });
    puzzle.eventBus.on(jigsaw.Events.RENDER_FINISH, this.renderCompleted.bind(this));
}

</script>

<?php

$image = htmlspecialchars($_GET["imageurl"]);
$runPuzzle = "<script>" . " initPuzzle('" . $image . "'," . htmlspecialchars($_GET["puzzlesize"]) . ");" . "</script>";

echo $runPuzzle;

?>


</body>
</html>