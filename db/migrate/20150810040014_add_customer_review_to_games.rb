class AddCustomerReviewToGames < ActiveRecord::Migration
  def change
    add_column :games, :customer_review, :boolean
    add_column :games, :customer_approved, :boolean
    add_column :games, :approved_at, :datetime
  end
end
