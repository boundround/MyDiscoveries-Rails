module OrdersHelper
  def unit_price(price, adult_price)
    price.nil? ? adult_price : price
  end

  def people_count_label(offer)
    if !offer.minUnits.to_i.zero? && !offer.maxUnits.to_i.zero?
      "(Minimum people count: #{offer.minUnits}, Maximum people count: #{offer.maxUnits})"
    elsif !offer.minUnits.to_i.zero?
      "(Minimum people count: #{offer.minUnits})"
    elsif !offer.maxUnits.to_i.zero?
      "(Maximum people count: #{offer.maxUnits})"
    else
      ""
    end
  end

  def variant_prices(variants)
    variants.map do |v|
      {
        id:            v.id,
        price:         v.price,
        monthly_price: v.monthly_price
      }
    end
  end

  def total_line_items_price(line_items)
    line_items.map{ |li| li.quantity * li.price }.reduce(:+)
  end

  def total_line_item_price(line_item)
    line_item.quantity * line_item.price
  end
end
