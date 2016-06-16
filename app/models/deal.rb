class Deal < ActiveRecord::Base
  belongs_to :dealable, polymorphic: true
  validates :dealable, presence: true

  mount_uploader :hero_image, DealHeroUploader

  scope :active, -> { where(status: "live") }
end
