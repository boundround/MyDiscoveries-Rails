class Story < ActiveRecord::Base
  after_update :send_live_notification

  belongs_to :user
  belongs_to :storiable, polymorphic: true
  has_many :user_photos, -> { order "story_priority ASC"}, :inverse_of => :story

  accepts_nested_attributes_for :user_photos

  scope :active, -> { where(status: "live") }
  scope :draft, -> { where(status: "draft") }

  def send_live_notification
    if (self.status_changed? && self.status == "live" && self.status_was == "draft")
      if self.user && !self.user.email.blank? && !self.user.email.match(/^change@me/)
        LiveNotification.delay.story_notification(self)
      end
    end
  end
end
