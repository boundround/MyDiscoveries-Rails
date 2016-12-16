class Subcategory < ActiveRecord::Base
	include Parameterizable

	scope :get_all_informations, -> { where(category_type: ["Optimum Time", "Duration", "Subcategory", "Accessibility", "Price"] ) }

	scope :subcats, -> { where(category_type: "subcategory") }
	scope :price_categories, -> { where(category_type: "price") }

	before_save :parameterize_identifier

	has_many :places_subcategories, :dependent => :destroy
	has_many :places, through: :places_subcategories

	has_many :attractions_subcategories, :dependent => :destroy
	has_many :attractions, through: :attractions_subcategories

	has_many :attractions_subcategories, :dependent => :destroy
	has_many :attractions, through: :attractions_subcategories

	has_many :stories_subcategories
	has_many :stories, through: :stories_subcategories

	mount_uploader :icon, IconUploader

	serialize :related_to, Array


	def self.get_data_by_type(records, type)
		records.find_all{|r|r.category_type.eql?(type)}
	end

	def subcategory_related
		subcategories = []
		self.related_to.each do |category|
			subcategories << Subcategory.find(category)
		end
		return subcategories
	end

	private

		def algolia_id
			"algolia_subcategory_#{self.id}"
		end

end
