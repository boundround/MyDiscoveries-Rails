module PromotionsHelper
  def product_promotion_rule?(promotion)
    promotion.promotion_rules.first&.respond_to?(:products)
  end
end
