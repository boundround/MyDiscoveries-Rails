class AddPostCodeToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :post_code, :string
  end
end
