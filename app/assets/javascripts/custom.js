
// //FUNCTION TO GET QUERY PARAMETERS FROM URL
// var QueryString = function () {
//   // This function is anonymous, is executed immediately and
//   // the return value is assigned to QueryString!
//   var query_string = {};
//   var query = window.location.search.substring(1);
//   var vars = query.split("&");
//   for (var i=0;i<vars.length;i++) {
//     var pair = vars[i].split("=");
//         // If first entry with this name
//     if (typeof query_string[pair[0]] === "undefined") {
//       query_string[pair[0]] = decodeURIComponent(pair[1]);
//         // If second entry with this name
//     } else if (typeof query_string[pair[0]] === "string") {
//       var arr = [ query_string[pair[0]],decodeURIComponent(pair[1]) ];
//       query_string[pair[0]] = arr;
//         // If third or later entry with this name
//     } else {
//       query_string[pair[0]].push(decodeURIComponent(pair[1]));
//     }
//   }
//     return query_string;
// }();

// function setUpCarosul(){
//         $("#br15_owl_reviews,#br15_owl_fun_facts,#br15_owl_good").owlCarousel({
//             items:1,
//             itemsDesktopSmall:[1199,1],
//             itemsTablet:[768,1],
//             itemsMobile:[500,1],
//             navigation:true,
//             pagination:false,
//             navigationText: [
//                 "<i class='fa fa-chevron-left'></i>",
//                 "<i class='fa fa-chevron-right'></i>"
//             ]
//         });
//         $("#br15_owl_famous").owlCarousel({
//             items:3,
//             itemsDesktopSmall:[1199,3],
//             itemsTablet:[992,2],
//             itemsTabletSmall:[768,2],
//             itemsMobile:[640,1],
//             pagination:false,
//             navigation : true,
//             navigationText: [
//                 "<i class='fa fa-chevron-left'></i>",
//                 "<i class='fa fa-chevron-right'></i>"
//             ]
//         });
//         $("#br15_owl_video,#br15_owl_nearby,#br15_owl_similar").owlCarousel({
//             items:3,
//             itemsDesktopSmall:[1199,3],
//             itemsTablet:[768,2],
//             itemsMobile:[500,1],
//             navigation:true,
//             pagination:false,
//             navigationText: [
//                 "<i class='fa fa-chevron-left'></i>",
//                 "<i class='fa fa-chevron-right'></i>"
//             ]
//         });
//         $("#br15_owl_photos").owlCarousel({
//             items:3,
//             itemsDesktopSmall:[1199,3],
//             itemsTablet:[768,2],
//             itemsMobile:[500,1],
//             navigation:true,
//             pagination:false,
//             navigationText: [
//                 "<i class='fa fa-chevron-left'></i>",
//                 "<i class='fa fa-chevron-right'></i>"
//             ]
//         });
//         $("#br15_owl_blogs").owlCarousel({
//             items:3,
//             itemsDesktopSmall:[1199,3],
//             itemsTablet:[768,2],
//             itemsMobile:[500,1],
//             navigation:true,
//             pagination:false,
//             navigationText: [
//                 "<i class='fa fa-chevron-left'></i>",
//                 "<i class='fa fa-chevron-right'></i>"
//             ]
//         });
//         $('.br15_instagram,.br15_leaderboard,.br15_reviews,.br15_blog .row .col-sm-6,.br15_about,.br15_about_sidebar ').matchHeight();
//     }

// function responsiveHomeVideo() {

// _rowVideo   = $('#rowVideo');
// _vdo        = $('#home-background-video');
// _window     = $(window).width();
// _videoWidth = _vdo.width();
// _videoHeight = _vdo.height();

// marginLR = 0;
// marginTB = 0;

//   if (_videoWidth > _window) {
//       tmpmargin = _videoWidth -_window;
//       marginLR = tmpmargin/2;
//   }
//   if (_videoHeight > 392) {
//       tmpmarginheight = _videoHeight - 392;
//       marginTB = tmpmarginheight/2;
//   }

//     // _vdo.css({"top":-marginTB})

// }
// function modalCarosul(){

//   $('.br15_img_round_cont.for-img-famous-modal').on('click', function(){

//         var carouselItems = $('.carousel-item');
//         $('.owl-controls').show();
//         if ($("#content-modal-carousel").has(".carousel-item").length === 0) {
//             $.each(carouselItems, function(index){
//                 var newImage = $(carouselItems[index]).clone()
//                     $(newImage).css("height", "100%");
//                     $("#content-modal-carousel").append(newImage);
//             });
//         }
//     $('#carousel-modal').modal("show");
//         $("#content-modal-carousel").owlCarousel({
//             items: 1,
//             autoPlay: false,
//             singleItem:true,
//             stopOnHover:true,
//             pagination:false,
//             navigation: true
//         });

//         var owl = $("#content-modal-carousel").data('owlCarousel');
//         owl.jumpTo($(this).data("slide-number"));
//     });
// }



