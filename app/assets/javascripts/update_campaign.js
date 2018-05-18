$('#campaign-code-field').on('change', function() {
    if ($('#campaign-code-field option:selected').val() === "7") {
        $("#others-code-field").removeClass("hidden");
    } else {
        $("#others-code-field").addClass("hidden");
    }
})

$('#update-campaign-code').on('click', function() {
    if ($('#campaign-code-field option:selected').val() === "-1") {
        var campaignCode = "none provided";
    } else if ($('#campaign-code-field option:selected').val() === "7") {
        var selectedOthers = $('#campaign-code-field option:selected').text();
        var otherSource = $('#others-input').val();
        var campaignCode = selectedOthers + " " + otherSource;
    } else {
        var campaignCode = $('#campaign-code-field option:selected').text();
    }
    console.log('clicked');
    var data = {};
    var id = $(this).data('order-id');
    data['id'] = id;
    data['campaign_code'] = campaignCode;

    $.ajax({
        type: 'get',
        url: '/orders/' + id + '/update_campaign_code',
        data: data
    }).done(function(){window.location = '/checkout'});
})