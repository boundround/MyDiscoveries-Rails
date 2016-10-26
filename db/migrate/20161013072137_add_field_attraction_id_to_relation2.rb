class AddFieldAttractionIdToRelation2 < ActiveRecord::Migration
  def change
    add_column :programs, :attraction_id, :integer
    add_column :stamps, :attraction_id, :integer
  end
end
