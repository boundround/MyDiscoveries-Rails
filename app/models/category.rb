class Category < ActiveRecord::Base
  self.primary_key = "identifier"

  has_many :categorizations
  has_many :places, through: :categorizations
end
