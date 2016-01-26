class CreateDurationCategories < ActiveRecord::Migration
  def change
    create_table :duration_categories do |t|
      t.string :name
      t.string :identifier

      t.timestamps
    end
  end
end
