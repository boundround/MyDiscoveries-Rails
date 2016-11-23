jQuery ->
  $('.js-add-offers-tag').on 'click', (e) ->
    e.preventDefault()
    container = $('.offer_tags .controls')
    element   = '<input class="text optional" name="offer[tags][]" type="text" value="">'
    container.append(element)
