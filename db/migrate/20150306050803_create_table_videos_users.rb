class CreateTableVideosUsers < ActiveRecord::Migration
  def change
    create_table :videos_users do |t|
      t.integer :user_id
      t.integer :video_id
    end
  end
end
