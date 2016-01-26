class PrimaryCategory < ActiveRecord::Base
  include Parameterizable
  before_save :parameterize_identifier
  has_many :places
end
