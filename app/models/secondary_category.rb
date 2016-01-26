class SecondaryCategory < ActiveRecord::Base
  include Parameterizable
  before_save :parameterize_identifier
  has_many :places_secondary_categories
  has_many :places, through: :places_secondary_categories
end
