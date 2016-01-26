class PriceCategory < ActiveRecord::Base
  has_many :places_price_categories
  has_many :places, through: :places_price_categories
end
