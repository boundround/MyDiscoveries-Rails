class CreateCountrsPostsJoinTable < ActiveRecord::Migration
  def change
    create_join_table :countries, :posts do |t|
      t.index [:country_id, :post_id]
      t.index [:post_id, :country_id]
    end
  end
end
