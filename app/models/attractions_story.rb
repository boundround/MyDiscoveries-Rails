class AttractionsStory < ActiveRecord::Base
  belongs_to :attraction
  belongs_to :post
end
