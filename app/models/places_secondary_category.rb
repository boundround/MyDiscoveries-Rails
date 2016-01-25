class PlacesSecondaryCategory < ActiveRecord::Base
  belongs_to :secondary_category
  belongs_to :place
end
