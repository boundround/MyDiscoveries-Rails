class OffersAttraction < ActiveRecord::Base
  belongs_to :offer
  belongs_to :attraction
end
