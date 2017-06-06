class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :name
      t.string :slug
      t.string :cruise_line
      t.text   :overview
      t.text   :facilities
      t.string :map

      t.timestamps
    end
  end
end
