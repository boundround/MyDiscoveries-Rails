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
end
