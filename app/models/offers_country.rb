class OffersCountry < ActiveRecord::Base
  belongs_to :offer
  belongs_to :country
end
