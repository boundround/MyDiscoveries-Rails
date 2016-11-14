class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :display_name
      t.string :slug
      t.text :description
      t.decimal :latitude
      t.decimal :longitude
      t.integer :zoom_level

      t.timestamps
    end
  end
end
