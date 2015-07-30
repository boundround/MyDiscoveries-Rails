class AddStatusToDiscount < ActiveRecord::Migration
  def change
    add_column :discounts, :status, :string
  end
end
