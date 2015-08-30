class Story < ActiveRecord::Base
  belongs_to :user
  has_many :user_photos, :inverse_of => :story

  accepts_nested_attributes_for :user_photos
end
