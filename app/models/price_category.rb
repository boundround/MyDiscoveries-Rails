class PriceCategory < ActiveRecord::Base
  include Parameterizable
  before_save :parameterize_identifier
  has_many :places_price_categories
  has_many :places, through: :places_price_categories
end
