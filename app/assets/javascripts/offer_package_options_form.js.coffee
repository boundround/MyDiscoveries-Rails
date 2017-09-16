jQuery(window).load ->
  load_product_options = () ->
    $('.modal-guest-sign-up-content').hide()
    $('.book-now').removeClass('hidden') if $('.book-now').hasClass('hidden')

    offer_id          = $('.package-options-form').data('offerId')
    prompt_text       = 'Please Select'
    user_signed_in    = $('form.package-options-form').data('userSignedIn')

    room_type_present = $('form.package-options-form').data('roomTypePresent')
    bed_type_present  = $('form.package-options-form').data('bedTypePresent')
    maturity_present  = $('form.package-options-form').data('maturityPresent')
    departure_city_present  = $('form.package-options-form').data('departureCityPresent')
    package_option_present  = $('form.package-options-form').data('packageOptionPresent')
    departure_date_present  = $('form.package-options-form').data('departureDatePresent')
    accommodation_present  = $('form.package-options-form').data('accommodationPresent')

    $('.js-variant-option').on 'change', (e) ->
      departure_city = if departure_city_present
        $('#order_populate_departure_city').val()
      else
        ''
      package_option = if package_option_present
        $('#order_populate_package_option').val()
      else
        ''
      departure_date = if departure_date_present
        $('#order_populate_departure_date').val()
      else
        ''
      accommodation = if accommodation_present
        $('#order_populate_accommodation').val()
      else
        ''
      room_type = if room_type_present
        $('#order_populate_room_type').val()
      else
        ''
      bed_type = if bed_type_present
        $('#order_populate_bed_type').val()
      else
        ''
      maturity = if maturity_present
        $('#order_populate_maturity').val()
      else
        ''

      $.ajax "/offers/#{offer_id}/variants/fill_packages_options.json",
        type: 'POST'
        data:
          departure_city: departure_city
          accommodation:  accommodation
          departure_date: departure_date
          package_option: package_option
          room_type:      room_type if room_type_present
          bed_type:       bed_type  if bed_type_present
          maturity:       maturity  if maturity_present

        dataType: 'json'
        success: (data) ->
          console.log(data)
          update_options(data)
          update_conclusions(bed_type, maturity, departure_city, room_type, departure_date, package_option, accommodation)
          update_quantity()
          update_submit_button()
          update_variant_id(data['options']['variant_id'])
          update_current_price(data['options']['price'], data['options']['monthly_price'])

    update_options = (params) ->
      if departure_date_present
        update_option(params['options']['departure_dates'], $('#order_populate_departure_date'))
      if package_option_present
        update_option(params['options']['package_options'], $('#order_populate_package_option'))
      if accommodation_present
        update_option(params['options']['accommodations'], $('#order_populate_accommodation'))
      if departure_city_present
        update_option(params['options']['departure_cities'], $('#order_populate_departure_city'))
      if room_type_present
        update_option(params['options']['room_types'], $('#order_populate_room_type'))
      if bed_type_present
        update_option(params['options']['bed_types'], $('#order_populate_bed_type'))
      if maturity_present
        update_option(params['options']['maturities'], $('#order_populate_maturity'))

    update_conclusions = (bed_type, maturity, departure_city, room_type, departure_date, package_option, accommodation) ->
      if options_selected()
        value = ""
        if departure_city_present
          value += "#{departure_city},"
        if package_option_present
          value += " #{package_option},"
        if accommodation_present
          value += " #{accommodation},"
        if departure_date_present
          value += " #{departure_date},"
        if room_type_present
          value += " #{room_type},"
        if maturity_present
          value += " #{maturity},"
        if bed_type_present
          value += " #{bed_type}"

        value = value.replace(/,\s*$/, "");
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
      room_type = false
      maturity = false
      bed_type = false
      departure_city = false
      departure_date = false
      accommodation = false
      package_option = false

      if room_type_present
        room_type = $('#order_populate_room_type').val().length
      else
        room_type = true

      if maturity_present
        maturity = $('#order_populate_maturity').val().length
      else
        maturity = true

      if bed_type_present
        bed_type = $('#order_populate_bed_type').val().length
      else
        bed_type = true

      if package_option_present
        package_option = $('#order_populate_package_option').val().length
      else
        package_option = true

      if accommodation_present
        accommodation = $('#order_populate_accommodation').val().length
      else
        accommodation = true

      if departure_date_present
        departure_date = $('#order_populate_departure_date').val().length
      else
        departure_date = true

      if departure_city_present
        departure_city = $('#order_populate_departure_city').val().length
      else
        departure_city = true

      departure_city && departure_date && accommodation && package_option && bed_type && maturity && room_type

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

    $('form.package-options-form').submit (e) ->
      e.preventDefault();
      if !user_signed_in
        $("#guestModal").modal()
      else
        submit_offer_form()

    $('.js-submit-current-offer').on 'click', (e) ->
      e.preventDefault()
      submit_offer_form()

    $('.js-show-sign-in').on 'click', (e) ->
      e.preventDefault()
      $('.modal-guest-sign-up-content').hide()
      $('.modal-guest-sign-in-content').show()

    $('.js-show-sign-up').on 'click', (e) ->
      e.preventDefault()
      $('.modal-guest-sign-in-content').hide()
      $('.modal-guest-sign-up-content').show()

    $('.js-submit-guest-sign-in-form').on 'click', (e) ->
      e.preventDefault()
      if ajax_offer_form()['success']
        $('form.guest-sign-in-form')[0].submit()

    $('.js-submit-guest-sign-up-form').on 'click', (e) ->
      e.preventDefault()
      if ajax_offer_form()['success']
        $('form.guest-sign-up-form')[0].submit()

    submit_offer_form = () ->
      $('form.package-options-form')[0].submit()

    ajax_offer_form = () ->
      $.ajax
        type: 'POST',
        url:  $('form.package-options-form').attr("action"),
        data: $('form.package-options-form').serialize(),
        error: (jqXHR, text_status, error_thrown) ->
          return {
            success: false,
            status:  text_status
          }
        success: (message) ->
          return {
            success: true,
            status:  message
          }

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
  window.load_product_options = load_product_options
  load_product_options()
