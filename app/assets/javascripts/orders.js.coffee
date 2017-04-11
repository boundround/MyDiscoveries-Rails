jQuery ->
  infants_price  = $("form.js-order-form").data('infantsPrice')
  children_price = $("form.js-order-form").data('childrenPrice')
  adults_price   = $("form.js-order-form").data('adultsPrice')

  $('.js-order-people-count').on 'keyup click change', (e) ->
    recalculate_price()

  recalculate_price = () ->
    total = (parseInt($('#order_number_of_infants').val()) || 0) *  infants_price +
            (parseInt($('#order_number_of_children').val()) || 0) * children_price +
            (parseInt($('#order_number_of_adults').val()) || 0) *   adults_price

    $('.js-order-total-price').html("$#{total}")

    if $('.js-order-monthly-price')
      monthly_price = (total / 5)
      monthly_label = "Or 5 monthly payments of $#{monthly_price.toFixed(2)}"
      $('.js-order-monthly-price').html(monthly_label)

  recalculate_price()

  $('.js-print-vouchers-button').on 'click', (e) ->
    console.log('hey')
    for_print = $(@).data("toprint")

    console.log(for_print == true)

    e.preventDefault()
    originalContents = $(document.body).html()
    if for_print == true
      $('#for-print').show()
      printContents    = $('#for-print').html()
    else
      printContents    = $('#not-print').html()

    $(document.body).html(printContents)
    $('#for-print').hide()
    
    window.print()


    $(document.body).html(originalContents)
