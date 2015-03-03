class CreateJoinTableUserArea < ActiveRecord::Migration
  def change
    create_join_table :users, :areas do |t|
      # t.index [:user_id, :area_id]
      # t.index [:area_id, :user_id]
    end
  end
end
