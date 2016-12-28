class AddDefaultChildItem < ActiveRecord::Migration
  def change
  	change_column :child_items, :itemable_type, :string, :default => "", :null => false
  	change_column :child_items, :itemable_id, :integer, :default => 0, :null => false
  	change_column :child_items, :parentable_type, :string, :default => "", :null => false
  	change_column :child_items, :parentable_id, :integer, :default => 0, :null => false
  end
end