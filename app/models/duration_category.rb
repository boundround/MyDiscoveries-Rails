class DurationCategory < ActiveRecord::Base
  has_many :duration_categories_places
  has_many :places, through: :duration_categories_places
end
