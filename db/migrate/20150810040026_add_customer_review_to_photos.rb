class AddCustomerReviewToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :customer_review, :boolean
    add_column :photos, :customer_approved, :boolean
    add_column :photos, :approved_at, :datetime
  end
end
