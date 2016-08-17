$(document).ready(function(){
  // Hide and/or display vimeo or youtube id text fields based on options selected
  if (document.querySelector("#select_video_id")){
    if ($("#select_video_id option:selected").text() === "Youtube"){
      $('#vimeo-block').hide();
    }

    $("#select_video_id").on("change", function(){
      if ($("#select_video_id option:selected").text() === "Youtube"){
        $('#vimeo-block').hide();
        $('#youtube-block').show();
        $("#vimeo-id").val("");
      } else {
        $('#vimeo-block').show();
        $('#youtube-block').hide();
        $("#video_youtube_id").val("");
      }
    });
  }

  // Fill modal with current video selected so user can edit info
  $(".edit-video").on("click", function(e){
    var node = $(this);
    var videoId = $(this).data('video-id');
    if (videoId > 0){
      $.ajax({
        type: "GET",
        url: "/videos/" + videoId + ".json",
        success: function(data){
          $('#video-thumbnail').empty().html("<img id='video-thumbnail' class='width100' src='" + data["vimeo_thumbnail"] + "'>'");
          fillVideoEditModal(node);
        }
      });
    }
  });

  $('#videoEditModal').on('hidden.bs.modal', function (e) {
    emptyVideoEditModal($(this));
  });

  var fillVideoEditModal = function(node){
    $('#youtube-edit-id').val($(node).data("youtube-id"));
    $('#vimeo-edit-id').val($(node).data("vimeo-id"));
    $('#video_edit_priority').val($(node).data("priority"));
    $('#video_edit_status').val($(node).data("status"));
    $('#video_edit_title').val($(node).data("title"));
    $('#video_edit_description').val($(node).data("description"));
    $('#video_edit_transcript').val($(node).data("transcript"));
    $('#edit-video-form').get(0).setAttribute('action', $(node).data("path"));
    if ($(node).data("video-type") === "youtube"){
      $('#vimeo-edit-block').hide();
    } else {
      $('#youtube-edit-block').hide();
    }
  }

  var emptyVideoEditModal = function(node){
    $('#youtube-edit-id').val("");
    $('#vimeo-edit-id').val("");
    $('#video_edit_priority').val("");
    $('#video_edit_status').val("");
    $('#video_edit_title').val("");
    $('#video_edit_description').val("");
    $('#video_edit_transcript').val("");
    $('#vimeo-edit-block').show();
    $('#youtube-edit-block').show();
    $('#edit-video-form').get(0).setAttribute('action', "");
  }

});
