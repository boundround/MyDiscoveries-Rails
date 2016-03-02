class Subcategory < ActiveRecord::Base
	include Parameterizable

	scope :best_visited, -> { where(category_type: "Optimum Time") }
	scope :duration, -> { where(category_type: "Duration") }
	scope :subcategory, -> { where(category_type: "Subcategory") }
	scope :accessibility, -> { where(category_type: "Accessibility") }
	scope :price, -> { where(category_type: "Price") }
	
  before_save :parameterize_identifier
  has_many :places_subcategories
  has_many :places, through: :places_subcategories
end

