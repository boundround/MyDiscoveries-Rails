class CreateOffersVideos < ActiveRecord::Migration
  def change
    create_table :offers_videos do |t|
      t.integer :offer_id
      t.integer :video_id
    end

    add_index :offers_videos, :offer_id
    add_index :offers_videos, [:offer_id, :video_id], unique: true
  end
end
