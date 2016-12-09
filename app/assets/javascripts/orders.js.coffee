jQuery ->
  infants_price  = $('#order_total_price').data('infantsPrice')
  children_price = $('#order_total_price').data('childrenPrice')
  adults_price   = $('#order_total_price').data('adultsPrice')

  $('.js-order-people-count').on 'keyup', (e) ->
    recalculate_total_price()

  recalculate_total_price = () ->
    total = (parseInt($('#order_number_of_infants').val()) || 0) *  infants_price +
            (parseInt($('#order_number_of_children').val()) || 0) * children_price +
            (parseInt($('#order_number_of_adults').val()) || 0) *   adults_price

    $('#order_total_price').val(total)
    $('.js-order-total-price').html("#{total}$)")

  recalculate_total_price()
