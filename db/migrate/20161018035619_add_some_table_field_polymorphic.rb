class AddSomeTableFieldPolymorphic < ActiveRecord::Migration
  def change
    add_column :photos, :photoable_id, :integer
    add_column :photos, :photoable_type, :string
    add_column :videos, :videoable_id, :integer
    add_column :videos, :videoable_type, :string
    add_column :three_d_videos, :three_d_videoable_id, :integer
    add_column :three_d_videos, :three_d_videoable_type, :string
  end
end