// function modalVideo(){
//    $(".close").click(function(){
//     $("#video-modal iframe").prop("src","");
//    });

//   $(".embed-responsive.embed-responsive-16by9.for-video-modal").on('click', function(){
//     data_src = $(this).data("src");
//     $("#video-modal iframe").prop("src", data_src);
//     $("#video-modal").modal("show");
//   });
// }

function wpBlogs(){
  $(".cs-blog[data-class='apiblog']").click(function(){
    var id = $(this).data("id");
    var place = $(this).data("place");
    var image = $(this).data("image");
    var place_name = $(this).data("place-name");
    var host = document.location.origin;
    $("#modal-dialog-story").hide();
    $("#modal-dialog-blog").show();
    $("#userStory iframe").prop("src", host+"/wp-blog/"+id+"/"+place);
    $("#userStory .modal-dialog").css("max-width","1120px");
    // $("#frame-blog").prop("src", host+"/wp-blog/"+id+"/"+place);
    // $("#userStory iframe");
    $("#userStory").modal();
    if (window.innerWidth < 600){
      setTimeout(function(){
        $('#userStory iframe').contents().find('.alignleft').css('width', '100%');
      }, 3000);
    }

  });

// function vimeoLoadingThumb(id, url){
//     $.getJSON( url, function( data ) {
//       $.each( data, function( key, val ) {
//         if(key == "thumbnail_url"){
//           $("#video-" + id).attr("src", val);
//         }
//       });
//     });
// }

// function getThumbnail(){
//   var imgthumb = $("img[for='thumb-video']");
//     if (imgthumb.length > 0 ) {
//       $.each(imgthumb, function(key, value){
//         if($(value).prop("src") == ""){
//           var id = $(value).prop("id").split("-")[1];
//           if($(value).prop("data-thumb") == "vimeo"){
//             var url = "https://vimeo.com/api/oembed.json?url=https%3A//vimeo.com/"+id;
//           }else{
//             var url = "http://www.youtube.com/oembed?url=http://www.youtube.com/watch?v="+id+"&format=json";
//           }
//           vimeoLoadingThumb(id, url);
//         }
//       });
//     }
// }
// function onChangeVideo(){
//   $( ".select_video_id" ).change(function() {
//     selectVIdeoId($(this));
//   });
// }
// function selectVIdeoId(_this){
//   if (_this.val() == "Youtube" ){
//           $(".video_vimeo_id").hide();
//           $(".video_youtube_id").show();
//           $(".video_vimeo_id input").val("");
//       }else {
//           $(".video_vimeo_id").show();
//           $(".video_youtube_id").hide();
//           $(".video_youtube_id input").val("");
//       }
// }

// // function wpBlogs(){
// //   $(".cs-blog[data-class='apiblog']").click(function(){
// //     var id = $(this).data("id");
// //     var place = $(this).data("place");
// //     var image = $(this).data("image");
// //     var place_name = $(this).data("place-name");
// //     var host = document.location.origin;
// //     $("#modal-dialog-story").hide();
// //     $("#modal-dialog-blog").show();
// //     $("#userStory iframe").prop("src", host+"/wp-blog/"+id+"/"+place);
// //     $("#userStory .modal-dialog").css("max-width","1120px");
// //     // $("#frame-blog").prop("src", host+"/wp-blog/"+id+"/"+place);
// //     // $("#userStory iframe");
// //     $("#userStory").modal();
// //   });

// //   $('#userStory').on('hidden.bs.modal', function () {
// //     $("#userStory .modal-dialog").css("max-width","830px");
// //     $("#userStory iframe").prop("src","");
// //   });
// // }

// $(window).resize(function(){
//   responsiveHomeVideo();
//   responsiveModalVideo();
// });

// $(document).ready(function(){
//   responsiveHomeVideo();
//   setUpCarosul();
//   modalCarosul();
//   responsiveModalVideo();
//   modalVideo();
//   getThumbnail();
//   selectVIdeoId($( ".select_video_id" ));
//   onChangeVideo();
//   wpBlogs();

//   if (QueryString.video){
//     var video = $('#' + QueryString.video)[0];
//     if (video){
//       data_src = $(video).data("src");
//       $("#video-modal iframe").prop("src", data_src);
//       $("#video-modal").modal("show");
//     }
//   } else if (QueryString.story){
//     var story = $('#blog-' + QueryString.story)[0];
//     if (story){
//       var id = $(story).data("id");
//       var place = $(story).data("place");
//       var image = $(story).data("image");
//       var place_name = $(story).data("place-name");
//       var host = document.location.origin;
//       $("#modal-dialog-story").hide();
//       $("#modal-dialog-blog").show();
//       $("#userStory iframe").prop("src", host+"/wp-blog/"+id+"/"+place);
//       $("#userStory .modal-dialog").css("max-width","1120px");
//       $("#userStory").modal();
//     }
//   }

// });
