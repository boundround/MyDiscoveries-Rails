class Category < ActiveRecord::Base
  include Parameterizable
  before_save :parameterize_identifier
  has_many :categorizations
  has_many :places, through: :categorizations
end
