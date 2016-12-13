class Offer::Shopify::CreateProduct
  include Service

  AGE_TYPES = [ 'adult', 'child', 'infant' ]

  initialize_with_parameter_assignment :offer_id

  def call
    assign_offer_fields
    assign_variants
    save_product
    # offer.update_attributes(shopify_product_id: product.id) if save_product
  end

  private

  def product
    @product ||= ShopifyAPI::Product.new
  end

  def offer
    @offer ||= Offer.find(offer_id)
  end

  def assign_offer_fields
    product.title             = offer.name
    product.product_type      = 'Tour'
    product.vendor            = offer.livn_product_id? ? 'LIVN' : 'Bound Round'
  end

  def assign_variants
    product.variants = variants
    # product.options  = [ 'age' ]
  end

  def variants
    @variants ||= AGE_TYPES.map do |type|
      ShopifyAPI::Variant.new(
        price:             offer.send("maxRate#{type.capitalize}".to_sym),
        requires_shipping: false,
        title:             "#{offer.name} - #{type.capitalize}",
        option1: type
      )
    end
  end

  def save_product
    if !product.save
      puts "==================="
      puts product.errors.messages
      puts "====================="
    else
      puts "====================="
      puts product.inspect
      puts "====================="
    end
  end
end
