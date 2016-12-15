class Order::Shopify::GetCheckoutUrl
  include Service

  AGE_TYPE_TO_QUANTITY_COLUMN_MAPPING = [
    ['Adult', :number_of_adults],
    ['Child', :number_of_children],
    ['Infant', :number_of_infants]
  ]

  initialize_with_parameter_assignment :order

  # https://help.shopify.com/themes/customization/cart/use-permalinks-to-preload-cart
  def call
    "https://#{ENV['SHOPIFY_STORE_DOMAIN']}/cart/#{query}"
  end

  private

  def query
    variant_ids_with_not_zero_quantities.map do |variant_id, quantity|
      "#{variant_id}:#{quantity}"
    end.join(',')
  end

  def variant_ids_with_not_zero_quantities
    variant_ids_with_quantities.select { |_, quantity| quantity != 0 }
  end

  def variant_ids_with_quantities
    AGE_TYPE_TO_QUANTITY_COLUMN_MAPPING.map do |age_type, quantity_column|
      [variant(age_type).id, order.send(quantity_column)]
    end
  end

  def variant(age_type)
    order.offer.shopify_product.variants.detect do |variant|
      variant.option1 == age_type
    end
  end
end
