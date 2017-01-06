class Offer::Shopify::CreateProduct
  include Service

  initialize_with_parameter_assignment :offer

  def call
    decorated_offer      = Offer::Shopify::ProductDecorator.new(self)
    product              = decorated_offer.product
    product.title        = decorated_offer.title
    product.body_html    = decorated_offer.body_html
    product.vendor       = decorated_offer.vendor
    product.product_type = decorated_offer.product_type
    product.images       = decorated_offer.images
    product.tags         = decorated_offer.tags
    product.variants     = decorated_offer.variants

    offer.update(shopify_product_id: product.id) if product.save
    product
  end
end
