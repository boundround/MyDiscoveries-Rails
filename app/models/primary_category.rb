class PrimaryCategory < ActiveRecord::Base
  include Parameterizable
  before_save :parameterize_identifier
  has_many :places

  mount_uploader :icon, IconUploader

  attr_accessor :subcategories

  def get_subcategories
  	Subcategory.where(category_type: "subcategory").limit(6)
  end

end
