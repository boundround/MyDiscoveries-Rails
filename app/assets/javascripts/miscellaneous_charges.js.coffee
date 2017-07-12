jQuery ->
  $('#selected_order').prop('disabled', true)
  $('#order_type_new_order').on 'change', (e) ->
    $('#selected_order').prop('disabled', true)
    if !$('.selected-order-form').hasClass('hidden')
      $('.selected-order-form').addClass('hidden')

  $('#order_type_created_order').on 'change', (e) ->
    $('#selected_order').prop('disabled', false)
    if $('.selected-order-form').hasClass('hidden')
      $('.selected-order-form').removeClass('hidden')
