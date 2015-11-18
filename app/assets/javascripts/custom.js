function responsiveHomeVideo() {

_rowVideo   = $('#rowVideo');
_vdo        = $('#home-background-video');
_window     = $(window).width();
_videoWidth = _vdo.width();
_videoHeight = _vdo.height();

marginLR = 0;
marginTB = 0;

  if (_videoWidth > _window) {
      tmpmargin = _videoWidth -_window;
      marginLR = tmpmargin/2;
  }
  if (_videoHeight > 392) {
      tmpmarginheight = _videoHeight - 392;
      marginTB = tmpmarginheight/2;
  }

    // _vdo.css({ "margin-left": -marginLR , "margin-right": -marginLR, "margin-top":-marginTB , "margin-bottom":-marginTB })  
    _vdo.css({"top":-marginTB})  

}

$(window).resize(function(){
  responsiveHomeVideo()
})

$(document).ready(function(){
  responsiveHomeVideo()
})