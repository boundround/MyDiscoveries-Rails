class UserPhoto < ActiveRecord::Base
  # validates :path, presence: true
  after_update :send_live_notification

  belongs_to :user
  belongs_to :story
  belongs_to :place
  belongs_to :area

  mount_uploader :path, UserPhotoUploader
  # process_in_background :path ###This is not working for versions

  scope :active, -> { where(status: "live") }
  scope :draft, -> { where(status: "draft") }
  scope :active_path, -> { where('path is NOT NULL')}
  scope :no_story, -> { where('story_id IS NULL')}

  def send_live_notification
    if (self.status_changed? && self.status == "live" && self.status_was == "draft")
      if self.user && !self.user.email.blank? && !self.user.email.match(/^change@me/)
        LiveNotification.delay.photo_notification(self)
      end
    end
  end
end
