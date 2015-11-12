class Transaction < ActiveRecord::Base
  belongs_to :user
  after_create :update_points_balance
  before_destroy :update_points_balance
  validates :user_id, presence: true

  attr_accessor :user_username

  def update_points_balance
    points_balance = PointsBalance.find_or_create_by(user_id: self.user.id)

    if self.points
      points = self.points
    elsif !self.points && self.asset_type
      points = PointsValue.find_by(asset_type: self.asset_type)
    end

    points_balance.balance += points
    points_balance.save
  end
end
