jQuery ->
  $('.js-quantity').on 'keyup change', (e) ->
    recalculate_price()

  recalculate_price = () ->
    if $("form.js-order-form").length
      variant_prices     = $("form.js-order-form").data('variantPrices')
      current_variant_id = $('#order_populate_variant_id').val()
      current_variant    = ($.grep variant_prices, (e) ->
        e.id == parseInt(current_variant_id)
      )[0]

      total_price   = (parseInt($('.js-quantity').val()) || 1) *
        parseFloat(current_variant.price)
      monthly_price = (parseInt($('.js-quantity').val()) || 1) *
        parseFloat(current_variant.monthly_price)

      $('.js-order-total-price').html("$#{total_price.toFixed(2)} AUD")
      monthly_label = "Or 5 monthly payments of $#{monthly_price.toFixed(2)}"
      $('.js-order-monthly-price').html(monthly_label)

  $('.form-variants').on 'keyup change', (e) ->
    recalculate_price()

  recalculate_price()

  $('.js-print-vouchers-button').on 'click', (e) ->
    e.preventDefault()
    printContents    = $('.js-print-vouchers').html()
    originalContents = $(document.body).html()
    $(document.body).html(printContents)

    window.print()

    $(document.body).html(originalContents)
