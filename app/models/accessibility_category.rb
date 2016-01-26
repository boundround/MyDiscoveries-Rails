class AccessibilityCategory < ActiveRecord::Base
  include Parameterizable
  before_save :parameterize_identifier

  has_many :accessibility_categories_places
  has_many :places, through: :accessibility_categories_places

end
