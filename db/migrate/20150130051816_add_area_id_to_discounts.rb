class AddAreaIdToDiscounts < ActiveRecord::Migration
  def change
    add_column :discounts, :area_id, :integer
  end
end
