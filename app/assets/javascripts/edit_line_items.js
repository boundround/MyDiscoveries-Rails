$(document).ready(function(){
	var add_ons, add_ons_data, line_item_id;
	add_ons = document.querySelector('.line_item_update_add_ons');
	if (add_ons) {
		$(add_ons).on('change', function(){
			line_item_id = $(this).data('line-item-id');
			add_ons_data = $("input[name=add_ons]:checked").map(function(){
														return this.value;
													}).get();
			$.ajax({
				url: '/orders/' + $('.order-info').data('number') + '/update_add_ons',
				type: 'get',
				data: { line_item_id: line_item_id, add_on_ids: add_ons_data },
				success: function(){
					location.reload();
				}
			});
		});
	}
})