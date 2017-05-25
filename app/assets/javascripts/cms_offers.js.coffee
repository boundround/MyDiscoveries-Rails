jQuery ->
  $('.js-add-offers-tag').on 'click', (e) ->
    e.preventDefault()
    container = $('.offer_tags .controls')
    element   = '<input class="text optional" name="offer[tags][]" type="text" value="">'
    container.append(element)

  $('.js-add-places_visited-tag').on 'click', (e) ->
    e.preventDefault()
    container = $('.offer_places_visited .controls')
    element   = '<input class="text optional" name="offer[places_visited][]" type="text" value="">'
    container.append(element)

  $('#offer_attraction_ids').DualListBox({
    json: false,
    title: 'Attractions'
  });

  $('#offer_place_ids').DualListBox({
    json: false,
    title: 'Places'
  });

  $('#offer_country_ids').DualListBox({
    json: false,
    title: 'Countries'
  });

  $('#offer_subcategory_ids').DualListBox({
    json: false,
    title: 'Subcategories'
  });

  $('#offer_region_ids').DualListBox({
    json: false,
    title: 'Regions'
  });

  $('.js-add-product-departure-dates').on 'click', (e) ->
    e.preventDefault()
    container = $('.departure_dates .departure_datessssss')
    element   = '<label>Month</label>&nbsp;<input class="text optional product_departure_dates_month" name="product[departure_dates][month][]" type="text" value=""> &nbsp;&nbsp;
                 <label>Dates</label>&nbsp;<input class="text optional product_departure_dates_dates" name="product[departure_dates][dates][]" type="text" value=""><br>'
    container.append(element)

    $('.product_departure_dates_month').datepicker
      format: 'yyyy-mm'
      startView: 'months'
      minViewMode: 'months'

    $('.product_departure_dates_month').on 'change', () ->
      strtDt = new Date($(@).val()+'-1')
      $('.product_departure_dates_dates').datepicker('setStartDate', strtDt)

  $('.js-edit-product-departure-dates').on 'click', (e) ->
    $('.product_departure_dates_month').datepicker
      format: 'yyyy-mm'
      startView: 'months'
      minViewMode: 'months'

    $('.product_departure_dates_month').on 'change', () ->
      strtDt = new Date($(@).val()+'-1')
      $('.product_departure_dates_dates').datepicker('setStartDate', strtDt)