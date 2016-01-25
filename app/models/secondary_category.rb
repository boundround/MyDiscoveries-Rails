class SecondaryCategory < ActiveRecord::Base
  has_many :places_secondary_categories
  has_many :places, through: :places_secondary_categories
end
