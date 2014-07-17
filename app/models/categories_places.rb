class CategoriesPlaces < ActiveRecord::Base
  belongs_to :categories
  belongs_to :places
end
