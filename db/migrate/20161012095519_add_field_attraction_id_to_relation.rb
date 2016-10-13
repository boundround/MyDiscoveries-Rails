class AddFieldAttractionIdToRelation < ActiveRecord::Migration
  def change
    add_column :videos, :attraction_id, :integer
    add_column :photos, :attraction_id, :integer
    add_column :user_photos, :attraction_id, :integer
    add_column :fun_facts, :attraction_id, :integer
  end
end
