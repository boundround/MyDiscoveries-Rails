class Offer::Shopify::ImagesUpdater
  include Sidekiq::Worker

  def perform(offer_id)
    offer = Offer.find_by(id: offer_id)
    return if offer.nil? || offer.shopify_product_id.blank?

    Offer::Shopify::UpdateImages.call(offer)
  end
end
