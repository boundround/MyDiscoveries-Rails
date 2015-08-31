class UserPhoto < ActiveRecord::Base
  belongs_to :user
  belongs_to :story
  belongs_to :place
  belongs_to :area

  mount_uploader :path, UserPhotoUploader

  scope :active, -> { where(status: "live") }
  scope :draft, -> { where(status: "draft") }
end
