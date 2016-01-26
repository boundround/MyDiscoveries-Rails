class DurationCategory < ActiveRecord::Base
  include Parameterizable
  before_save :parameterize_identifier
  has_many :duration_categories_places
  has_many :places, through: :duration_categories_places
end
