class SimilarAttraction < ActiveRecord::Base
  belongs_to :attraction
  belongs_to :similar_attraction, class_name: "Attraction"
end
