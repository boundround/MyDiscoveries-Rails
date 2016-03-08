class Subcategory < ActiveRecord::Base
	include Parameterizable
  before_save :parameterize_identifier
  has_many :places_subcategories
  has_many :places, through: :places_subcategories
end

