class OffersVideo < ActiveRecord::Base
  belongs_to :offer
  belongs_to :video
end
