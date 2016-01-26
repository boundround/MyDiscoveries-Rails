class CreateAccessibilityCategories < ActiveRecord::Migration
  def change
    create_table :accessibility_categories do |t|
      t.string :name
      t.string :identifier

      t.timestamps
    end
  end
end
