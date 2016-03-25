class PrimaryCategory < ActiveRecord::Base
  include Parameterizable
  include AlgoliaSearch
  algoliasearch index_name: "place_#{Rails.env}", id: :algolia_primary_category_id do
  	attribute :name, :identifier
	end

  before_save :parameterize_identifier
  has_many :places

  mount_uploader :icon, IconUploader

  attr_accessor :subcategories

  def get_subcategories
  	Subcategory.where(category_type: "subcategory").limit(6)
  end

  private

  	def algolia_primary_category_id
  		"primary_category_#{self.id}"
  	end

end
