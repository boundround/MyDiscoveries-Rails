class Review < ActiveRecord::Base
  after_update :send_live_notification

  validates :content, presence: true
  validates :user_id, presence: true
  belongs_to :reviewable, polymorphic: true
  belongs_to :user

  scope :active, -> { where(status: "live") }

  def send_live_notification
    if (self.status_changed? && self.status == "live" && self.status_was == "draft")
      if self.user && !self.user.email.blank? && !self.user.email.match(/^change@me/)
        LiveNotification.delay.review_notification(self)
      end
    end
  end
end
