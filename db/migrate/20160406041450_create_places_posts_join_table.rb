class CreatePlacesPostsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :places, :posts do |t|
      t.index [:place_id, :post_id]
      t.index [:post_id, :place_id]
    end
  end
end
