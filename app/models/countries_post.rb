class CountriesPost < ActiveRecord::Base
  belongs_to :country
  belongs_to :post
end
