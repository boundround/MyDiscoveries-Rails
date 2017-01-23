class RelatedOffer < ActiveRecord::Base
  belongs_to :offer
  belongs_to :related_offer, class_name: "Offer"
end
