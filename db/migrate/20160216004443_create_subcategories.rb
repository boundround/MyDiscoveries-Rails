class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategories do |t|
      t.text :name
      t.text :type

      t.timestamps
    end
  end
end
