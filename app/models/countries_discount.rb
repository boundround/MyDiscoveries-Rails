class CountriesDiscount < ActiveRecord::Base
  belongs_to :country
  belongs_to :discount
end
