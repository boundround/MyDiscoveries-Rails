(function(){
	var order_number, variant_id, line_item_id;
	$('.order_line_item_variant_id').on('change', function(){
		line_item_id = $(this).data('line-item-id');
		variant_id = this.value;
		order_number = $(this).data('order-number');
		$.ajax({
			type: 'get',
			url: '/orders/' + order_number + '/update_line_items',
			data: {line_item_id: line_item_id, variant_id: variant_id},
			success: function(){
				location.reload();
			}
		});
	})
})()