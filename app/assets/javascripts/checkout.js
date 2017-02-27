$('form.customer_form').card({
    container: '.card-container',
    formSelectors: {
      numberInput: 'input#customer_credit_card_number',
      expiryInput: 'input#customer_credit_card_date',
      cvcInput:    'input#customer_credit_card_cvv',
      nameInput:   'input#customer_credit_card_holder_name'
    }
});
