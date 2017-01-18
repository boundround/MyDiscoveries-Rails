class Offer::Shopify::ProductDecorator < SimpleDelegator

  AGE_TYPES = ['Adult', 'Child', 'Infant']

  def self.call(offer_service)
    new(offer_service)
  end

  def title
    offer.name
  end

  def body_html
    offer.highlightsStr
  end

  def vendor
    offer.livn_product_id? ? 'LIVN' : 'Bound Round'
  end

  def product_type
    'Tour'
  end

  def product
    @product ||= offer.shopify_product || ShopifyAPI::Product.new
  end

  def images
    # @images ||= offer.photos.active.map do |photo|
    #   offers_photo = photo.offers_photos.find_by(offer: offer)
    #   if photo.hero?
    #     {
    #       src: photo.path.url,
    #       position: 1,
    #       product_id: product.id,
    #       offers_photo_id: offers_photo.id,
    #       shopify_image_id: offers_photo.shopify_image_id
    #     }
    #   else
    #     {
    #       src: photo.path.url,
    #       product_id: product.id,
    #       offers_photo_id: offers_photo.id,
    #       shopify_image_id: offers_photo.shopify_image_id
    #     }
    #   end
    # end
    []
  end

  def tags
    @tags ||= offer.tags.join(', ') if offer.tags.present?
  end

  def variants
    adult_price = offer.maxRateAdult
    @variants ||= AGE_TYPES.map do |type|
      {
        price:             offer.send("maxRate#{type}") || adult_price,
        requires_shipping: false,
        title:             "#{offer.name} - #{type}",
        option1:           type
      }
    end
  end
end
