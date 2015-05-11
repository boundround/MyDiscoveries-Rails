<!DOCTYPE html>
<html>
    <head>
        <title>SlidingPuzzle</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
        <script src="lang/en.js" type="text/javascript"></script>
        <script src="jquery-2.1.1.min.js" type="text/javascript"></script>
		<style type="text/css">
			* { -webkit-tap-highlight-color: rgba(255,255,255,0);}
			html, body { padding: 0; margin: 0; overflow: hidden; width: 100%; height: 100%;
            -webkit-touch-callout: none;
            -webkit-user-select: none;
            -khtml-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;   
            }
			canvas { background: #000; padding: 0; margin: 0;}
			video { display: none; }
			#wrapper {
				margin: 20px;
			}
		</style>
    </head>
    <body>
		<canvas id="canvas" width="854" height="480"></canvas>
		<!--script src="slidingpuzzle.js" type="text/javascript"></script-->
		<script src="unminified/game.js" type="text/javascript"></script>
		<script src="unminified/object.js" type="text/javascript"></script>
		<video id="video" loop="loop" muted="muted">
			<source id='videosrc' src="" type=video/ogg> 
		</video> 
	</body>
	<?php

	$image = htmlspecialchars($_GET["imageurl"]);
	$runPuzzle = "<script>" . " initPuzzle('" . $image . "'," . htmlspecialchars($_GET["puzzlesize"]) . ");" . "</script>";

	echo $runPuzzle;

	?>
	
</html>