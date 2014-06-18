class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.integer :vimeo_id
      t.references :area, index: true

      t.timestamps
    end
  end
end
