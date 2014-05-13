class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :code
      t.string :identifier
      t.string :country
      t.string :display_name
      t.string :short_intro
      t.string :description
      t.float :icon_latitude
      t.float :icon_longitude

      t.timestamps
    end
  end
end
