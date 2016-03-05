class Subcategory < ActiveRecord::Base
	include Parameterizable

	scope :get_all_informations, -> { where(category_type: ["Optimum Time", "Duration", "Subcategory", "Accessibility", "Price"] ) }

	before_save :parameterize_identifier
	
	has_many :places_subcategories
	has_many :places, through: :places_subcategories


	def self.get_data_by_type(records, type)
		records.find_all{|r|r.category_type.eql?(type)}
	end

end

