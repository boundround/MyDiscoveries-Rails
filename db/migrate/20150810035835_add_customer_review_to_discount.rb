class AddCustomerReviewToDiscount < ActiveRecord::Migration
  def change
    add_column :discounts, :customer_review, :boolean
    add_column :discounts, :customer_approved, :boolean
    add_column :discounts, :approved_at, :datetime
  end
end
