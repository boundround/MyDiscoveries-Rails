class AddFieldAttractionIdToTableThreeDVideos < ActiveRecord::Migration
  def change
  	add_column :three_d_videos, :attraction_id, :integer, :index => true
  end
end
