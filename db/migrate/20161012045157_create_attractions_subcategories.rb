class CreateAttractionsSubcategories < ActiveRecord::Migration
  def change
    create_table :attractions_subcategories do |t|
      t.integer :attraction_id
      t.integer :subcategory_id
      t.text :desc

    end
  end
end
