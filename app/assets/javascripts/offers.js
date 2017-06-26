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

// Find which stickers that are currently "checked"
// Load the array of sticker_ids into a tmp variable
// If box is checked or unchecked change the content of array
// Then submit the changes on the form
// Additionally, if length of this array is == 2 then user can no longer tick another Checkbox

function chooseStickers() {
  var arr = [];
  $('#sticker_form input[type=checkbox]').click(function() {
        console.log(this.value);
        if($(this).prop("checked") == true){
          var i = 0;
          console.log("Checkbox is checked.");
          arr.push(this.value);
          console.log(arr);
          i = arr.indexOf(this.value);
          console.log(i);
        }
        else if($(this).prop("checked") == false){
          console.log("Checkbox is unchecked.");
          arr.splice(arr.indexOf(this.value), 1);
          console.log(arr);
          i = arr.indexOf(this.value);
          console.log(i);
        };
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
