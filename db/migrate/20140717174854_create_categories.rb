class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :identifier

      t.timestamps
    end
    add_index :categories, :identifier, unique: true
  end
end
