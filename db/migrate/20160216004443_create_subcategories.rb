class CreateSubcategories < ActiveRecord::Migration
  def change
    drop_table :subcategories
    create_table :subcategories do |t|
      t.text :name
      t.text :type

      t.timestamps
    end
  end
end
