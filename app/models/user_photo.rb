class UserPhoto < ActiveRecord::Base
  attr_accessor :user_notified
  # validates :path, presence: true
  after_update :send_live_notification, unless: "user_notified"

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
  scope :user_already_notified_today, -> { where('user_notified_at > ?', Time.now.at_beginning_of_day) }

  def send_live_notification
    if self.story_id.blank?

      places = []
      self.user.user_photos.user_already_notified_today.each do |photo|
       places.push photo.place
      end

      unless places.include?(self.place)
        if (self.status_changed? && self.status == "live" && self.status_was == "draft")
          if self.user && !self.user.email.blank? && !self.user.email.match(/^change@me/)
            LiveNotification.delay_until(Time.now.at_end_of_day).notification(self.place, self.user)
            self.user_notified = true
            self.user_notified_at = Time.now
            self.save
          end
        end
      end

    end
  end

end
