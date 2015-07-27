class CountriesVideos < ActiveRecord::Migration
  def change
    create_table :countries_videos do |t|
      t.integer :country_id
      t.integer :video_id
    end
  end
end
