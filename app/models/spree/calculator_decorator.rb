module Spree
  class Calculator::FlexiRatePerItem < Calculator
    preference :amount, :decimal, default: 0
    preference :currency, :string, default: ->{ Spree::Config[:currency] }

    def compute(object)
      promoted_product_ids = calculable&.promotion&.products&.map(&:id) || []
      return if promoted_product_ids.blank?

      promoted_line_items = object.line_items.select do |line_item|
        promoted_product_ids.include?(line_item.product.id)
      end

      return if promoted_line_items.blank?

      promoted_line_items.inject(0) { |acc, item| acc+= item.quantity } * preferred_amount
    end
  end
end
