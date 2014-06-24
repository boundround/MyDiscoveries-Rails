class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :description
      t.string :code
      t.string :identifier
      t.string :display_name
      t.string :type
      t.string :icon
      t.string :map_icon
      t.string :passport_icon
      t.references :area, index: true

      t.timestamps
    end
  end
end
