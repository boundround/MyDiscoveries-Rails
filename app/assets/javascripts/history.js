// Bind to StateChange Event
History.Adapter.bind(window,'statechange',function(){ // Note: We are using statechange instead of popstate
    var State = History.getState(); // Note: We are using History.getState() instead of event.state
    console.log(State);
    var id = State.url.match(/[^=]{1,3}$/);
    if (id) {
      id = id[0];
    }
    console.log(id);
    if (id == 'map') {
      $('.modal').modal('hide');
    } else {
      $('.area-content').empty();
      $('#areaModal').modal();
      $.ajax({
        url: '/places/' + id.shift + ".html",
        success: function(data) {
          $('.area-content').html(data);
          loadIsotope();
          //Vimeo api code
          var iframe = $('.hero-video')[0];
          player = $f(iframe);

          // When the player is ready, add listeners for pause, finish, and playProgress
          player.addEvent('ready', function() {
          });

          // Call the API when a button is pressed
          $('#dropdownMenu1').bind('click', function() {
              player.api('pause');
          });


          //Stop  area video on modal close
          $('#areaModal').on('hidden.bs.modal', function (e) {
            player.api('pause');
          });
        }
      });
      window.lastLoaded = id.shift;
    };

});

// Change our States
// History.pushState({state:1}, "State 1", "?state=1"); // logs {state:1}, "State 1", "?state=1"
// History.pushState({state:2}, "State 2", "?state=2"); // logs {state:2}, "State 2", "?state=2"
// History.replaceState({state:3}, "State 3", "?state=3"); // logs {state:3}, "State 3", "?state=3"
// History.pushState(null, null, "?state=4"); // logs {}, '', "?state=4"
// History.back(); // logs {state:3}, "State 3", "?state=3"
// History.back(); // logs {state:1}, "State 1", "?state=1"
// History.back(); // logs {}, "Home Page", "?"
// History.go(2); // logs {state:3}, "State 3", "?state=3"
