
json.options do
  json.maturities do
    json.array! @variants.map{ |v| v.maturity.titleize }.uniq
  end
  json.bed_types do
    json.array! @variants.map{ |v| v.bed_type.titleize }.uniq
  end
  json.departure_cities do
    json.array! @variants.map{ |v| v.departure_city.titleize }.uniq
  end
  if @options_selected && @variants.one?
    json.variant_id @variants.last.id
    json.price sprintf('%.2f', @variants.last.price)
    json.monthly_price sprintf('%.2f', @variants.last.monthly_price)
  end
end
