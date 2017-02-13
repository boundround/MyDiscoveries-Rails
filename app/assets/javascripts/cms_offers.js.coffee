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
