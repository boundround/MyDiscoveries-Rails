class AddLineItemIdToPassengers < ActiveRecord::Migration
  def change
    add_column :passengers, :line_item_id, :integer
    add_index :passengers, :line_item_id
  end
end
