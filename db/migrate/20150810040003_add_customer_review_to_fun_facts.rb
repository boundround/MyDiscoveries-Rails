class AddCustomerReviewToFunFacts < ActiveRecord::Migration
  def change
    add_column :fun_facts, :customer_review, :boolean
    add_column :fun_facts, :customer_approved, :boolean
    add_column :fun_facts, :approved_at, :datetime
  end
end
