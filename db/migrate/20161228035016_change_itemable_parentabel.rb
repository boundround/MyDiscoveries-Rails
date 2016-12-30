class ChangeItemableParentabel < ActiveRecord::Migration
  def change
  	change_column :child_items, :itemable_type, :string, :null => false
  	change_column :child_items, :itemable_id, :integer, :null => false
  	change_column :child_items, :parentable_type, :string, :null => false
  	change_column :child_items, :parentable_id, :integer, :null => false
  end
end
