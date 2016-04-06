class PlacesPost < ActiveRecord::Base
  belongs_to :place
  belongs_to :post
end
