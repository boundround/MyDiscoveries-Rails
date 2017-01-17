class Category < ActiveRecord::Base
  include Parameterizable

  before_save :parameterize_identifier
end
