class SimilarPlace < ActiveRecord::Base
  belongs_to :place
  belongs_to :attraction
  belongs_to :similar_place, class_name: "Place"
  belongs_to :similar_place, class_name: "Attraction"
end
