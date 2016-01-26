class PlacesPriceCategory < ActiveRecord::Base
  belongs_to :price_category
  belongs_to :place
end
