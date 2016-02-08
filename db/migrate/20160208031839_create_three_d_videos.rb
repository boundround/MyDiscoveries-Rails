class CreateThreeDVideos < ActiveRecord::Migration
  def change
    create_table :three_d_videos do |t|
      t.string :link
      t.string :caption
      t.references :place, index: true

      t.timestamps
    end
  end
end
