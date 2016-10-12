class Category < ActiveRecord::Base
  include Parameterizable

  before_save :parameterize_identifier
  has_many :categorizations
  has_many :places, through: :categorizations
  has_many :attractions, through: :categorizations
end
