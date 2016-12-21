class Deal < ActiveRecord::Base
  before_save :truncate_description

  belongs_to :dealable, polymorphic: true
  validates :dealable, presence: true

  has_many :deals_users
  has_many :users, through: :deals_users

  mount_uploader :hero_image, DealHeroUploader

  scope :active, -> { where(status: "live") }

  def truncate_description
    self.description = self.description[0..254] if self.description.size > 255
  end
end
