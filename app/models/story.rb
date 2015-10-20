class Story < ActiveRecord::Base
  # after_update :send_live_notification

  belongs_to :user
  belongs_to :storiable, polymorphic: true
  has_many :user_photos, -> { order "story_priority ASC"}, :inverse_of => :story

  has_many :stories_users
  has_many :users, through: :stories_users

  accepts_nested_attributes_for :user_photos

  scope :active, -> { where(status: "live") }
  scope :draft, -> { where(status: "draft") }
  scope :user_already_notified_today, -> { where('user_notified_at > ?', Time.now.at_beginning_of_day) }

  def send_live_notification
    places = []
    self.user.stories.user_already_notified_today.each do |story|
     places.push story.place
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
