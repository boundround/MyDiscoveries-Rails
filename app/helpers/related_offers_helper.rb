module RelatedOffersHelper
  def array_related_offer_ids(related_offers)
    related_ids = []
    related_offers.each do |related_offer|
      if !related_offer.spree_related_product_id.blank?
        offer = Spree::Product.find(related_offer.spree_related_product_id)
        related_ids.push({offer_id: offer.id, offer_name: offer.name})
      end
    end
    related_ids.to_json
  end
end
