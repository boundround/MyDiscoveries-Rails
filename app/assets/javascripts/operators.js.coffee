jQuery ->
  $('.js-add-operator-tag').on 'click', (e) ->
    e.preventDefault()
    container = $('.operator_tags .controls')
    element   = '<input class="text optional" name="operator[tags][]" type="text" value="">'
    container.append(element)
