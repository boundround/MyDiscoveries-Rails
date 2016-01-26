class CreatePrimaryCategories < ActiveRecord::Migration
  def change
    create_table :primary_categories do |t|
      t.string :name
      t.string :identifier
      t.string :icon

      t.timestamps
    end
  end
end
