class CreateSecondaryCategories < ActiveRecord::Migration
  def change
    create_table :secondary_categories do |t|
      t.string :name
      t.string :identifier

      t.timestamps
    end
  end
end
