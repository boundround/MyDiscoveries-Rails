var resize = function()
{
    $('body').removeClass('landscape').removeClass('portrait').addClass(orientation).css('width', $(window).width() + 'px');
}

var orientation = null;

var onOrientationChange = function ()
{
    switch(window.orientation) {
        case -90:
        case 90:
            orientation = 'landscape';
            break;
        default:
            orientation = 'portrait';
            break;
    }
    
    if(screen.width < 768) {
        if(orientation == 'landscape') {
            var scale = Math.round(screen.height / 600 * 10) / 10;
            $('#meta-viewport').attr('content', 'width=600px, initial-scale='+scale+', maximum-scale='+scale+', minimum-scale='+scale+', user-scalable=no'); // landscape mobile
        } else {
            var scale = Math.round(screen.width / 400 * 10) / 10;
            $('#meta-viewport').attr('content', 'width=400px, initial-scale='+scale+', maximum-scale='+scale+', minimum-scale='+scale+', user-scalable=no'); // portrait mobile
        }
    } else if(screen.width >= 768 && screen.width < 1200) {
        var scale = Math.round(screen.width / 960 * 10) / 10;
        $('#meta-viewport').attr('content', 'width=960px, initial-scale='+scale+', maximum-scale='+scale+', minimum-scale='+scale+', user-scalable=no');
    } else if(screen.width >= 1200) {
        $('#meta-viewport').attr('content', 'width=device-width, user-scalable=yes');
    }
    
    resize();
}

$(document).ready(function()
                  {
                  $(window).resize(resize);
                  $(window).bind('orientationchange', onOrientationChange);
                  onOrientationChange();
});