class Review < ActiveRecord::Base
  validates :content, presence: true
  validates :user_id, presence: true
  belongs_to :reviewable, polymorphic: true
  belongs_to :user

  scope :active, -> { where(status: "live") }
end
