class PrimaryCategory < ActiveRecord::Base
  include Parameterizable
  before_save :parameterize_identifier
  has_many :places

  mount_uploader :icon, IconUploader

  attr_accessor :sub_categories

  def get_sub_categories
  	if self.sub_categories.blank?
	  	self.sub_categories ||= []
	  	places.each do |place|
				place.subcategories.each do |sub|
					self.sub_categories << sub
				end
			end
		end
		self.sub_categories.compact.uniq
  end

end
