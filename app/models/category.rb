class Category < ActiveRecord::Base
  has_many :places, through: :categories_places
  has_many :categories_places
end
