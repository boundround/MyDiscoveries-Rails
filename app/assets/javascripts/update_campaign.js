$('#update-campaign-code').on('click', function() {
    var data = {};
    var id = $(this).data('order-id');
    data['id'] = id;
    data['campaign_code'] = "Google";
    $.ajax({
        type: 'get',
        url: '/orders/' + id + '/update_campaign_code',
        data: data
    });
    console.log("foo");
})