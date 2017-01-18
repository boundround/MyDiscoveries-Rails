class Offer::Shopify::CreateProduct
  include Service

  initialize_with_parameter_assignment :offer

  def call
    product              = decorated_offer.product
    product.title        = decorated_offer.title
    product.body_html    = decorated_offer.body_html
    product.vendor       = decorated_offer.vendor
    product.product_type = decorated_offer.product_type
    product.tags         = decorated_offer.tags
    product.variants     = decorated_offer.variants

    if product.save
      offer.update(shopify_product_id: product.id)
      save_images
    end

    product
  end

  private

  def save_images
    if images.any?
      images.each do |image|
        offers_photo  = OffersPhoto.find(image[:offers_photo_id])
        shopify_image = ShopifyAPI::Image.new(image)
        offers_photo.update(shopify_image_id: shopify_image.id.to_s) if shopify_image.save
      end
    end
  end

  def images
    @images ||= decorated_offer.images
  end

  def decorated_offer
    @decorated_offer ||= Offer::Shopify::ProductDecorator.new(self)
  end
end
