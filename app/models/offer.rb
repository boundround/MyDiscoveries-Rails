class Offer < ActiveRecord::Base
  belongs_to :attraction

  validates_presence_of :name
end
