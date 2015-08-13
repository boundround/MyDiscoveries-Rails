class AddCustomerReviewToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :customer_review, :boolean
    add_column :places, :customer_approved, :boolean
    add_column :places, :approved_at, :datetime
  end
end
