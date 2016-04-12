class AddParentToPlace < ActiveRecord::Migration
  def change
    add_column :places, :parent_id, :integer
    add_index :places, :parent_id
  end
end
