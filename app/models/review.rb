class Review < ActiveRecord::Base
  include Transactionable
  after_update :add_transaction

  validates :content, presence: true
  validates :user_id, presence: true
  validates :reviewable, presence: true
  belongs_to :reviewable, polymorphic: true
  belongs_to :user
  belongs_to :country

  has_many :reviews_users
  has_many :users, through: :reviews_users

  scope :active, -> { where(status: "live") }
  scope :user_already_notified_today, -> { where('user_notified_at > ?', Time.now.at_beginning_of_day) }

  def send_live_notification

    places = []
    self.user.reviews.user_already_notified_today.each do |review|
     places.push review.reviewable
    end

    unless places.include?(self.reviewable)
      if (self.status_changed? && self.status == "live" && self.status_was == "draft")
        if self.user && !self.user.email.blank? && !self.user.email.match(/^change@me/)
          LiveNotification.delay_until(Time.now.at_end_of_day).notification(self.reviewable, self.user)
          self.user_notified = true
          self.user_notified_at = Time.now
          self.save
        end
      end
    end

  end
end
