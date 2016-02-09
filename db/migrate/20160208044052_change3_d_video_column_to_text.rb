class Change3DVideoColumnToText < ActiveRecord::Migration
  def change
    change_column :three_d_videos, :link, :text
  end
end
