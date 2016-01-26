class DurationCategoriesPlace < ActiveRecord::Base
  belongs_to :duration_category
  belongs_to :place
end
