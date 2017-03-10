namespace :spree do
  desc "create mydiscoveries spree store"
  task create_store: :environment do
    Spree::Store.first_or_create.update(
      name: "MyDiscoveries",
      url: "mydiscoveries.herokuapp.com",
      default_currency: "AUD",
      default: true,
      code: "MD",
      mail_from_address: "info@mydiscoveries.herokuapp.com"
    )
  end
end
