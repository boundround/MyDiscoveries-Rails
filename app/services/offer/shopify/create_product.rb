class Offer::Shopify::CreateProduct
  include Service

  AGE_TYPES = ['Adult', 'Child', 'Infant']

  initialize_with_parameter_assignment :offer

  def call
    product              = ShopifyAPI::Product.new
    product.title        = offer.name
    product.body_html    = offer.highlightsStr
    product.vendor       = offer.livn_product_id? ? 'LIVN' : 'Bound Round'
    product.product_type = 'Tour'
    product.images       = images
    product.tags         = tags
    product.variants     = variants

    offer.update(shopify_product_id: product.id) if product.save

    product
  end

  private

  def images
    offer.photos.map do |photo|
      if photo.hero?
        { src: photo.path.url, position: 1 }
      else
        { src: photo.path.url }
      end
    end
  end

  def tags
    offer.tags.join(', ') if offer.tags.present?
  end

  def variants
    adult_price = offer.maxRateAdult
    AGE_TYPES.map do |type|
      {
        price:             offer.send("maxRate#{type}") || adult_price,
        requires_shipping: false,
        title:             "#{offer.name} - #{type}",
        option1:           type
      }
    end
  end
end
