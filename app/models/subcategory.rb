class Subcategory < ActiveRecord::Base
	include Parameterizable

	scope :get_all_informations, -> { where(category_type: ["Optimum Time", "Duration", "Subcategory", "Accessibility", "Price"] ) }

	scope :subcats, -> { where(category_type: "subcategory") }

	before_save :parameterize_identifier

	has_many :places_subcategories, :dependent => :destroy
	has_many :places, through: :places_subcategories

	mount_uploader :icon, IconUploader


	def self.get_data_by_type(records, type)
		records.find_all{|r|r.category_type.eql?(type)}
	end

end

