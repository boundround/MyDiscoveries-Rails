class OffersRegion < ActiveRecord::Base
  belongs_to :offer
  belongs_to :region
end
