class Offer::Shopify::ProductUpdater
  include Sidekiq::Worker

  def perform(offer_id)
    Offer::Shopify::UpdateProduct.call(offer_id)
  end
end
