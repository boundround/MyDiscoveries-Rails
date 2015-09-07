class Story < ActiveRecord::Base
  belongs_to :user
  belongs_to :storiable, polymorphic: true
  has_many :user_photos, :inverse_of => :story

  accepts_nested_attributes_for :user_photos

  scope :active, -> { where(status: "live") }
  scope :draft, -> { where(status: "draft") }
end
