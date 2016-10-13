class SimilarPlace < ActiveRecord::Base
  belongs_to :place
  belongs_to :similar_place, class_name: "Place"
end
