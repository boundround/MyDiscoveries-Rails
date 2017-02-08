# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
  :password,
  :credit_card_number,
  :credit_card_holder_name,
  :credit_card_date,
  :credit_card_cvv
]
