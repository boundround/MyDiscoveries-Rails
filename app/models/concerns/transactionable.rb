require 'active_support/concern'

module Transactionable
  extend ActiveSupport::Concern

  def add_transaction
    if (self.status_changed? && self.status == "live" && self.status_was == "draft")
      points = PointsValue.find_by(asset_type: self.class.to_s)

      if points
        Transaction.create!(points: points.value, user_id: self.user.id, asset_type: self.class.to_s)
      end
    end
  end

  def add_transaction_for_live_asset
    points = PointsValue.find_by(asset_type: self.class.to_s)

    if points
      Transaction.create!(points: points.value, user_id: self.user.id, asset_type: self.class.to_s)
    end
  end
end
