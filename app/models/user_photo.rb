class UserPhoto < ActiveRecord::Base
  include Transactionable

  attr_accessor :user_notified
  # validates :path, presence: true
  #after_update :send_live_notification, unless: "user_notified"
  #after_update :add_transaction

  belongs_to :user
  belongs_to :story
  belongs_to :place
  belongs_to :country

  has_many :user_photos_users
  has_many :users, through: :user_photos_users

  mount_uploader :path, UserPhotoUploader
  # process_in_background :path ###This is not working for versions

  scope :active, -> { where(status: "live") }
  scope :recent, -> { order('created_at DESC') }
  scope :draft, -> { where(status: "draft") }
  scope :active_path, -> { where('path is NOT NULL')}
  scope :no_story, -> { where('story_id IS NULL')}
  scope :user_already_notified_today, -> { where('user_notified_at > ?', Time.now.at_beginning_of_day) }

  def published?
    if self.status == "live"
      true
    else
      false
    end
  end

  def credit
    if user.username
      if user.username.match(/@/)
        user.username.match(/^(.*?)@/)[1]
      else
        user.username
      end
    elsif user.email
      if user.email.match(/@/)
        user.email.match(/^(.*?)@/)[1]
      else
        user.username
      end
    else
      ""
    end
  end

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
