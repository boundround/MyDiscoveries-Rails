class Offer::Shopify::UpdateProduct
  include Service

  initialize_with_parameter_assignment :offer

  def call
    set_title
    set_body_html
    set_tags
    set_images
    set_variants
    product.save if product_changed?

    product
  end

  private

  def set_title
    if title_changed?
      product.title = decorated_offer.title
      product_changed!
    end
  end

  def set_body_html
    if decorated_offer.body_html != product.body_html
      product.body_html = decorated_offer.body_html
      product_changed!
    end
  end

  def set_tags
    if decorated_offer.tags != product.tags
      product.tags = decorated_offer.tags
      product_changed!
    end
  end

  def set_variants
    Offer::Shopify::ProductDecorator::AGE_TYPES.each do |type|
      product_variant = product.variants.detect { |v| v.option1 == type }
      offer_variant   = variants.detect { |v| v[:option1] == type }

      if title_changed? || offer_variant[:price].to_f != product_variant.price.to_f
        product_variant.title = offer_variant[:title]
        product_variant.price = offer_variant[:price]

        product_variant.save
      end
    end
  end

  def set_images
    Offer::Shopify::UpdateImages.call(offer)
  end

  def title_changed?
    offer.name != product.title
  end

  def decorated_offer
    @decorated_offer ||= Offer::Shopify::ProductDecorator.call(self)
  end

  def product
    @product ||= decorated_offer.product
  end

  def variants
    @variants ||= decorated_offer.variants
  end

  def product_changed?
    @changed ||= false
  end

  def product_changed!
    @changed = true
  end
end
