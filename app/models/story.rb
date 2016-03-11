class Story < ActiveRecord::Base
  include Transactionable
  after_update :add_transaction
  # after_update :send_live_notification

  belongs_to :user
  belongs_to :storiable, polymorphic: true
  belongs_to :country
  has_many :user_photos, -> { order "story_priority ASC"}, :inverse_of => :story

  has_many :stories_users
  has_many :users, through: :stories_users

  accepts_nested_attributes_for :user_photos, reject_if: :all_blank, allow_destroy: true

  scope :active, -> { where(status: "live") }
  scope :draft, -> { where(status: "draft") }
  scope :user_already_notified_today, -> { where('user_notified_at > ?', Time.now.at_beginning_of_day) }

  attr_accessor :age_bracket

  AGE_BRACKET= { toddlers: 5..8, kids: 9..12, teenagers: 13..19, adults: 20..50 }

  validates :title, presence: true
  validates :content, presence: true
  validates :date, presence: true

  before_save :determine_age_bracket

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

  protected

    def determine_age_bracket
      if age_bracket.present?
        self.min_age = AGE_BRACKET[age_bracket.to_sym].try(:first)
        self.max_age = AGE_BRACKET[age_bracket.to_sym].try(:last)
      end
    end

end
