
json.options do
  if !@product.disable_maturity?
    json.maturities do
      json.array! @variants.map{ |v| v.maturity }.compact.uniq
    end
  end
  if !@product.disable_bed_type?
    json.bed_types do
      json.array! @variants.map{ |v| v.bed_type }.compact.uniq
    end
  end
  if !@product.disable_room_type?
    json.room_types do
      json.array! @variants.map{ |v| v.room_type }.compact.uniq
    end
  end
  if !@product.disable_departure_city?
    json.departure_cities do
      json.array! @variants.map{ |v| v.departure_city }.compact.uniq
    end
  end
  if !@product.disable_departure_date?
    json.departure_dates do
      json.array! @variants.map{ |v| v.departure_date.try(:to_date).try(:to_s) }.uniq
    end
  end
  if !@product.disable_package_option?
    json.package_options do
      json.array! @variants.map{ |v| v.package_option }.compact.uniq
    end
  end
  if !@product.disable_accommodation?
    json.accommodations do
      json.array! @variants.map{ |v| v.accommodation }.compact.uniq
    end
  end

  if @options_selected
    json.variant_id @variants.last.id
    json.price sprintf('%.2f', @variants.last.price)
    json.monthly_price sprintf('%.2f', @variants.last.monthly_price)
  end
end
