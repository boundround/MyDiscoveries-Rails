$(document).ready(function(){

    "use strict";

    $('.new-colour').click(function(e){

        e.preventDefault();

        var id = $(this).attr('href');
        var style = ('#switch-style');

        $(style).attr('href', 'css/colour-scheme/' + id + '.css');

        $('.style-switcher').toggleClass('style-out');

    });

    $('.style-open').click(function(e){

    	e.preventDefault();

    	$('.style-switcher').toggleClass('style-out');

    });

});
