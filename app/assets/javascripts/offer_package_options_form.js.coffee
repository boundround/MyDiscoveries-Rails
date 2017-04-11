jQuery(window).load ->
  $('.book-now').removeClass('hidden') if $('.book-now').hasClass('hidden')

  offer_id = $('.package-options-form').data('offerId')
  prompt_text = 'Please Select'
  $('.js-variant-option').on 'change', (e) ->
    bed_type       = $('#order_populate_bed_type').val()
    maturity       = $('#order_populate_maturity').val()
    departure_city = $('#order_populate_departure_city').val()

    $.ajax "/offers/#{offer_id}/variants/fill_packages_options.json",
      type: 'POST'
      data:
        bed_type:       bed_type
        maturity:       maturity
        departure_city: departure_city
      dataType: 'json'
      success: (data) ->
        update_options(data)
        update_conclusions(bed_type, maturity, departure_city)
        update_quantity()
        update_submit_button()
        update_variant_id(data['options']['variant_id'])
        update_current_price(data['options']['price'], data['options']['monthly_price'])

  update_options = (params) ->
    update_option(params['options']['bed_types'], $('#order_populate_bed_type'))
    update_option(params['options']['maturities'], $('#order_populate_maturity'))
    update_option(params['options']['departure_cities'], $('#order_populate_departure_city'))

  update_conclusions = (bed_type, maturity, departure_city) ->
    if options_selected()
      value = "#{departure_city}, #{maturity}, #{bed_type}"
      $('.js-selected-variants-options').html("Selection: #{value}")
    else
      $('.js-selected-variants-options').html("Selection: ")

  $(document).ajaxStart(() ->
    $('.js-variant-option, .js-submit-button').prop('disabled', true)
  ).ajaxStop () ->
    $('.js-variant-option, .js-submit-button').prop('disabled', false)

  update_option = (values, element) ->
    selected = element.val()
    prompt   = "<option value=>#{prompt_text}</option>"
    element.html('')
    element.append(prompt)

    if values.length
      for value in values
        option = "<option value='#{value}'>#{value}</option>"
        element.append(option)

    element.val(selected)

  update_quantity = () ->
    if options_selected()
      if $(".js-variant-quantity").hasClass('hidden')
        $(".js-variant-quantity").removeClass('hidden')
    else
      if !$(".js-variant-quantity").hasClass('hidden')
        $(".js-variant-quantity").addClass('hidden')
      $("#order_populate_quantity").val(0)

  update_submit_button = () ->
    if options_selected() && parseInt($("#order_populate_quantity").val()) > 0
      $('.js-submit-button').prop('disabled', '')
      $('.js-submit-button').prop('hidden', '')
    else
      $('.js-submit-button').prop('hidden', 'hidden')
      $('.js-submit-button').prop('disabled', 'disabled')

  options_selected = () ->
    $('#order_populate_bed_type').val().length &&
    $('#order_populate_maturity').val().length &&
    $('#order_populate_departure_city').val().length

  update_variant_id = (variant_id) ->
    if variant_id != undefined && options_selected()
      $('#order_populate_variant_id').val(variant_id)
    else
      $('#order_populate_variant_id').val('')

  update_current_price = (price, monthly_price) ->
    if price && monthly_price
      window.price = parseFloat(price)
      window.monthly_price = parseFloat(monthly_price)
    else
      window.price = 0
      window.monthly_price = 0
      update_price(0)

  $('#order_populate_quantity').on 'keyup change', (e) ->
    value = parseInt($('#order_populate_quantity').val())
    update_price(value)
    update_submit_button()


  update_price = (quantity) ->
    allow_installments = $('.package-options-form').data('allowInstallments')
    if window.price > 0
      if !$('.js-price-range').hasClass('hidden')
        $('.js-price-range').addClass('hidden')
      total_price = quantity * window.price
      $('.js-total-price').html("Price: $#{total_price.toFixed(2)}")
      if $('.js-total-price').hasClass('hidden')
        $('.js-total-price').removeClass('hidden')
    else
      if $('.js-price-range').hasClass('hidden')
        $('.js-price-range').removeClass('hidden')
      if !$('.js-total-price').hasClass('hidden')
        $('.js-total-price').addClass('hidden')


    if allow_installments && window.monthly_price > 0
      if $('.js-request-installments').hasClass('hidden')
        $('.js-request-installments').removeClass('hidden')
      monthly_price = quantity * window.monthly_price
      monthly_label = "Or 5 monthly payments of $#{monthly_price.toFixed(2)}"
      $('.js-order-monthly-price').html(monthly_label)
    else
      if !$('.js-request-installments').hasClass('hidden')
        $('.js-request-installments').addClass('hidden')
