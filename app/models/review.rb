class Review < ActiveRecord::Base
  belongs_to :reviewable, polymorphic: true
  belongs_to :user

  scope :active, -> { where(status: "live") }
end
