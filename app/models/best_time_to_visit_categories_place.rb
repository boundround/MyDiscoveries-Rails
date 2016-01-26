class BestTimeToVisitCategoriesPlace < ActiveRecord::Base
  belongs_to :best_time_to_visit_category
  belongs_to :place
end
