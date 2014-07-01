class AddPriorityColumnToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :priority, :integer
  end
end
