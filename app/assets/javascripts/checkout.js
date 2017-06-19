$('form.customer_form').card({
    container: '.card-container',
    formSelectors: {
      numberInput: 'input.credit_card_number',
      expiryInput: 'input.credit_card_date',
      cvcInput:    'input.credit_card_cvv',
      nameInput:   'input.credit_card_name'
    }
});
