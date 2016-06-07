class AddPrimaryCategoryToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :primary_category_id, :integer
    add_index :posts, :primary_category_id
  end
end
