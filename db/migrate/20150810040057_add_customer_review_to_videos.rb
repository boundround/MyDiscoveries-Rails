class AddCustomerReviewToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :customer_review, :boolean
    add_column :videos, :customer_approved, :boolean
    add_column :videos, :approved_at, :datetime
  end
end
