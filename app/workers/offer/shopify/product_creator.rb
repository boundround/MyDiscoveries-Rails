class Offer::Shopify::ProductCreator
  include Sidekiq::Worker

  def perform(offer_id)
    offer = Offer.find_by(id: offer_id)
    return if offer.nil?

    Offer::Shopify::CreateProduct.call(offer)
  end
end
