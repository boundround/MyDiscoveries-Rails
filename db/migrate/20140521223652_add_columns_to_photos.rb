class AddColumnsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :fun_fact, :string
    add_column :photos, :sound_sprite, :string
  end
end
