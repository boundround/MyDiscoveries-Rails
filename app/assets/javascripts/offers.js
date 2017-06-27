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
// Additionally, if length of this array is == 2 then user can no longer tick another Checkbox
// Then submit the changes on the form
$(document).ready(function() {
  $(".readmore-area").click(function(event) {
    $(".offer-desc").toggle();
    $(this).text(function(i, text){
      text === "SHOW MORE" ? "LESS" : "SHOW MORE";
    })
  });

  var arr_checked = [];
  var sticker_form = $('#sticker_form input[type=checkbox]');

  $(sticker_form).each(function(){
    if(this.checked == true){
      arr_checked.push(this.value);
    }
  });

  function disableCheckboxes(array){
    if (array.length >=2){
      $('#sticker_form input[type=checkbox]').not(":checked").attr("disabled",true);
    }else {
      $('#sticker_form input[type=checkbox]').not(":checked").attr("disabled",false);
    };
  }

  function chooseStickers() {
    var arr = arr_checked;
    disableCheckboxes(arr);

    $('#sticker_form input[type=checkbox]').click(function() {
      if($(this).prop("checked") == true){
        arr.push(this.value);
        disableCheckboxes(arr);
      } else if($(this).prop("checked") == false){
        arr.splice(arr.indexOf(this.value), 1);
        disableCheckboxes(arr);
      };
      $('#sticker_button').trigger('click');
    });
  };
  chooseStickers();
});
