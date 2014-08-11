$(document).ready(function(){
    $('.caption').on("keypress", function(){
        var len = $(this).val().length;
        $(this).closest('.control-group').next('.charCount').text(140 - len);
    });
});
