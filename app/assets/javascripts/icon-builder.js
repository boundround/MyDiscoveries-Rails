(function(f){if(typeof exports==="object"&&typeof module!=="undefined"){module.exports=f()}else if(typeof define==="function"&&define.amd){define([],f)}else{var g;if(typeof window!=="undefined"){g=window}else if(typeof global!=="undefined"){g=global}else if(typeof self!=="undefined"){g=self}else{g=this}(g.thirdFloor || (g.thirdFloor = {})).iconBuilder = f()}})(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
'use strict';

var hasOwn = Object.prototype.hasOwnProperty;
var toStr = Object.prototype.toString;

var isArray = function isArray(arr) {
	if (typeof Array.isArray === 'function') {
		return Array.isArray(arr);
	}

	return toStr.call(arr) === '[object Array]';
};

var isPlainObject = function isPlainObject(obj) {
	if (!obj || toStr.call(obj) !== '[object Object]') {
		return false;
	}

	var hasOwnConstructor = hasOwn.call(obj, 'constructor');
	var hasIsPrototypeOf = obj.constructor && obj.constructor.prototype && hasOwn.call(obj.constructor.prototype, 'isPrototypeOf');
	// Not own constructor property must be Object
	if (obj.constructor && !hasOwnConstructor && !hasIsPrototypeOf) {
		return false;
	}

	// Own properties are enumerated firstly, so to speed up,
	// if last one is own, then all properties are own.
	var key;
	for (key in obj) {/**/}

	return typeof key === 'undefined' || hasOwn.call(obj, key);
};

module.exports = function extend() {
	var options, name, src, copy, copyIsArray, clone,
		target = arguments[0],
		i = 1,
		length = arguments.length,
		deep = false;

	// Handle a deep copy situation
	if (typeof target === 'boolean') {
		deep = target;
		target = arguments[1] || {};
		// skip the boolean and the target
		i = 2;
	} else if ((typeof target !== 'object' && typeof target !== 'function') || target == null) {
		target = {};
	}

	for (; i < length; ++i) {
		options = arguments[i];
		// Only deal with non-null/undefined values
		if (options != null) {
			// Extend the base object
			for (name in options) {
				src = target[name];
				copy = options[name];

				// Prevent never-ending loop
				if (target !== copy) {
					// Recurse if we're merging plain objects or arrays
					if (deep && copy && (isPlainObject(copy) || (copyIsArray = isArray(copy)))) {
						if (copyIsArray) {
							copyIsArray = false;
							clone = src && isArray(src) ? src : [];
						} else {
							clone = src && isPlainObject(src) ? src : {};
						}

						// Never move original objects, clone them
						target[name] = extend(deep, clone, copy);

					// Don't bring in undefined values
					} else if (typeof copy !== 'undefined') {
						target[name] = copy;
					}
				}
			}
		}
	}

	// Return the modified object
	return target;
};


},{}],2:[function(require,module,exports){
var extend = require('extend');
var helper = require('./helper');
var defaultConfig = require('./defaultConfig');

module.exports = {
  /**
   * Default width of the canvas
   * @type {Number}
   */
  CANVAS_DEFAULT_WIDTH: defaultConfig.canvas.width,

  /**
   * Default height of the canvas
   * @type {Number}
   */
  CANVAS_DEFAULT_HEIGHT: defaultConfig.canvas.height,

  /**
   * @param {Object} cfg
   * @returns {String}
   */
  build: function(cfg) {
    cfg = cfg || {};
    cfg = extend(true, {}, defaultConfig, cfg);

    // --------------------------------
    // options
    // --------------------------------
    // canvas
    var canvasWidth = cfg.canvas.width;
    var canvasHeight = cfg.canvas.height;

    // background shape
    var backgroundColor = cfg.backgroundShape.backgroundColor;

    var outerCircleRadius = cfg.backgroundShape.circle.radius;

    var triangleWidth = cfg.backgroundShape.triangle.width;
    var triangleHeight = cfg.backgroundShape.triangle.height;

    // inner circle
    var innerCircleRadius = cfg.innerCircle.radius;
    var innerCircleBgColor = cfg.innerCircle.backgroundColor;

    // inner text
    var innerTextContent = cfg.innerText.content;
    var innerTextColor = cfg.innerText.color;
    var innerTextStyle = cfg.innerText.style;

    // outer text
    var outerTextPadding = cfg.outerText.padding;
    var outerTextContent = cfg.outerText.content;
    var outerTextColor = cfg.outerText.color;
    var outerTextArc = cfg.outerText.arc;
    var outerTextStyle = cfg.outerText.style;

    // --------------------------------
    // calculated values
    // --------------------------------
    var centerX = canvasWidth * 0.5;
    var centerY = canvasHeight * 0.5;

    // --------------------------------
    // canvas
    // --------------------------------
    var canvas = document.createElement('canvas');
    canvas.setAttribute('width', canvasWidth.toString());
    canvas.setAttribute('height', canvasHeight.toString());
    var context = canvas.getContext('2d');

    // --------------------------------
    // tasks
    // --------------------------------
    function renderOuterTextTask() {
      context.save();

      helper.startShadow(context);

      context.font = helper.fontStylesToCanvasFont(outerTextStyle);
      context.fillStyle = outerTextColor;

      var outerTextRadius = outerCircleRadius + outerTextPadding;

      var lengthOfMaxArc = Math.PI * outerTextRadius * outerTextArc / 180;

      var text = outerTextContent;

      var i;

      // cut too long text
      var ellipsis = '...';
      if (context.measureText(text).width > lengthOfMaxArc) {
        do {
          text = text.substring(0, text.length - 1);
          if (text.length === 0) {
            break;
          }
        } while (context.measureText(text + ellipsis).width > lengthOfMaxArc);
        text = text + ellipsis;
      }

      var lengthOfWholeText = context.measureText(text).width;
      var angleForWholeText = lengthOfWholeText * 180 / (Math.PI * outerTextRadius);
      var startAngle = -angleForWholeText * 0.5;

      var countOfLetters = text.length;

      var lengthsOfLetters = [];
      var testStr = '';
      for (i = 0; i < countOfLetters; i++) {
        testStr += text[i];
        var totalWidth = context.measureText(testStr).width;
        var widthOfLetter = context.measureText(text[i]).width;
        var offsetOfCenter = totalWidth - widthOfLetter * 0.5;
        lengthsOfLetters.push(offsetOfCenter);
      }

      context.translate(centerX, centerY);

      var currentAngle = startAngle;
      var widthRatio;
      var anglePerLetter;
      var radians;
      for (i = 0; i < countOfLetters; i++) {
        widthRatio = lengthsOfLetters[i] / lengthOfWholeText;
        anglePerLetter = widthRatio * angleForWholeText;
        currentAngle = startAngle + anglePerLetter;
        radians = currentAngle * Math.PI / 180;

        context.save();
        context.rotate(radians);

        context.textAlign = 'center';
        context.fillText(text[i], 0, -outerTextRadius);

        context.restore();
      }

      helper.endShadow(context);

      context.restore();
    }

    function renderTriangleTask() {
      context.save();

      var triangleLeftX = centerX - triangleWidth * 0.5;
      var triangleRightX = triangleLeftX + triangleWidth;
      var triangleTopY = centerY + innerCircleRadius;
      var triangleBottomY = triangleTopY + triangleHeight;

      var trianglePoints = [
        {
          x: triangleLeftX,
          y: triangleTopY
        },
        {
          x: triangleRightX,
          y: triangleTopY
        },
        {
          x: centerX,
          y: triangleBottomY
        }
      ];

      context.fillStyle = backgroundColor;

      context.beginPath();
      var count = trianglePoints.length;
      for (var i = 0; i < count; i++) {
        if (i === 0) {
          context.moveTo(trianglePoints[i].x, trianglePoints[i].y);
          continue;
        }
        context.lineTo(trianglePoints[i].x, trianglePoints[i].y);
      }
      context.closePath();
      context.fill();

      context.restore();
    }

    function renderBackgroundTask() {
      context.save();

      helper.startShadow(context);
      renderTriangleTask();
      helper.drawCircle(context, centerX, centerY, outerCircleRadius, backgroundColor);
      helper.endShadow(context);

      // we need 2nd triangle in order to hide shadow from circle
      renderTriangleTask();

      context.restore();
    }

    function renderInnerCircleTask() {
      helper.drawCircle(context, centerX, centerY, innerCircleRadius, innerCircleBgColor);
    }

    function renderInnerTextTask() {
      context.save();
      context.fillStyle = innerTextColor;
      context.font = helper.fontStylesToCanvasFont(innerTextStyle);
      context.textAlign = 'center';
      context.textBaseline = 'middle';
      context.fillText(innerTextContent, centerX, centerY);
      context.restore();
    }

    // ------------------------------------
    // render everything
    // ------------------------------------
    renderOuterTextTask();
    renderBackgroundTask();
    renderInnerCircleTask();
    renderInnerTextTask();

    return canvas.toDataURL();
  }
};

},{"./defaultConfig":3,"./helper":4,"extend":1}],3:[function(require,module,exports){

var is = .40;
module.exports = {
  canvas: {
    width: 130*is,
    height: 130*is
  },
  backgroundShape: {
    backgroundColor: '#ffffff',
    circle: {
      radius: 35*is
    },
    triangle: {
      width: 16*is,
      height: 26*is
    }
  },
  innerCircle: {
    radius: 30*is,
    backgroundColor: '#fe7e55'
  },
  innerText: {
    content: '',
    color: '#ffffff',
    style: {
      fontStyle: 'normal',
      fontVariant: 'normal',
      fontWeight: 'normal',
      fontSize: 50*is+'px/normal',
      fontFamily: 'sans-serif'
    }
  },
  outerText: {
    content: '',
    color: '#ffffff',
    style: {
      fontStyle: 'normal',
      fontVariant: 'normal',
      fontWeight: 'normal',
      fontSize: 30*is+'px/normal',
      fontFamily: 'sans-serif'
    },
    padding: 8*is,
    arc: 180
  }
};


},{}],4:[function(require,module,exports){
var api = {};

/**
 * @param {CanvasRenderingContext2D} context
 * @param {Number} centerX
 * @param {Number} centerY
 * @param {Number} radius
 * @param {String} bgColor
 */
api.drawCircle = function(context, centerX, centerY, radius, bgColor) {
  context.save();
  context.fillStyle = bgColor;

  context.beginPath();
  context.arc(centerX, centerY, radius, 0, Math.PI / 180 * 360, true);
  context.closePath();

  context.fill();
  context.restore();
};

/**
 * @param {CanvasRenderingContext2D} context
 * @param {Array} points
 * @param {String} bgColor
 */
api.drawPath = function(context, points, bgColor) {
  context.save();
  context.fillStyle = bgColor;

  context.beginPath();
  var count = points.length;
  for (var i = 0; i < count; i++) {
    if (i === 0) {
      context.moveTo(points[i].x, points[i].y);
      continue;
    }
    context.lineTo(points[i].x, points[i].y);
  }
  context.closePath();

  context.fill();
  context.restore();
};

/**
 * @param {Object} styles
 * @returns {String}
 */
api.fontStylesToCanvasFont = function(styles) {
  return [
    styles.fontStyle || 'normal',
    styles.fontVariant || 'normal',
    styles.fontWeight || 'normal',
    styles.fontSize || '',
    styles.fontFamily || ''
  ].join(' ');
};

/**
 * @param {CanvasRenderingContext2D} context
 */
api.startShadow = function(context) {
  context.save();
  context.shadowColor = 'rgba(0, 0, 0, 0.5)';
  context.shadowBlur = 3;
  context.shadowOffsetX = 2;
  context.shadowOffsetY = 2;
};

/**
 * @param {CanvasRenderingContext2D} context
 */
api.endShadow = function(context) {
  context.restore();
};

module.exports = api;

},{}],5:[function(require,module,exports){
module.exports = require('./builder');

},{"./builder":2}]},{},[5])(5)
});


//# sourceMappingURL=icon-builder.js.map