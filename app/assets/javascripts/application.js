// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
// require jquery-ui
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
// require bootstrap-select.min
// require jcarousel.responsive
// require jquery.jcarousel.min
// require jquery.matchHeight-min
// require jquery.touchSwipe.min
// require jquery.bxslider
// require jquery.keep-ratio
// require progressbar
//= require jquery.MultiFile
//= require bootstrap-datepicker
// require countries
//= require area
//= require jquery.raty-fa
//= require places
// require avatarupload
// require user
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require cms
//= require bootsy
//= require bootstrap
// require bootstrap/transition
//= require geocomplete
//= require cookie
//= require like
// require jquery.raty
//= require ratyrate
//= require user-photo-upload
// require ckeditor/init
// require ckeditor/config.js
// require reviews 

//= require algoliasearch
//= require algoliasearchhelper
//= require hogan
//= require algolia_search
// require bug_posts
//= require gmaps.min
//= require owl.carousel.min
// require custom
// require jquery.Jcrop.min
// require places_crop
//= require jquery.confirm.min
//= require chart.min
//= require boundround
// require mix_panel
// require instafeed.min
//= require jquery.snowshoe
//= require stamps
//= require dual_list_box
//= require jquery_nested_form
//= require blueimp-gallery.min
//= require instantsearch.min
//= require instant_search_setup

$(document).on('ajax:beforeSend', 'a.single-pagination', function(){
  container= $(this).closest('div.single-pagination-container');
  container.find('div.single-pagination-loader').removeClass('hidden-lg');
  $(this).addClass('hidden');
}).on('ajax:success', 'a.single-pagination', function(){
  container= $(this).closest('div.single-pagination-container');
  container.find('div.single-pagination-loader').addClass('hidden-lg');
  $(this).removeClass('hidden');
}).on('ajax:error', 'a.single-pagination', function(){
	container= $(this).closest('div.single-pagination-container');
  container.find('div.single-pagination-loader').addClass('hidden-lg');
  $(this).removeClass('hidden');
});

$(document).ready(function(){

	$(document).on('click', 'video.play-in-modal', function(e){
		showAndPlayVideoOnModal($(this))
	});

	$('div.modal-video').on('hidden.bs.modal', function(e){
		$(this).find('iframe').attr('src', null);
	});

  $(document).on('click', 'a.play-video', function(e){
    div= $(this).closest('div');
    video= div.find('video.play-in-modal');
    showAndPlayVideoOnModal($(video))
    e.preventDefault();
  })

});

function showAndPlayVideoOnModal(video)
{
  modal= video.data('modal');
  vid_src = video.data('video-url');
  $(modal).modal('show');
  $(modal+' iframe').attr('src', vid_src+'?autoplay=1');
} 