class CreateCategoriesPlaces < ActiveRecord::Migration
  def change
    create_table :categories_places, id: false do |t|
      t.integer :category
      t.integer :place

      t.timestamps
    end
  end
end
