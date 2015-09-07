class UserPhoto < ActiveRecord::Base
  # validates :path, presence: true

  belongs_to :user
  belongs_to :story
  belongs_to :place
  belongs_to :area

  mount_uploader :path, UserPhotoUploader
  # process_in_background :path ###This is not working for versions

  scope :active, -> { where(status: "live") }
  scope :draft, -> { where(status: "draft") }
end
