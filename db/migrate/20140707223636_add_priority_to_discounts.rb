class AddPriorityToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :priority, :integer
  end
end
