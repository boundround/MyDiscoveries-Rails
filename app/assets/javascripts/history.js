// History.Adapter.bind(window,'statechange',function(){
//   var currentIndex = History.getCurrentIndex();
//   var internal = (History.getState().data._index == (currentIndex - 1));
//   if (!internal) {
//     var State = History.getState();
//     console.log(State);
//     var pathArray = State.url.split( '/' );
//     if (pathArray[pathArray.length - 1] == 'map') {
//       $('.modal').modal('hide');
//     } else {
//       var tempMarkerType = pathArray[pathArray.length - 2].slice(0, -1);
//       setModalContent(tempMarkerType, pathArray[pathArray.length - 1]);
//       $.ajax({
//         url: '/' + pathArray[pathArray.length - 2] + '/' + pathArray[pathArray.length - 1] + ".json",
//         success: function(data) {
//           if (tempMarkerType === 'place') {
//             map.setView([data.place.geolocation_latitude, data.place.geolocation_longitude], transitionzoomlevel);
//           } else {
//             map.setView([data.Centre_latitude, data.Centre_longitude], transitionzoomlevel);
//           }
//         }
//       });
//     };
//     // var id = State.url.match(/[^=]{1,3}$/);
    // if (id) {
    //   id = id[0];
    // }
    // console.log(id);
    // if (id == 'map') {
    //   $('.modal').modal('hide');
    // } else {
    //   setModalContent('place', id);
    // };
//   }
// });


// // Bind to StateChange Event
// History.Adapter.bind(window,'statechange',function(){ // Note: We are using statechange instead of popstate
//     var State = History.getState();
//     console.log(State);
//     var id = State.url.match(/[^=]{1,3}$/);
//     if (id) {
//       id = id[0];
//     }
//     console.log(id);
//     if (id == 'map') {
//       $('.modal').modal('hide');
//     } else {
//       $('.area-content').empty();
//       $('#areaModal').modal();
//       $.ajax({
//         url: '/places/' + id.shift + ".html",
//         success: function(data) {
//           $('.area-content').html(data);
//           loadIsotope();
//           //Vimeo api code
//           var iframe = $('.hero-video')[0];
//           player = $f(iframe);
//
//           // When the player is ready, add listeners for pause, finish, and playProgress
//           player.addEvent('ready', function() {
//           });
//
//           // Call the API when a button is pressed
//           $('#dropdownMenu1').bind('click', function() {
//               player.api('pause');
//           });
//
//
//           //Stop  area video on modal close
//           $('#areaModal').on('hidden.bs.modal', function (e) {
//             player.api('pause');
//           });
//         }
//       });
//       window.lastLoaded = id.shift;
//     };
//
// });
