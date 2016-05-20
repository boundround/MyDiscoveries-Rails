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
//= require bootstrap-sprockets
//= require bootsy
//= require jquery-fileupload/basic
//= require jquery-fileupload/vendor/tmpl
//= require jquery.MultiFile
//= require bootstrap-datepicker
//= require area
//= require jquery.raty-fa
//= require places
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require cms
//= require geocomplete
//= require cookie
//= require like
//= require ratyrate
//= require user-photo-upload
//= require algoliasearch
//= require algoliasearchhelper
//= require hogan
//= require algolia_search
//= require gmaps.min
//= require owl.carousel.min 
//= require svg-injector.min 
//= require smooth-scroll.min
//= require readmore.min 
//= require jquery.sticky
//= require main
//= require destination
//= require thing
//= require home-new-design
//= require jquery.confirm.min
//= require chart.min
//= require jquery.iframe-transport 
//= require jquery.ui.widget.js 
//= require handlebars.runtime.js
//= require medium-editor.min
//= require medium-editor-insert-plugin.min
//= require jquery-sortable-min.js
//= require boundround
//= require jquery.snowshoe
//= require dual_list_box
//= require jquery_nested_form
//= require blueimp-gallery.min

$(document).on('ajax:beforeSend', 'a.single-pagination', function() {
    container = $(this).closest('div.single-pagination-container');
    container.find('div.single-pagination-loader').removeClass('hidden');
    $(this).addClass('hidden');
}).on('ajax:success', 'a.single-pagination', function() {
    container = $(this).closest('div.single-pagination-container');
    container.find('div.single-pagination-loader').addClass('hidden');
    $(this).removeClass('hidden');
}).on('ajax:error', 'a.single-pagination', function() {
    container = $(this).closest('div.single-pagination-container');
    container.find('div.single-pagination-loader').addClass('hidden');
    $(this).removeClass('hidden');
});

$(document).ready(function() {

    $(document).on('click', '.play-in-modal', function(e) {
        showAndPlayVideoOnModal($(this))
    });

    $('div.video-modal').on('hide.bs.modal', function(e) {
        $(this).find('iframe').attr('src', null);
    });

    $('div.modal-video').on('hide.bs.modal', function(e) {
        $(this).find('iframe').attr('src', null);
    });

    $(document).on('click', 'a.play-video', function(e) {
        div = $(this).closest('div');
        video = div.find('.play-in-modal');
        showAndPlayVideoOnModal($(video))
        e.preventDefault();
    })

});

function showAndPlayVideoOnModal(video) {
    modal = video.data('modal');
    vid_src = video.data('video-url');
    $(modal).modal('show');
    $(modal + ' iframe').attr('src', vid_src + '?autoplay=1');
}
