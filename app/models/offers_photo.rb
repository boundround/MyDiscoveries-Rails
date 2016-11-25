class OffersPhoto < ActiveRecord::Base
  belongs_to :offer
  belongs_to :photo
end
