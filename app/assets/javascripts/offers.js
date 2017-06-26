(function () {

    "use strict";

    function init() {

        $('.js-show-hide-info-block').on('click', function () {
            $(this).parent().toggleClass('deal-data-card--open-card');
        });

    }

    $(window).on('load', init);

}());

(function(win, doc) {

    "use strict";

    $(win).on('load', function() {
        // scroll to node on click
        function onClickScrollToNode(e) {

            var node = e.currentTarget,
                selector = '.' + node.getAttribute('data-js-scroll-to'),
                targetNode = doc.querySelector(selector);

            targetNode.scrollIntoView();

        }

        var $nodes = $('.js-scroll-to-node');

		$nodes.each(function() {
			$(this).on('click', onClickScrollToNode)
		});

    });

}(window, window.document));

function chooseStickers() {
  $('#sticker_form input[type=checkbox]').click(function() {
        alert("checkbox ticked");
  });
}

$(document).ready(function() {
  $(".readmore-area").click(function(event) {
    $(".offer-desc").toggle();
    $(this).text(function(i, text){
      text === "SHOW MORE" ? "LESS" : "SHOW MORE";
    })
  });

  chooseStickers();
});
