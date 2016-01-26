class BestTimeToVisitCategory < ActiveRecord::Base
  has_many :best_time_to_visit_categories_places
  has_many :places, through: :best_time_to_visit_categories_places
end
