class OffersPlace < ActiveRecord::Base
  belongs_to :offer
  belongs_to :place
end
