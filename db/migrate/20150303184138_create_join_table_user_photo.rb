class CreateJoinTableUserPhoto < ActiveRecord::Migration
  def change
    create_join_table :users, :photos do |t|
      # t.index [:user_id, :photo_id]
      # t.index [:photo_id, :user_id]
    end
  end
end
