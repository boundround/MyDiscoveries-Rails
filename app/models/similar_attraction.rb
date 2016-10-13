class SimilarAttraction < ActiveRecord::Base
  belongs_to :attraction
  belongs_to :similar_place, class_name: "Attraction"
end
