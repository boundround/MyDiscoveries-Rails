class AccessibilityCategory < ActiveRecord::Base
  has_many :accessibility_categories_places
  has_many :places, through: :accessibility_categories_places
end
