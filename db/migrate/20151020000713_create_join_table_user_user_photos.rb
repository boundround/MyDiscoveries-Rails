class CreateJoinTableUserUserPhotos < ActiveRecord::Migration
  def change
    create_join_table :users, :user_photos do |t|
      t.index [:user_id, :user_photo_id]
      t.index [:user_photo_id, :user_id]
    end
  end
end
