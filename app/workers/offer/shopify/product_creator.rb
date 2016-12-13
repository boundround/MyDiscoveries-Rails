class Offer::Shopify::ProductCreator
  include Sidekiq::Worker

  def perform(offer_id)
    Offer::Shopify::CreateProduct.call(offer_id)
  end
end
